-- =====================================================================
-- Migration C1: orders that can be fulfilled (cash on delivery, Damascus)
-- Project: Halbouni (ghzqbleakxfajzfrjudr)
-- Status: DRAFT for owner review. NOT applied.
-- Implements PROJECT_CONTEXT.md section 9b.
-- Runs as one transaction: any failure rolls everything back.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 0. Wipe test orders (owner approved test-data deletion).
--    Live DB has 13 orders (context file says 12); see review notes.
-- ---------------------------------------------------------------------
delete from public.order_items where true;
delete from public.orders where true;

-- ---------------------------------------------------------------------
-- 1. Settings (delivery fee). No client policies: read via get_delivery_fee().
-- ---------------------------------------------------------------------
create table public.app_settings (
  key           text primary key,
  value_numeric numeric not null,
  updated_at    timestamptz not null default now()
);
alter table public.app_settings enable row level security;
create policy "Admins can manage app_settings" on public.app_settings
  for all using (is_admin()) with check (is_admin());
insert into public.app_settings (key, value_numeric) values ('delivery_fee', 0);

-- ---------------------------------------------------------------------
-- 2. Profiles: contact fields
-- ---------------------------------------------------------------------
alter table public.profiles
  add column phone         text,
  add column delivery_area text,
  add column address       text;

-- ---------------------------------------------------------------------
-- 3. Orders: contact snapshot, delivery fee, COD statuses
-- ---------------------------------------------------------------------
alter table public.orders
  add column customer_name    text not null,
  add column customer_phone   text not null,
  add column delivery_area    text,
  add column delivery_address text not null,
  add column delivery_fee     numeric not null default 0 check (delivery_fee >= 0);

alter table public.orders alter column status set not null;
alter table public.orders drop constraint orders_status_check;
alter table public.orders add constraint orders_status_check
  check (status in ('pending','confirmed','out_for_delivery','delivered','cancelled'));

-- ---------------------------------------------------------------------
-- 4. Order items: name snapshot
-- ---------------------------------------------------------------------
alter table public.order_items
  add column product_name text not null;
alter table public.order_items alter column order_id set not null;
alter table public.order_items add constraint order_items_quantity_check check (quantity > 0);
-- order_items.product_id keeps NO ACTION: a book that was ever ordered cannot be
-- hard-deleted. Admin uses soft delete (is_active).

-- ---------------------------------------------------------------------
-- 5. Products: integrity + hide inactive from the public
-- ---------------------------------------------------------------------
update public.products set stock_quantity = 0 where stock_quantity is null;
alter table public.products
  alter column stock_quantity set default 0,
  alter column stock_quantity set not null;
alter table public.products add constraint products_stock_check check (stock_quantity >= 0);
alter table public.products add constraint products_price_check check (price > 0);

drop policy "Allow public read access" on public.products;
create policy "Public can read active products" on public.products
  for select using (is_active or is_admin());

-- ---------------------------------------------------------------------
-- 6. Functions
-- ---------------------------------------------------------------------

-- 6a. Delivery fee
create function public.get_delivery_fee()
returns numeric
language plpgsql stable security definer set search_path = public
as $$
declare fee numeric;
begin
  if auth.uid() is null then raise exception 'NOT_AUTHENTICATED'; end if;
  select value_numeric into fee from public.app_settings where key = 'delivery_fee';
  return coalesce(fee, 0);
end;
$$;

create function public.set_delivery_fee(new_fee numeric)
returns void
language plpgsql security definer set search_path = public
as $$
begin
  if not is_admin() then raise exception 'not authorized'; end if;
  if new_fee is null or new_fee < 0 or new_fee <> trunc(new_fee) then
    raise exception 'INVALID_FEE';
  end if;
  insert into public.app_settings (key, value_numeric, updated_at)
  values ('delivery_fee', new_fee, now())
  on conflict (key) do update set value_numeric = excluded.value_numeric, updated_at = now();
end;
$$;

-- 6b. Allowed transitions (single source of truth, admin apps read this)
create function public.allowed_order_transitions(current_status text)
returns text[]
language plpgsql stable security definer set search_path = public
as $$
begin
  if not is_admin() then raise exception 'not authorized'; end if;
  return case current_status
    when 'pending'          then array['confirmed','cancelled']
    when 'confirmed'        then array['out_for_delivery','cancelled']
    when 'out_for_delivery' then array['delivered','cancelled']
    else array[]::text[]
  end;
end;
$$;

-- 6c. place_order: replaces the (jsonb, text) version, which skipped stock checks
drop function public.place_order(jsonb, text);

create function public.place_order(
  items            jsonb,
  order_notes      text default null,
  customer_name    text default null,
  customer_phone   text default null,
  delivery_area    text default null,
  delivery_address text default null
)
returns uuid
language plpgsql security definer set search_path = public
as $$
declare
  v_uid      uuid := auth.uid();
  v_name     text := nullif(btrim(customer_name), '');
  v_addr     text := nullif(btrim(delivery_address), '');
  v_area     text := nullif(btrim(delivery_area), '');
  v_notes    text := nullif(btrim(order_notes), '');
  v_digits   text;
  v_phone    text;
  v_fee      numeric;
  v_total    numeric := 0;
  v_order_id uuid;
  r          record;
  p          record;
begin
  if v_uid is null then raise exception 'NOT_AUTHENTICATED'; end if;

  if items is null or jsonb_typeof(items) <> 'array' or jsonb_array_length(items) = 0 then
    raise exception 'EMPTY_CART';
  end if;

  -- contact validation (client validates too; server is authoritative)
  v_digits := regexp_replace(coalesce(customer_phone, ''), '[\s\-]', '', 'g');
  if v_name is null or char_length(v_name) > 100
     or v_addr is null or char_length(v_addr) > 300
     or (v_area is not null and char_length(v_area) > 100)
     or v_digits !~ '^(\+963|00963|0)?9[0-9]{8}$' then
    raise exception 'INVALID_CONTACT';
  end if;
  v_phone := '0' || right(v_digits, 9);

  select value_numeric into v_fee from public.app_settings where key = 'delivery_fee';
  v_fee := coalesce(v_fee, 0);

  insert into public.orders
    (user_id, total, status, notes, customer_name, customer_phone,
     delivery_area, delivery_address, delivery_fee)
  values
    (v_uid, 0, 'pending', v_notes, v_name, v_phone, v_area, v_addr, v_fee)
  returning id into v_order_id;

  begin
    -- merge duplicate lines; lock products in id order to avoid deadlocks
    for r in
      select (e ->> 'product_id')::uuid        as pid,
             sum((e ->> 'quantity')::int)      as qty,
             min((e ->> 'quantity')::int)      as minq
      from jsonb_array_elements(items) e
      group by 1
      order by 1
    loop
      if r.pid is null or r.qty is null or r.minq < 1 or r.qty > 20 then
        raise exception 'INVALID_ITEM';
      end if;

      select id, name, price, stock_quantity, is_active
        into p
        from public.products
       where id = r.pid
       for update;

      if not found or not p.is_active then
        raise exception 'PRODUCT_UNAVAILABLE:%', r.pid;
      end if;
      if p.stock_quantity < r.qty then
        raise exception 'OUT_OF_STOCK:%:%', r.pid, p.stock_quantity;
      end if;

      insert into public.order_items (order_id, product_id, product_name, quantity, price)
      values (v_order_id, p.id, p.name, r.qty, p.price);

      update public.products set stock_quantity = stock_quantity - r.qty where id = p.id;
      v_total := v_total + p.price * r.qty;
    end loop;
  exception
    when invalid_text_representation or numeric_value_out_of_range then
      raise exception 'INVALID_ITEM';
  end;

  update public.orders set total = v_total + v_fee where id = v_order_id;
  return v_order_id;
end;
$$;

-- 6d. update_order_status: transitions from allowed_order_transitions, cancel restores stock
create or replace function public.update_order_status(order_id uuid, new_status text)
returns void
language plpgsql security definer set search_path = public
as $$
declare
  cur text;
begin
  if not is_admin() then raise exception 'not authorized'; end if;

  select status into cur from public.orders where id = order_id for update;
  if cur is null then raise exception 'order not found'; end if;

  if not (new_status = any (public.allowed_order_transitions(cur))) then
    raise exception 'cannot change status from % to %', cur, new_status;
  end if;

  if new_status = 'cancelled' then
    update public.products pr
       set stock_quantity = pr.stock_quantity + s.q
      from (select oi.product_id, sum(oi.quantity) as q
              from public.order_items oi
             where oi.order_id = update_order_status.order_id
               and oi.product_id is not null
             group by oi.product_id) s
     where pr.id = s.product_id;
  end if;

  update public.orders set status = new_status where id = update_order_status.order_id;
end;
$$;

-- 6e. KPIs: revenue = delivered orders
create or replace function public.admin_dashboard_kpis()
returns json
language plpgsql security definer set search_path = public
as $$
begin
  if not is_admin() then raise exception 'not authorized'; end if;
  return (
    select json_build_object(
      'total_books',    (select count(*) from products),
      'total_orders',   (select count(*) from orders),
      'total_revenue',  (select coalesce(sum(total), 0) from orders where status = 'delivered'),
      'pending_orders', (select count(*) from orders where status = 'pending')
    )
  );
end;
$$;

-- ---------------------------------------------------------------------
-- 7. EXECUTE hardening.
--    Default PUBLIC execute must be revoked too, or revoking anon does nothing.
--    is_admin() stays executable by anon: RLS policies call it while anon reads.
-- ---------------------------------------------------------------------
revoke all on function public.place_order(jsonb, text, text, text, text, text) from public, anon;
revoke all on function public.get_delivery_fee()                 from public, anon;
revoke all on function public.set_delivery_fee(numeric)          from public, anon;
revoke all on function public.allowed_order_transitions(text)    from public, anon;
revoke all on function public.update_order_status(uuid, text)    from public, anon;
revoke all on function public.admin_dashboard_kpis()             from public, anon;
revoke all on function public.handle_new_user()                  from public, anon, authenticated;

grant execute on function public.place_order(jsonb, text, text, text, text, text) to authenticated;
grant execute on function public.get_delivery_fee()              to authenticated;
grant execute on function public.set_delivery_fee(numeric)       to authenticated;
grant execute on function public.allowed_order_transitions(text) to authenticated;
grant execute on function public.update_order_status(uuid, text) to authenticated;
grant execute on function public.admin_dashboard_kpis()          to authenticated;
