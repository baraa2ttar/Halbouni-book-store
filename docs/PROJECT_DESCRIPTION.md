# Halbouni Book Store — Project Description

This document describes the Flutter codebase as implemented in this repository.

**Package name:** `adv` (`pubspec.yaml`)  
**Branding:** Halbouni Book Store  
**Workspace folder:** `halbouni_book_store`

---

## Project overview

**Halbouni Book Store** is a **Flutter** app for browsing books using the **Google Books API**. It uses feature-first folders, **`go_router`** navigation, **`flutter_bloc`** (Cubit), **`get_it`** dependency injection, **Dio** for HTTP, and **Hive** for local persistence of book entities (with SharedPreferences for onboarding completion).

---

## Architecture

- **Organization:** Features under `lib/Features/` (Splash, Onboarding, Home, Search). Shared code under `lib/core/` (routing, constants, errors, extensions, DI, API client).

- **Layers (where implemented):**
  - **Presentation:** Widgets/screens + **`Cubit`** and sealed states.
  - **Domain:** Entities (e.g. `BookEntity`), repository abstractions (`HomeRepo`, `OnboardingRepo`), and **use cases** (fetch featured/newest books, onboarding completion checks).
  - **Data:** `HomeRepoImpl`, `OnboardingRepoImpl`; **remote** via `HomeReouteDataSourceImpl` → `ApiService`/Dio; **local** via `HomeLocalDataSourceImpl` (Hive) and `OnboardingLocalDataSource` (SharedPreferences).

- **Dependency injection:** `get_it` in `lib/core/services/setup_service_locator.dart` registers `ApiService` (Dio), `HomeRepoImpl`, and the onboarding chain.

- **Navigation:** **`go_router`** paths: `/`, `/onboarding`, `/homeView`, `/bookDetailsView`, `/searchView`.  
  **Note:** Routes generally do **not** pass **`BookEntity`** / volume IDs via **`extra`** or parameterized paths today, so book details screens cannot reflect a tapped row without further work.

- **Functional style for errors:** **`dartz`** `Either<Failure, T>` from repositories into Cubits.

- **Local storage caveat:** **`HomeRepoImpl`** fetches featured books from the **network** path; **`HomeLocalDataSource`** exists but is **not** wired as cache-first/stale-on-error in repository methods. **`fetchNewestBooks`** remote implementation writes newest books into Hive.

---

## State management

| Area | Approach |
|------|-----------|
| **Featured books** | `FeaturedBooksCubit` + sealed `FeaturedBooksState` (initial/loading/success/failure). Success carries pagination/load-more metadata. Loaded at app startup from `MultiBlocProvider` in `main.dart`. |
| **Newest books** | `NewestBooksCubit` + sealed states, registered globally, but **`fetchNewestBooks()` is not visibly invoked from presentation** unless added by the developer. |
| **Onboarding** | `OnboardingCubit` + `OnboardingState` (page, gender, age index, interests, completing). `BlocProvider` is scoped only to the onboarding route. |
| **Debugging** | `SimpleBlocObserver` attached in `main.dart`. |

Older GetX/GetPage patterns appear only in comments/disabled snippets (e.g. legacy splash controller references).

---

## UI packages and styling

### Layout and responsiveness

- **`flutter_screenutil`** — design-size scaling (`ScreenUtilInit`, `.h`/`.w` extensions).
- **`responsive_framework`** — `ResponsiveBreakpoints.builder` wraps `MaterialApp` (`responsiveBuilder` in `lib/core/extensions/size_extensions.dart`).
- Custom **`context.sp()`** clamped scaling alongside ScreenUtil hooks.

### Typography and colors

- **`AppColor`** in `lib/core/constant/app_colors.dart` — primary accent (`#F79201`), text neutrals, and many named colors aimed at future/general UI.
- **`AppTextStyles`** in `lib/core/constant/app_text_styles.dart` — context-aware sizing; **`GT Sectra Fine`** is declared in **`pubspec.yaml`** fonts; theme uses **`fontFamily: 'Rubik'`** in `main.dart` (Rubik must be bundled to match).
- **`google_fonts`** is a dependency but **runtime font download may be deliberately avoided** in theme commentary for startup/network reasons.

### Media and icons

- **`cached_network_image`** for thumbnails when URLs exist (`CustomListViewItem`).
- **`flutter_svg`**, **`font_awesome_flutter`**.

### Declared packages with limited bookstore use

`pubspec.yaml` includes **`google_maps_flutter`**, **calendar/date** packages, **`syncfusion_flutter_gauges`**, **`http`** (alongside Dio), **`percent_indicator`**, etc., which largely read as unused or migrated from another app surface. Prefer trimming or splitting into modules for smaller APKs and faster builds.

Secondary widget roots (`lib/widgets/` vs `lib/core/widgets/`) are both referenced via exports (`ui_exports.dart`).

---

## Feature descriptions

### Splash

- **Route:** `/`
- **Behavior:** Animated logo/copy, **2-second** delay, then **`IsOnboardingCompletedUseCase`** → **`router.go`** to **home** or **onboarding**.

### Onboarding

- **Route:** `/onboarding`
- **Flow:** Non-swipeable **PageView** — Welcome (hero image + gradient + CTA), gender, age, interests (**exactly four** interests to finish).
- **Persistence:** Saves **completion** via onboarding local data layer; deeper profile fields (**gender / age / interests**) are **not** clearly persisted beyond in-memory Cubit state for API personalization unless extended.

### Home

- **Route:** `/homeView`
- **Content:** Top bar with branding, search navigation, notifications button (**no handler** yet). Featured horizontal carousel from **`FeaturedBooksCubit`** calling Google Books. “Best Seller” region uses **`CustomDetailedBookBuilder`**, which is currently a **fixed placeholder list** (not **`NewestBooksCubit`**-driven).

### Book details

- **Route:** `/bookDetailsView`
- **Content:** Mostly **hardcoded exemplar UI** (“The Jungle Book” style copy), rating widget, buttons, horizontal “similar” strip with placeholder images.

### Search

- **Route:** `/searchView`
- **Content:** Search field UI + **`ListView`** of placeholder rows (**no live query** wired to Dio/use cases).

---

## Incomplete / not finished areas

| Item | Detail |
|------|--------|
| **Authentication** | Sign-in/sign-up feature paths largely removed or unfinished; **`CardGoogle`** is a styled control, not an OAuth pipeline. |
| **Newest / best-seller UX** | `NewestBooksCubit` not driven from widgets; Hive write path exists remote-side without matching read UI. |
| **Cache/offline UX** | `HomeLocalDataSource` unused in repository fallback strategy at time of writing. |
| **Book navigation** | **No route arguments**: featured items **don’t navigate** with book data; list rows that push details still show generic content. |
| **Similar books** | Placeholder data; **`ListView.builder` may lack explicit `itemCount`** in horizontal similar list widget. |
| **Search backend** | No debounced/API-backed search Cubit/state. |
| **Secrets hygiene** | **API key embedded** in remote data source strings — migrate to **`--dart-define`**, `.env`/CI secrets, or a backend proxy. |
| **Product identity** | `name: adv` vs Android applicationId/bundle naming and store branding inconsistent for release polish. |

---

## Suggested new features

1. **Parameterized book navigation** (`GoRouter` `extra`, or **`/books/:volumeId`** + detail fetch) so every list row reflects real volumes.
2. **Search implementation** wired to **`volumes?q=`** plus empty/error/offline UX.
3. **Home sections** driven by **`NewestBooksCubit`** or unified home **`HomeFeedCubit`** with multiple sections (featured/newest/topics).
4. **Repository caching** — Hive read on failure/stale TTL using existing `HomeLocalDataSource`.
5. **Reading list / favorites** (Hive-first, optional backend after auth).
6. **Persist onboarding choices** → default feed queries (“genres” from onboarding).
7. **Book actions:** preview/link from Google Books `accessInfo`, share, semantics/large text tuning.
8. **Lightweight reminders** → later **push/local notifications** tied to authenticated accounts.
9. **Auth revival** → sync lists/profile; optionally real **Google Sign-In**, not cosmetic card only.
10. **Tech debt hygiene** — remove unused heavyweight dependencies; unify widget paths; rename package for store publication.

---

*Generated from codebase review and kept as living documentation — update sections when behaviors change.*
