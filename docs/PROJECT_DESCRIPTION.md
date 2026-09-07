# Halbouni Book Store — Project Description

**Package name:** `adv` (`pubspec.yaml`)  
**Branding:** Halbouni Book Store  
**Workspace folder:** `halbouni_book_store`

---

## Project Overviewecho "# alburaq_app_2" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/baraa2ttar/alburaq_app_2.git
git push -u origin main

**Halbouni Book Store** is a Flutter app for browsing, searching, and purchasing books. It uses **Supabase** as the backend (PostgreSQL + Auth), **Hive** for offline local cart persistence, **GoRouter** for navigation, **flutter_bloc** (Cubit) for state management, and **get_it** for dependency injection.

---

## Architecture

- **Organization:** Feature-first folders under `lib/Features/` (Splash, Onboarding, Home, Search, Cart, Auth). Shared code under `lib/core/` (routing, constants, errors, extensions, DI, services).

- **Layers:**
  - **Presentation:** Widgets/screens + Cubit and sealed states.
  - **Domain:** Entities (`ProductEntity`, `BookDetailEntity`, `CartItemModel`), repository abstractions (`HomeRepo`, `CartRepo`, `OnboardingRepo`, `AuthRepo`), and use cases (fetch featured/newest books, fetch by category, onboarding completion).
  - **Data:** `HomeRepoImpl`, `CartRepoImpl`, `OnboardingRepoImpl`, `AuthRepoImpl` — remote via Supabase client, local via Hive/SharedPreferences.

- **Dependency injection:** `get_it` in `lib/core/services/setup_service_locator.dart` registers `HomeRepoImpl`, `CartRepo`, `CartCubit`, `OnboardingRepo`, `AuthCubit`.

- **Functional error style:** `dartz` `Either<Failure, T>` from repositories into Cubits. All repo methods wrapped in try/catch returning `Left(ServerFailure)` on error.

---

## Backend — Supabase

### Tables

| Table | Columns | Notes |
|-------|---------|-------|
| `categories` | `id`, `name` | Lookup table for book genres |
| `products` | `id`, `name`, `description`, `price`, `image_url`, `is_featured`, `rating`, `created_at`, `category_id` (FK → categories) | Core book data |
| `book_details` | `id`, `product_id` (FK → products, 1:1), `author`, `isbn`, `publisher`, `page_count`, `preview_link` | Extended book info |

### Queries

- **Featured books:** `products.select('*, categories(name), book_details(*)').eq('is_featured', true)`
- **Newest books:** `products.select('*, categories(name), book_details(*)').order('created_at', ascending: false).limit(20)`
- **By category:** `products.select('*, categories!inner(name), book_details(*)').eq('categories.name', categoryName)`
- **Search:** `products.select('*, categories(name), book_details(*)').ilike('name', '%$query%')`
- **By ID:** `products.select('*, categories(name), book_details(*)').eq('id', productId).single()`

### Auth

- Supabase Auth for sign-in / sign-up.
- Splash screen checks `Supabase.instance.client.auth.currentSession` to route to Home or Onboarding.

### RLS Policies

- `anon` role has SELECT on `products`, `categories`, `book_details` with no restrictions.

---

## Routing — GoRouter

| Route | Constant | Widget | Notes |
|-------|----------|--------|-------|
| `/` | — | `SplashView` | Animated logo → checks session → routes to Home or Onboarding |
| `/onboarding` | `kOnboardingView` | `OnboardingScreen` | PageView: Welcome, Gender, Age, Interests (4 pages). `?startPage=N` query param |
| `/homeView` | `kHomeView` | `HomeView` | Featured carousel, category chips, best seller list |
| `/bookDetailsView/:id` | `kBookDetailsView` | `BookDetailsView` | Dynamic route. `ProductEntity` passed via `extra` |
| `/searchView` | `kSearchView` | `SearchView` | Live debounced search |
| `/cartView` | `kCartView` | `CartView` | Cart items, quantity controls, total bar |
| `/auth/sign-in` | `kAuthSignIn` | `AuthSignInView` | Supabase email sign-in |
| `/auth/sign-up` | `kAuthSignUp` | `AuthSignUpView` | Supabase email sign-up |

---

## State Management — Cubits

| Cubit | Scope | States | Purpose |
|-------|-------|--------|---------|
| `FeaturedBooksCubit` | Global (`MultiBlocProvider`) | Initial / Loading / Success / Failure | Fetches featured books at app start |
| `NewestBooksCubit` | Global (`MultiBlocProvider`) | Initial / Loading / Success / Failure | Fetches newest books, supports category filtering |
| `SearchCubit` | Scoped to SearchView | Initial / Loading / Success / Failure | Debounced (500ms) search via Supabase |
| `ProductDetailsCubit` | Scoped to BookDetailsView | Initial / Loading / Success / Failure | Fetches single product by ID |
| `CartCubit` | Global (`MultiBlocProvider`) | Initial / Loading / Loaded / Failure | CRUD on Hive cart (load, addItem, removeItem, changeQuantity) |
| `OnboardingCubit` | Scoped to OnboardingView | Page index, gender, age, interests, completing | Manages multi-step onboarding flow |
| `AuthCubit` | Scoped to Auth views | Loading / Success / Failure / Initial | Supabase sign-in / sign-up |

---

## Local Storage — Hive

| Box Name | Type | Purpose |
|----------|------|---------|
| `featured_box` | `Box<BookEntity>` | Caches featured books (remote data) |
| `newest_box` | `Box<BookEntity>` | Caches newest books (remote data) |
| `cart_box` | `Box<CartItemModel>` | Offline cart persistence (user's shopping cart) |

**Hive Adapters:** `BookEntityAdapter` (typeId: 0), `CartItemModelAdapter` (typeId: 1)

**SharedPreferences:** Onboarding completion flag (`isOnboardingCompleted`).

---

## Features — Current State

### Completed

- **Splash Screen:** Animated logo + sliding text, 2-second delay, checks Supabase session → routes to Home or Onboarding.
- **Onboarding:** 4-step PageView (Welcome, Gender, Age, Interests). Completion persisted via SharedPreferences.
- **Auth:** Supabase email sign-in / sign-up. Sign-in → Home, Sign-up → Onboarding.
- **Home Screen:** Featured horizontal carousel (Supabase query), category filter chips (8 categories), "Best Seller" list of newest books from Supabase.
- **Book Details:** Dynamic route with `ProductEntity` via `extra`, fallback fetch by ID, product image + name + author, dynamic rating widget, "Add to Cart" button with SnackBar.
- **Rating:** `ProductEntity.rating` field parsed from Supabase with 4.5 default. Passed dynamically to `RatingWidget` throughout app.
- **Similar Books:** Scoped `NewestBooksCubit` fetches books from the same category as the viewed product.
- **Search:** Live debounced (500ms) Supabase `.ilike('name', ...)` queries with BlocBuilder UI.
- **Cart (Offline-first):** Full Hive-backed CRUD. `CartCubit` (global) with load/add/remove/changeQuantity. Cart View with image, title, price, +/- quantity controls, bottom total bar.
- **Navigation:** Cart icon in Home app bar and Book Details app bar, both navigate to `/cartView`.
- **Background color:** Details page Scaffold background color documented with `[BACKGROUND COLOR]` comment for easy adjustment.
- **Error handling:** All repo methods return `Either<Failure, T>` with try/catch fallback to `ServerFailure`.

### Incomplete / Pending

| Item | Status |
|------|--------|
| Checkout flow | CartView exists but no checkout/payment integration |
| User profile | No profile screen or user data display |
| Favorites / Wishlist | Not implemented |
| Book preview / Read | `preview_link` stored but no in-app reader |
| Push notifications | Not implemented |
| Pull-to-refresh | Not on Home or Cart |
| Pagination (load more) | Featured books has offset logic but no UI trigger |
| Image caching edge cases | `CachedNetworkImage` used but no cache size limits configured |
| Unused dependencies | `google_maps_flutter`, calendar packages, `syncfusion_flutter_gauges` — can be trimmed |

---

*Generated from codebase review — update when behaviors change.*
