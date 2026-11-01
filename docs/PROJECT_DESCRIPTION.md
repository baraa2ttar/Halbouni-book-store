HISTORICAL, not a source of truth. See PROJECT_CONTEXT.md

# Halbouni Book Store — Project Description

**Package name:** `adv` (`pubspec.yaml`)  
**Branding:** Halbouni Book Store  
**Workspace folder:** `halbouni_book_store`

---

## Project Overview

**Halbouni Book Store** is a Flutter app for browsing, searching, and purchasing books. It uses **Supabase** as the backend (PostgreSQL + Auth + RPC), **Hive** for offline local cart persistence, **GoRouter** for navigation, **flutter_bloc** (Cubit) for state management, and **get_it** for dependency injection.

---

## Architecture

- **Organization:** Feature-first folders under `lib/Features/` (Splash, Onboarding, Home, Search, Cart, Auth, Orders, Profile). Shared code under `lib/core/` (routing, constants, errors, exports, extensions, helpers, services).

- **Layers:**
  - **Presentation:** Widgets/screens + Cubit and sealed states.
  - **Domain:** Entities (`ProductEntity`, `BookDetailEntity`, `CategoryEntity`, `OrderEntity`, `CartItemModel`), repository abstractions (`HomeRepo`, `CartRepo`, `OrdersRepo`, `AuthRepo`, `OnboardingRepo`, `ProfileRepo`), and use cases (featured/newest books, categories, by-category, onboarding).
  - **Data:** `HomeRepoImpl`, `CartRepoImpl`, `OrdersRepoImpl`, `AuthRepoImpl`, `ProfileRepoImpl` — remote via Supabase client, local via Hive/SharedPreferences.

- **Dependency injection:** `get_it` in `lib/core/services/setup_service_locator.dart` registers `HomeRepo`, `HomeRepoImpl`, `CartRepo`, `CartCubit`, `OrdersRepo`, `CheckoutCubit`, `AuthCubit`, `ProfileCubit`, onboarding repos/use cases.

- **Functional error style:** `dartz` `Either<Failure, T>` from repositories into Cubits. Repos catch thrown errors and return `Left(ServerFailure(failureMessage(e)))` — user-facing messages only, never raw stack traces.

---

## Backend — Supabase

### Tables

| Table | Columns | Notes |
|-------|---------|-------|
| `categories` | `id`, `name` | Lookup table for book genres — referenced by **id**, not name |
| `products` | `id`, `name`, `description`, `price`, `image_url`, `category_id` (FK → categories), `is_featured`, `is_active`, `rating`, `created_at` | `is_active` is a soft-delete flag |
| `book_details` | `product_id` (FK, 1:1), `author`, `isbn`, `publisher`, `page_count`, `preview_link` | Extended book info |
| `orders` | `id`, `user_id`, `total`, `status`, `notes`, `created_at` | `total` is **server-computed** by the `place_order` RPC |
| `order_items` | `order_id`, `product_id`, `quantity`, `price` | Inserted atomically by the RPC |

### Queries (client-side rules)

- All end-user product queries filter **`.eq('is_active', true)`** (featured, newest, by-category, search, by-id).
- **Featured:** `.eq('is_featured', true).eq('is_active', true).order('created_at').range(page*10, page*10+9)` — deterministic order for pagination.
- **Newest:** `.eq('is_active', true).order('created_at', descending).limit(20)`.
- **By category:** `.eq('category_id', <uuid>).eq('is_active', true)`.
- **Search:** `.eq('is_active', true).ilike('name', '%$query%')`.
- **By ID:** `.eq('id', productId).eq('is_active', true).maybeSingle()` → missing product returns a friendly `Product not found` failure.
- **Categories:** `categories.select('id, name').order('name')`.

### Placing an order — `place_order` RPC

Orders are created **only** through the server-side RPC; the client never writes to `orders` / `order_items` and never sends prices or totals:

```dart
await supabase.rpc('place_order', params: {
  'items': [
    {'product_id': '<uuid>', 'quantity': 1},
  ],
  'order_notes': 'optional text or null',
});
```

- Returns the new order UUID.
- Server validates stock, computes `total`/`price` server-side, and inserts order + items atomically.
- RPC errors (`raise exception`) arrive as a JSON envelope inside `PostgrestException.message` — `OrdersRepoImpl` unwraps it (`jsonDecode` → `message`) so users see the real reason (e.g. out-of-stock text).

### Auth

- Supabase Auth for sign-in / sign-up.
- Splash screen checks `Supabase.instance.client.auth.currentSession` to route to Home or Onboarding.
- Checkout listens to `onAuthStateChange` so a sign-in started with `?redirect=/checkout` lands back on checkout with a live session.

### Checkout — what it actually does today

There is **no payment gateway**, **no address book**, **no shipping options**, and **no vouchers**. Checkout is a confirmation screen that:

1. Requires a signed-in session.
2. Lets the user type optional **delivery notes** into `orders.notes` (free-form text; the only delivery field).
3. Shows a non-interactive **Pay on Delivery** line (wording only — `place_order` does not charge anyone).
4. Submits `{product_id, quantity}` plus notes through the `place_order` RPC.
5. Creates the order as **`pending`**; an admin updates status later.

Cart and checkout totals are the cart line sum. Subtotal and TOTAL are the same number because there are no fees, shipping rows, or discounts in the schema (`products.price` only — no original/compare-at price).

### Profile recovery

A signed-in user whose `profiles` row is missing interests (not exactly 4), gender, or `age_range` can complete those fields from Profile via the existing onboarding gender / age / interests pages (`?recovery=true`). This is not a separate editor. Gender/age skipped during first onboarding can be set later this way.

### Known placeholders (not bugs)

- **Book ratings:** display-only (including `0`); there is no in-app rating write this round.
- **Avatar:** Profile shows a generic person icon. There is no avatar upload/editing.

---

## Routing — GoRouter

| Route | Constant | Widget | Notes |
|-------|----------|--------|-------|
| `/` | — | `SplashView` | Animated logo → checks session → routes to Home or Onboarding |
| `/onboarding` | `kOnboardingView` | `OnboardingScreen` | PageView: Welcome, Gender, Age, Interests. `?startPage=N`. Profile recovery: `?recovery=true&needsAge=&needsInterests=` |
| `/homeView` | `kHomeView` | `HomeView` | Featured carousel, category chips (from DB), best seller list |
| `/bookDetailsView/:id` | `kBookDetailsView` | `BookDetailsView` | Dynamic route. `ProductEntity` passed via `extra` |
| `/searchView` | `kSearchView` | `SearchView` | Live debounced search |
| `/cartView` | `kCartView` | `CartView` | Card layout: cover, title, author, price, stepper, remove; summary + Checkout |
| `/checkout` | `kCheckoutView` | `CheckoutView` | Delivery notes + Pay on Delivery line + summary → `place_order` RPC |
| `/profile` | `kProfileView` | `ProfileView` | User info, incomplete-profile recovery, interest-based recommendations, sign-out |
| `/auth/sign-in` | `kAuthSignIn` | `AuthSignInView` | Supabase email sign-in. `?redirect=<path>` returns there after login |
| `/auth/sign-up` | `kAuthSignUp` | `AuthSignUpView` | Supabase email sign-up |

---

## State Management — Cubits

| Cubit | Scope | States | Purpose |
|-------|-------|--------|---------|
| `FeaturedBooksCubit` | Global (`MultiBlocProvider`) | Initial / Loading / Success / Failure | Featured books with infinite scroll (loadMore + hasReachedMax) |
| `NewestBooksCubit` | Global (`MultiBlocProvider`) + scoped in `SimilarBooksListView` | Initial / Loading / Success (books + categories + activeCategoryId) / Failure | Newest books, category filtering by **id**, loads DB categories once, stale-response guard |
| `SearchCubit` | Scoped to SearchView | Initial / Loading / Success / Failure | Debounced (500 ms) search with stale-response guard |
| `ProductDetailsCubit` | Scoped to BookDetailsView | Initial / Loading / Success / Failure | Fetches single product by ID |
| `CartCubit` | Global | Initial / Loading / Loaded / Failure | Hive cart CRUD; recovers from non-loaded state in add/change |
| `CheckoutCubit` | Scoped to CheckoutView (factory) | Initial / Loading / Success (+optional warning) / Failure | Places order via RPC; double-submit guard; emits Success even if local cart clear fails |
| `OnboardingCubit` | Scoped to OnboardingScreen | Page index, gender, age, interests, completing, recovery/hydrate flags | First-run onboarding and signed-in profile recovery |
| `AuthCubit` | Scoped to Auth views | Initial / Loading / Authenticated / EmailConfirmationRequired / Error | Supabase sign-in / sign-up; no session after sign-up is treated as confirm-email, not logged-in |
| `ProfileCubit` | Scoped to ProfileView | Initial / Loading / Loaded / SigningOut / SignedOut / Failure | Profile + maps interest **names → category ids** for recommendations |

---

## Local Storage — Hive

| Box Name | Type | Purpose |
|----------|------|---------|
| `cart_box` | `Box<CartItemModel>` | Offline cart persistence |

**Hive Adapter:** `CartItemModelAdapter` (typeId: 1) — fields: id, name, price, imageUrl, quantity, author. Older cart rows without `author` read as `''`.

**SharedPreferences:** Onboarding completion flag.

> The old `featured_box` / `newest_box` cache and `BookEntity` were removed — the app always fetches fresh data from Supabase.

---

## Configuration

`lib/core/constant/supabase_config.dart` reads build-time values with compile-time fallbacks:

```
--dart-define=SUPABASE_URL=...
--dart-define=SUPABASE_ANON_KEY=...
```

`AppConfig.validate()` fails fast at startup if no URL/key is configured.

---

## Android builds (Flutter 3.47 toolchain notes)

- Install `platforms;android-36` (`sdkmanager "platforms;android-36"`) — the `app_links` /
  `url_launcher_android` plugins (transitive via `supabase_flutter`) hard-require `compileSdk 36`.
  - Stopgap already applied on this machine: `Android\Sdk\platforms\android-36` was created as a
    copy of `android-35` with `source.properties`/`package.xml` patched to API 36. Delete that
    folder once the real platform is installed.
- The project's Gradle wrapper is `8.12`, below Flutter 3.47's minimum (`8.14`), so Android
  builds/run must pass `--android-skip-build-dependency-validation` to bypass the version gate,
  e.g. `flutter run --android-skip-build-dependency-validation`. Upgrading the wrapper to a
  supported Gradle (8.14+, or 9.3.1 with AGP 8.13+/9.x) removes the need for this flag.
- This machine's firewall sinks `dl.google.com` / `maven.google.com` / `repo.maven.apache.org`
  with fake 404s (while `storage.googleapis.com`, `pub.dev`, `services.gradle.org` work), which
  originally made Android builds stall/fail. Workaround: `android/build.gradle.kts` and
  `android/settings.gradle.kts` declare Aliyun's mirrors of Google Maven and Maven Central
  (`https://maven.aliyun.com/repository/google`, `/central`) before the real repos. Remove the
  mirror entries once the real hosts are reachable again.
- `android/gradle.properties` sets `android.suppressUnsupportedCompileSdk=36` (AGP 8.7.3 is only
  tested up to 35; compileSdk 36 is fine).
- The Gradle daemon runs on Android Studio's embedded JBR (Java 21) — available at
  `C:\Program Files\Android\Android Studio\jbr` (a system `JAVA_HOME` is not set).

---

## Removed / Dead Code (this cleanup)

- Google Books data source (`home_remoute_data_source.dart`), `api_service.dart`, `crud.dart`, `status_class.dart`, `check_internet.dart`, `app_link.dart`, `initial_binding.dart`, `services.dart`, GetX controllers/pages, unused `lib/widgets/*` (navbar/background/button/map/general-info), unused loading indicators, duplicate `book_model/*`, `book_entity(.g)`, duplicate onboarding `genre.dart`.
- Dependencies `dio`, `http`, `google_maps_flutter`, `font_awesome_flutter`, `syncfusion_flutter_gauges`, `table_calendar`, `calendar_date_picker2`, `dropdown_button2`, `date_field`, `datetime_picker_formfield`, `percent_indicator`, `flutter_svg`, `google_fonts`, `cupertino_icons` removed from `pubspec.yaml` (all unused; Font Awesome icons replaced with Material `Icons.search`/`Icons.star`).
- Dead GetX `GetPage` comments and Get-Put comments removed from router/splash.

---

## Pending / Not Implemented

| Item | Status |
|------|--------|
| Favorites / Wishlist | Not implemented |
| Book preview / Read | `preview_link` stored but no in-app reader |
| Push notifications | Not implemented |
| Pull-to-refresh | Not on Home or Cart |
| Admin dashboard | Consumes `orders` table directly (out of scope for this app) |

---

*Generated from codebase review — update when behaviors change.*
