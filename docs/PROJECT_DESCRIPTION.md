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

---

## Routing — GoRouter

| Route | Constant | Widget | Notes |
|-------|----------|--------|-------|
| `/` | — | `SplashView` | Animated logo → checks session → routes to Home or Onboarding |
| `/onboarding` | `kOnboardingView` | `OnboardingScreen` | PageView: Welcome, Gender, Age, Interests. `?startPage=N` query param |
| `/homeView` | `kHomeView` | `HomeView` | Featured carousel, category chips (from DB), best seller list |
| `/bookDetailsView/:id` | `kBookDetailsView` | `BookDetailsView` | Dynamic route. `ProductEntity` passed via `extra` |
| `/searchView` | `kSearchView` | `SearchView` | Live debounced search |
| `/cartView` | `kCartView` | `CartView` | Cart items, quantity controls, total bar |
| `/checkout` | `kCheckoutView` | `CheckoutView` | Order summary + notes → `place_order` RPC |
| `/profile` | `kProfileView` | `ProfileView` | User info, interest-based recommendations, sign-out |
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
| `OnboardingCubit` | Scoped to OnboardingScreen | Page index, gender, age, interests, completing | Multi-step onboarding flow |
| `AuthCubit` | Scoped to Auth views | Initial / Loading / Authenticated / Error | Supabase sign-in / sign-up |
| `ProfileCubit` | Scoped to ProfileView | Initial / Loading / Loaded / SigningOut / SignedOut / Failure | Profile + maps interest **names → category ids** for recommendations |

---

## Local Storage — Hive

| Box Name | Type | Purpose |
|----------|------|---------|
| `cart_box` | `Box<CartItemModel>` | Offline cart persistence |

**Hive Adapter:** `CartItemModelAdapter` (typeId: 1).

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

## Removed / Dead Code (this cleanup)

- Google Books data source (`home_remoute_data_source.dart`), `api_service.dart`, `crud.dart`, `status_class.dart`, `check_internet.dart`, `app_link.dart`, `initial_binding.dart`, `services.dart`, GetX controllers/pages, unused `lib/widgets/*` (navbar/background/button/map/general-info), unused loading indicators, duplicate `book_model/*`, `book_entity(.g)`, duplicate onboarding `genre.dart`.
- Dependencies `dio`, `http`, `google_maps_flutter` removed from `pubspec.yaml`.
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
