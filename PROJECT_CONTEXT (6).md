# Halbouni Book Store: Project Context (read this first)

> **Audience:** every AI tool and every human opening this project (Cursor, Claude Code, Claude chats, Copilot, new developers).
> **Maintained by:** the *orchestrator* chat (user-app chat on claude.ai, project "Halbouni BookStore").
> **Version:** v5, 2026-11-02. User app: GitHub `main` @ `0c865ea` (Spec 1 + C1 migration file merged); Spec 2A-1 is implemented on branch `customer-screens-polish` and not yet merged. Live Supabase project (Halbouni, ref `ghzqbleakxfajzfrjudr`) verified 2026-11-02 **after C1 was applied**.
> **If this file and the code disagree, trust the code and the live database, then tell the orchestrator so this file gets fixed.**

---

## 0. Rules for any AI tool working here

1. **Read this file, then read the code you will touch.** Do not assume earlier fixes are still in place.
2. **Never apply DDL, RLS, or RPC changes to the live Supabase project on your own.** Schema is owned by the orchestrator. Need a change? Write a *schema request* (table/column, why, expected shape) and stop. See section 9.
3. **No secrets in git.** Only the public Supabase URL and publishable (anon) key may be in the app. Never commit service-role keys, API keys, keystores, `.env` files.
4. **Roles come only from `app_metadata.role`** (via the `is_admin()` SQL function). `user_metadata` is user-editable and must never be used for authorization.
5. **Anything the server defines is read from the server** (statuses, allowed transitions, categories). Don't hardcode copies in the client.
6. **Keep the architecture** (section 4). Don't introduce a new state-management or DI library.
7. **Small, working, verified changes** beat big features. The goal is *efficient and reliable with minimal features*.
8. **Report format after every task:** files changed (one line each), what you verified and how, schema requests, anything that contradicted this file, result of `flutter analyze` and `flutter test`.

### Stale files in this repo: do NOT treat as truth
- `docs/BACKEND_SETUP.sql`: **deleted in Spec 1.** If it ever reappears, do not run it (wrong JWT claim, predates the live schema).
- `docs/ADMIN_DASHBOARD_PROMPT.md` (972 lines): historical, not re-verified. Section 9 and `ADMIN_CHAT_PROMPT.md` win.
- `docs/PROJECT_DESCRIPTION.md`, `docs/DESIGN_GUIDE.md`: partly refreshed; this file wins on conflict.
- `README.md`: rewritten in Spec 1 (UTF-8, run instructions, architecture, link here).

---

## 1. Product and business rules

**Halbouni Book Store** is a mobile app that sells **physical** books and board games in **Damascus**.

**Business rules (confirmed by the owner, 2026-10-22):**
- Physical goods only. No PDFs, no downloads, no print-on-demand.
- **We only sell what is in stock.** Stock is tracked per product; an item with no stock cannot be ordered.
- **There is a delivery fee** (amount/structure not yet defined, see D11). It is added to the order total on the server.
- **Sellable product kinds:** books, board games, and **stationery** (kept as a category because it will be needed soon).
- **Cash on delivery only. Delivery only inside Damascus.**
- **Currency: Syrian pound (SYP).** Since 1 Jan 2026 SYP is redenominated (100 old = 1 new, same code `SYP`). **All prices in this system are in NEW pounds**, whole numbers, no decimals. Example: a book that used to cost 2,000 old pounds is entered as 20.
- UI language is **English for now**; **Arabic (RTL) comes later**, so don't hardcode layout or strings in ways that block it.

**Audience / vision:** university students and readers in Damascus. General and cultural books first; academic books and notes (per faculty/year/course) remain in the vision for later; board games are now part of the launch storefront (own tab).

**Launch storefront (requested 2026-10-22):**
- Bottom bar with 3 tabs: **Books · Novels · Board Games**.
- New categories: **Religious books**, **Kids & Teens books**.
- **Best-sellers carousel** at the top of each tab.
- **Book description** on the details page.
- **Pull-to-refresh** in both apps.

**Engineering priority:** software that works very efficiently, even with minimal features.

**Explicitly cut or deferred:** avatar upload, per-user ratings (hide the stars), vouchers/discounts, address book, shipping-option selector, social sign-in UI with nothing behind it, PDFs, print-on-demand, online payment.

---

## 2. Who does what (orchestration)

| Actor | Owns | Does not |
|---|---|---|
| **Orchestrator chat** (user-app chat) | Roadmap, schema/RLS/RPCs, migrations, contracts, this file, user app | Admin app code |
| **Admin chat** | Admin dashboard Flutter app | Any DDL on the live project |
| **Cursor / other coding tools** | Implement scoped tasks in either repo | Architecture or schema decisions |
| **Baraa (owner)** | Product decisions, business facts, final approval | |

Repos: user app `github.com/baraa2ttar/Halbouni-book-store` (package `adv`); admin app `github.com/baraa2ttar/halbouni_admin-` (package `halbouni_admin`). One shared Supabase project (Postgres + Auth + RPC); its ref is the subdomain in `supabase_config.dart`.

---

## 3. User app: stack

Flutter (SDK `^3.7.2`), `flutter_bloc`/`bloc` (Cubit + sealed/part states), `get_it`, `go_router`, `supabase_flutter`, `hive`/`hive_flutter` (offline cart only), `dartz` (`Either<Failure,T>`), `equatable`, `cached_network_image`, `flutter_screenutil`, `responsive_framework`, `shared_preferences` (onboarding draft).

Android toolchain (works): Gradle **9.3.1**, AGP **9.1.0**, Kotlin plugin **2.4.0**, with `android.newDsl=false` and `android.builtInKotlin=false` as compatibility opt-outs. Unused dependencies are already removed.

Config: `SUPABASE_URL` / `SUPABASE_ANON_KEY` via `--dart-define`, with the (public) dev project as fallback in `lib/core/constant/supabase_config.dart`.

---

## 4. User app: architecture and map

Feature-first, three layers per feature: `data` → `domain` → `presentation` (cubits + states, views, widgets). Repos return `Either<Failure, T>`. DI in `lib/core/services/setup_service_locator.dart`. Routes in `lib/core/routing/app_router.dart`.

```
lib/
  main.dart                  Hive + Supabase init, global cubits (featured, newest, cart)
  core/                      constants, errors (Failure), routing, DI, helpers, shared widgets
  Features/                  (capital F; imports depend on it, don't rename casually)
    Home/                    catalog: featured/newest/by-category, details, categories
    search/                  name search (debounced in view, stale-response guard in cubit)
    cart/                    Hive-backed cart, cart + checkout views
    orders/                  createOrder -> place_order RPC, CheckoutCubit (double-submit guarded)
    auth/                    email/password sign-in & sign-up, ensureProfile
    onboarding/              interests, gender, age; local draft synced to profile after auth
    profile/                 profile view, recovery flow for incomplete profile
    splash/
test/                        widget_test.dart (email validator), ilike_escape_test.dart (search escaping)
```

---

## 5. Backend contract (verified live 2026-11-02, after C1)

**Row counts:** orders 0 and order_items 0 (test orders deleted in C1); products 10 (all active, **only 1 has stock > 0**); categories 11, book_details 10, profiles 20 as of 2026-10-22. All products, stock and prices are **test data** (owner-confirmed); the real catalog is added only after the system is verified (see section 8, "Catalog onboarding").

### Tables (public, RLS on)
- `categories(id, name unique, created_at)`: **flat** (no parent). Names: Adventure, Biography, Board Game, Book, Books, Fantasy, Horror, Romance, Sci-Fi, Stationery, Thriller (duplicate "Book"/"Books").
- `products(id, category_id→categories, name, description, price numeric CHECK > 0, stock_quantity int NOT NULL default 0 CHECK >= 0, image_url, is_featured, is_active default true, rating 0–5 default 0, created_at)`.
- `book_details(product_id PK→products, author NOT NULL, isbn, publisher, page_count, preview_link)`: `author` is required, which doesn't fit board games (Phase 2).
- `profiles(id PK→auth.users, full_name, email, interests text[], gender, age_range, phone, delivery_area, address, updated_at)`.
- `orders(id, user_id→auth.users, total, status NOT NULL, notes, customer_name NOT NULL, customer_phone NOT NULL, delivery_area, delivery_address NOT NULL, delivery_fee numeric NOT NULL default 0, created_at)`; `status` CHECK `pending | confirmed | out_for_delivery | delivered | cancelled`. `total` = items + `delivery_fee`.
- `order_items(id, order_id NOT NULL, product_id→products (no delete rule: ordered books are soft-deleted only), product_name NOT NULL, quantity CHECK > 0, price)`: price and name are snapshots at order time.
- `app_settings(key pk, value_numeric, updated_at)`: holds `delivery_fee` (currently **0**, owner sets it). RLS: admin only; clients use `get_delivery_fee()`.

### Functions (all `SECURITY DEFINER`, `search_path=public`)
- `is_admin()`: `auth.jwt() -> 'app_metadata' ->> 'role' = 'admin'`. Stays executable by `anon` on purpose (RLS policies call it).
- `place_order(items jsonb, order_notes, customer_name, customer_phone, delivery_area, delivery_address) → uuid`: see section 9b. The old `(items, order_notes)` signature **no longer exists**.
- `get_delivery_fee()`, `set_delivery_fee(new_fee)` (admin, whole numbers), `allowed_order_transitions(current_status)` (admin), `update_order_status(order_id, new_status)` (admin; cancel restores stock), `admin_dashboard_kpis()` (admin; revenue = `delivered` orders).
- `handle_new_user()` trigger on `auth.users` → creates the profile row.
- EXECUTE is revoked from `anon` and PUBLIC on everything except `is_admin()`; the app-facing functions are granted to `authenticated` only.

### RLS summary
- Catalog tables: writes admin-only via `is_admin()`. `products` public SELECT only where `is_active` (admins see all). Other catalog tables: public SELECT.
- `orders` / `order_items`: users SELECT own only; no client insert/update; admin ALL.
- `profiles`: user SELECT/INSERT/UPDATE own; admin SELECT all.

### Remaining backend gaps
1. **No category hierarchy**, so tabs and sub-categories can't be expressed; duplicate/out-of-scope categories exist (C2).
2. **No best-seller data path** (needs a server function, C2).
3. `book_details` of hidden products is still publicly readable (low risk: author/ISBN only).
4. `book_details.author` NOT NULL blocks non-book products (C2).
5. Only C1 is versioned in `supabase/migrations/`; the pre-C1 schema baseline is not.

---

## 6. User app: current state (verified @ `d35092e`; Spec 2A-1 pending merge)

**Done:** server-side order creation via RPC; `is_active` respected in all product queries; sign-up → profile chain; onboarding draft cleared on sign-out (cross-account leak fixed); profile recovery (interests + gender + age); card-based cart/checkout with delivery-notes field; double-submit guard; search debounce + stale-response guard; Google Books key removed from code; import-casing fixed; unused dependencies removed; Gradle/AGP/Kotlin upgraded. **Spec 1 (merged 2026-11-01):** portable Gradle config (no machine-specific Java path), README rewrite, stale docs removed or marked historical, deterministic ordering (`created_at desc, id desc`) on featured/newest/by-category, safe search (escapes backslash, `%` and `_`; capped at 50), GitHub Actions CI (pinned Flutter 3.47.3: `pub get`, `analyze`, `test`), `flutter analyze` clean.

**Spec 2A-1 (implemented by Kiro on `customer-screens-polish`, NOT yet committed or merged):** `formatSyp` (SYP, whole numbers, no `$`), collapsible book description on details, rating widget no longer rendered, pull-to-refresh on Home that refreshes in place (cubits take `refresh: true`) and keeps the selected category, shared `RetryButton` with friendly errors on featured and newest lists, deterministic search order. `flutter analyze` clean, 20 tests passing. Known behaviour: a *failed* refresh still replaces the list with the error + Retry. When merged, the matching items in the Open list below are closed (SYP, description, ratings, pull-to-refresh on Home, search order).

**Warning since C1:** the app's checkout (on `main` and the 2A-1 branch) still calls the old `place_order` signature and **fails against the live DB**. Catalog browsing works. Do not release or demo until Spec 2B lands.

**Open (confirmed):**
- **No "My orders" screen.** Customer can't see status after ordering.
- **No phone/address capture.** Checkout has only free-text notes.
- **No bottom navigation.** Home is one screen (featured list + category chips + list).
- **The "Best Seller" heading is wrong:** it labels a plain horizontal list of `is_featured` items (not a carousel, not sales-based).
- **Book description is loaded by the model but never shown** on the details page.
- **No pull-to-refresh anywhere** (no `RefreshIndicator`).
- Prices render with a hardcoded `$`; no RTL/localization (acceptable now, but keep it addable).
- List queries over-fetch (`*` + joins); newest capped at 20 with no paging; search matches `name` only and is not yet sorted (added in Spec 2A-1).
- Rating widget shows a constant 0.0. Decision: hide.
- No stock awareness in UI (no "Out of stock", no quantity cap).
- `applicationId`/namespace is `com.example.halbouni_book_store`.
- No password reset, no account deletion (store-required), no crash reporting, no real tests.
- Google Books key rotation unconfirmed (still in git history if the repo was ever public).

---

## 7. Decisions

| # | Decision | Status |
|---|---|---|
| D1 | Physical only, no PDF, no print-on-demand | **Confirmed** |
| D2 | Cash on delivery only, Damascus only | **Confirmed** |
| D4 | English now, Arabic later; currency SYP (new pounds, whole numbers) | **Confirmed** |
| D5 | Sell only what is in stock; stock tracked per item, no "unlimited" | **Confirmed** |
| D3 | Name + phone + address required at checkout; saved on profile; snapshotted on the order | Default, in effect unless owner objects |
| D6 | Ratings hidden until real data exists | Default, in effect unless owner objects |
| D7 | Orchestrator owns all schema changes; admin chat requests only | In effect |
| D8 | Storefront structure: `categories.parent_id`; 3 root categories = the 3 tabs (Books, Novels, Board Games); sub-categories under them (Books: Religious, Kids & Teens, Biography, Self-development; Novels: Romance, Sci-Fi, Fantasy, Horror, Thriller, Adventure). Merge "Book"/"Books". **Stationery is kept** (owner, 2026-10-22): for now a sub-category under Books so it stays reachable from the 3 tabs; because the tree is hierarchical it can become its own tab later | **Proposed, owner to confirm structure (Stationery decision made)** |
| D9 | Best sellers = ranked by units sold (orders not cancelled), in-stock and active only, falling back to featured/newest while there is little sales data | Proposed |
| D10 | COD statuses: `pending → confirmed → out_for_delivery → delivered`, plus `cancelled` (restores stock). Revenue = `delivered`. All 13 test orders deleted | **Applied in C1 (2026-11-02)** |
| D11 | **Delivery fee (live: `app_settings`, currently 0): one flat fee for all of Damascus** (owner delegated the model to the orchestrator, 2026-10-22). Stored in a small `settings` table, editable by the admin, snapshotted on the order as `delivery_fee`, `total = items + fee`, computed server-side in `place_order`. The amount is set by the owner in the admin app. Later options if needed: per-area fees, free-delivery threshold. Support phone/WhatsApp in-app: default yes (shown on checkout success and My orders) | **Decided** (amount: owner enters it) |

Admin UIs must read allowed transitions from a server function, not hardcode them.

---

## 8. Roadmap

**Phase 0: Sync & baseline. STATUS: mostly done (Spec 1 merged; C1 versioned in `supabase/migrations/`; test orders deleted). Still open: confirm Google key rotation; remove test products/categories at catalog onboarding; pre-C1 schema baseline not versioned (optional).** Version the live schema as `supabase/migrations/*.sql`; delete `docs/BACKEND_SETUP.sql`; fix `gradle.properties` java.home; rewrite README; `.order()` on category queries; CI (`flutter analyze` + `flutter test`); confirm key rotation; after verification, wipe the test data (orders, test products, test categories) and load the real catalog (see "Catalog onboarding"). *Done when:* clean build and sign-up → order → admin sees it.

**Phase 1: Orders that can really be fulfilled (migration C1). STATUS: database half DONE (C1 applied and smoke-tested 2026-11-02). User-app half in progress: 2A-1 implemented (pending merge), 2A-2 and 2B pending; admin app must adopt C1.**
- DB: contact snapshot on orders + phone/address on profiles; **delivery fee** (settings + `orders.delivery_fee`, total includes it); COD statuses + allowed-transitions function; `place_order` locks rows, rejects insufficient stock with a clear message, decrements stock; cancel restores stock; `stock_quantity NOT NULL CHECK >= 0`, `price > 0`; `is_active OR is_admin()` read policy; revoke anon EXECUTE; update KPIs.
- User app: contact fields at checkout (Syrian phone validation) prefilled from profile; **delivery fee shown as its own line in cart/checkout and order detail**; "My orders" list/detail with status; "Out of stock" badge, add-to-cart disabled, quantity capped, cart revalidated before checkout; SYP formatting (whole numbers, thousands separator, `SYP` label); hide rating stars; **book description on details page**; **pull-to-refresh** everywhere there is a list, plus Retry on errors.
- *Done when:* a real customer in Damascus orders, the admin phones them, delivers, marks delivered, stock is correct, the customer sees status.

**Phase 2: Storefront structure (migration C2).**
- DB: `categories.parent_id`; seed the 3 roots + sub-categories incl. **Religious** and **Kids & Teens**; cleanup of duplicates; `book_details` optional for non-book products (relax `author` NOT NULL or skip the row); `best_sellers(section, limit)` function (D9).
- User app: **bottom bar with 3 tabs** (Books, Novels, Board Games) using go_router shell routes with preserved state; each tab has a **best-sellers carousel** (PageView, dots, auto-advance, hidden if empty) plus sub-category chips; friendly empty state for a tab with no stock (Board Games at first); pagination/infinite scroll; slim list queries; search scoped sensibly.
- Admin: category tree management, optional author for non-books.

**Catalog onboarding (real books), after Phase 1 and 2 are verified.** The owner fills `books_import_template.xlsx` (one row per product: type, title, author, category from a fixed dropdown, price in new SYP, **real stock**, description, optional ISBN/publisher/pages/cover file name/featured). The orchestrator validates the sheet (whole-number prices, stock >= 0, known categories, authors present for books, duplicate titles/ISBNs) and loads it as a versioned SQL migration or script. Cover images are uploaded to a Storage bucket (migration C3) with file names matching the sheet. A CSV import screen in the admin app is a later option, only if volume justifies it. Start with a small batch (5 to 10 items), place a real test order, then load the rest.

**Phase 3: Production readiness & reliability.** Smoke tests (`place_order` incl. stock race, status transitions, RLS); crash reporting; offline/error states; password reset; account deletion; custom SMTP for auth emails; backups plan; privacy policy; in-app support contact.

**Phase 4: Release.** Real application id, app name, icon, splash; signing; store listing; closed test then staged rollout. **Verify early** whether a Play Console developer account can be created for a Syria-based owner; otherwise plan an alternative (account registered elsewhere, or direct APK distribution).

**Later:** Arabic + RTL; academic notes and faculty → year → course sub-categories (the `parent_id` tree already supports them); ratings.

### Production readiness verdict (2026-10-22): **NOT ready**
Blockers: stock not enforced; no contact data for delivery; payment-shaped statuses; inactive products readable; test data in the live DB; `com.example` app id and no signing; no privacy policy/account deletion/password reset; no crash reporting; no real tests; auth email sending not configured for production (Supabase's built-in sender is for testing and rate-limited, so confirm whether email confirmation is on); unconfirmed key rotation; backups/plan not checked. Everything else in section 6 is non-blocking polish.

---

## 9. Admin app and the contract protocol

**Admin app (`halbouni_admin`)**, verified at its 2026-10-22 commit: feature-first (auth, books, categories, dashboard, orders); role from `app_metadata`; status via `update_order_status`; soft delete via `is_active`; `stock_quantity` and `product_id` aligned; debounced search; server-side count on orders. Open: `dart:html` in CSV export; no pull-to-refresh requirement met yet; no migrations folder. Its task prompt lives in `ADMIN_CHAT_PROMPT.md`.

**Admin app after C1 (required):** read allowed transitions from `allowed_order_transitions` and show the five COD statuses (no `paid`/`refunded`); revenue card = delivered orders; add a delivery-fee setting calling `set_delivery_fee`; show customer name, phone, area, address and `delivery_fee` on order detail; `stock_quantity` is now NOT NULL (>= 0) and `price` must be > 0; hidden products are still visible to admins.

**Protocol:** schema requests go to the orchestrator; the orchestrator applies a migration, commits it under `supabase/migrations/`, then sends a **contract message** (`C1`, `C2`, …) describing new columns/functions/statuses. Admin work that depends on a contract waits for it; work without schema dependency may proceed. Breaking changes ship additively: migration first, client updates second, cleanup third.

---

## 9b. Contract C1 (LIVE since 2026-11-02: applied and smoke-tested)

C1 is applied. Migration file: `supabase/migrations/20261102000000_c1_orders_fulfillment.sql`. If the live DB differs from this section, the live DB wins; report it.

**Implementation notes (as built):** every `place_order` parameter after `items` has a default of null, and missing/invalid contact raises `INVALID_CONTACT`; the old `place_order(jsonb, text)` was dropped; `set_delivery_fee` accepts whole numbers only (else `INVALID_FEE`); `get_delivery_fee` needs a signed-in user; all functions except `is_admin()` are not executable by `anon`. Smoke-tested: success with stock decrement and fee, `OUT_OF_STOCK:<id>:<available>`, `INVALID_CONTACT`, `INVALID_ITEM`, non-admin rejected, invalid transition rejected, cancel restores stock.

**Tables**
- `profiles`: + `phone text`, `delivery_area text`, `address text` (all nullable).
- `orders`: + `customer_name text NOT NULL`, `customer_phone text NOT NULL`, `delivery_area text`, `delivery_address text NOT NULL`, `delivery_fee numeric NOT NULL default 0`. `total` = items total + `delivery_fee`. `status` CHECK: `pending | confirmed | out_for_delivery | delivered | cancelled`.
- `order_items`: + `product_name text` (snapshot at order time, so history survives a book being hidden).
- `products`: `stock_quantity NOT NULL CHECK (>= 0)`, `price CHECK (> 0)`; public SELECT only where `is_active` (admins see all).

**Functions**
- `place_order(items jsonb, order_notes text, customer_name text, customer_phone text, delivery_area text, delivery_address text) -> uuid`. `items` keeps today's format. Authenticated users only. Server validates contact, merges duplicate lines, allows quantity 1..20 per line, locks product rows, rejects unavailable/insufficient stock, decrements stock, adds the delivery fee, creates the order as `pending`. Supabase RPC named params use exactly those keys.
- Failures raise an exception whose message **starts with a stable code**: `NOT_AUTHENTICATED`, `EMPTY_CART`, `INVALID_ITEM`, `INVALID_CONTACT`, `PRODUCT_UNAVAILABLE:<product_id>`, `OUT_OF_STOCK:<product_id>:<available>`. Clients map codes to friendly text and never show raw messages.
- `get_delivery_fee() -> numeric` (authenticated). `set_delivery_fee(new_fee numeric)` (admin only).
- `allowed_order_transitions(current_status text) -> text[]` (admin). `update_order_status(order_id, new_status)` keeps its signature. Transitions: `pending -> confirmed | cancelled`; `confirmed -> out_for_delivery | cancelled`; `out_for_delivery -> delivered | cancelled`. Cancelling restores stock.
- `admin_dashboard_kpis()`: revenue = sum of `total` of `delivered` orders.

**Phone format (client validates, server re-validates):** Syrian mobile only. Accept `+9639XXXXXXXX`, `009639XXXXXXXX`, `09XXXXXXXX`, `9XXXXXXXX`; store normalized as `09XXXXXXXX`.

**Reading orders (user app):** `from('orders').select('*, order_items(*)').order('created_at', ascending: false)` (RLS limits to own rows).

---

## 10. Current status and next steps (update this at every milestone)

**Done:** Spec 1 baseline merged (PR #1). **C1 applied to the live DB and smoke-tested (2026-11-02); migration file merged to `main`.** Context files and Kiro steering are in the repo. **Spec 2A-1** is implemented on `customer-screens-polish` (analyze clean, 20 tests) but not yet committed or merged.

**Warning:** until Spec 2B ships, checkout fails against the live DB (old `place_order` signature) and the admin app's status buttons and revenue card are out of date. Test data only, but don't release or demo.

**Next, in order:**
1. **Owner:** commit the 2A-1 work on `customer-screens-polish`, merge `main` into it, run the manual check from `KIRO_PROMPT_2A1.md` (checkout itself will not work), open the PR, merge when CI is green.
2. **Owner:** send the "C1 applied" contract message (section 9b) to Kiro and the admin chat.
3. **Admin chat:** adopt C1 (section 9).
4. **Spec 2A-2, stock-aware cart** (fix its design first: Hive `defaultValue: 0` + adapter regeneration + legacy-cart test, fail closed on revalidation error, no property-testing package). Design on branch `spec-work`, not merged.
5. **Spec 2B**, orders end to end against C1. Before its manual QA: give a few test books real stock and set the delivery fee in the admin app.
6. Later: category tabs + best sellers (C2), real catalog import, production readiness, release.

**Open owner items:** rotate the old Google Books key (commits `1bb6e09`, `ce77270`) and say whether the repo was ever public; enter the delivery fee amount; confirm category structure (D8); decide whether a failed pull-to-refresh should keep the old list (currently it shows the error).

## 11. Working agreements (branches, chats, handoffs)

**Git:** never work on `main`. One branch per spec or task, created from an up-to-date `main` (`git checkout main`, `git pull`, `git checkout -b <name>`). Merge through a pull request only when `flutter analyze` is clean, `flutter test` passes and CI is green; then `git checkout main`, `git pull`, and start the next branch. Do not reuse a branch for a different spec.

**Kiro:** one spec = one chat (requirements, design, tasks, execution). Start a new chat for every new spec, and also when a chat gets slow, repeats itself or drifts. A new chat re-reads `PROJECT_CONTEXT.md` and the spec folder, so nothing is lost. Run tasks one at a time; commit after each.

**Claude (orchestrator chat):** one chat per workstream (app/orchestration, admin, database). Start a fresh chat after each merged milestone or when the chat becomes long. Handoff: update section 10 of this file, replace the old copy in the Claude project files, then start the new chat with the starter message from the owner's notes (read `PROJECT_CONTEXT.md`, then continue from section 10).

---

## 12. Change log
- 2026-10-22 v1: file created.
- 2026-11-01 v4: Spec 1 merged; status and working agreements added (sections 10-11).
- 2026-11-02 v5: C1 applied and smoke-tested; sections 5, 9b, 10 rewritten to the live state; Spec 2A-1 implemented (pending merge); warning that checkout and admin are out of date until 2B and the admin C1 work.
- 2026-10-22 v3.1: added planned contract C1 (section 9b); Kiro prompts added.
- 2026-10-22 v3: owner confirmed all current data is test data and test orders may be deleted; delivery fee exists, flat fee model decided; Stationery kept as a category; catalog onboarding via spreadsheet template added.
- 2026-10-22 v2: owner answered D1/D2/D4/D5 (physical only, COD Damascus, English now/Arabic later, SYP, stock-only); added new requirements (tabs, categories, carousel, description, refresh); verified live data (stock mostly 0, duplicate categories, `author` NOT NULL); SYP redenomination noted; roadmap rewritten; production verdict added.
