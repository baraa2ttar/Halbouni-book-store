# Halbouni Book Store — Design Guide

Quick reference for colors, typography, assets, screens, and design tokens.

---

## Design Size

**375 × 812** (iPhone X) — `ScreenUtilInit` in `main.dart`  
Extensions: `.h` (height), `.w` (width), `.sp` (font) from `flutter_screenutil`.

---

## Theme

| Property | Value |
|----------|-------|
| Material | Material 3 enabled |
| Font Family | `Rubik` (bundled) |
| Scaffold Background | `AppColor.whiteColor` (`#FFFFFF`) |
| Status Bar | Dark icons (`Brightness.dark`) |
| Debug Banner | Disabled |

---

## Colors — `AppColor`

### Primary

| Name | Hex | Usage |
|------|-----|-------|
| `primaryColor` | `#F79201` | Buttons, accents, selected chips, cart button |
| `whiteColor` | `#FFFFFF` | Scaffold background, text on dark buttons |
| `blackColor` | `#000000` | Price button background, primary text |

### Text & Neutral

| Name | Hex | Usage |
|------|-----|-------|
| `titleColor` | `#333333` | Headline text |
| `darkColor` | `#222222` | Dark backgrounds |
| `greyColor` | `#677294` (50% opacity) | Secondary text |
| `darkGreyColor` | `#677294` | Subtitle text, author names |
| `lightGreyColor` | `#959CB4CC` | Placeholder, disabled states |
| `navbarIconColor` | `#858EA9` | Navigation bar icons |
| `unselectedFavoriteColor` | `#E2E5EA` | Unselected favorite toggle |

### Semantic

| Name | Hex | Usage |
|------|-----|-------|
| `redColor` | `#FF0000` | Error states |
| `yellowColor` | `#F6D060` | Warning, rating star |
| `whiteColor2` | `#F7D6BA` | Light warm accent |

### Container / Card Colors

| Name | Hex | Usage |
|------|-----|-------|
| `containerBlueColor` | `#2753F3` | Info cards |
| `containerPurpleColor` | `#AAA3D7` | Category cards |
| `containerRedColor` | `#FF484C` | Alert/error cards |
| `containerOrangeColor` | `#F39E97` | Warm accent cards |
| `containerDarkOrangeColor` | `#FE7F44` | Highlight cards |
| `containerYellowColor` | `#FFCF68` | Featured cards |
| `containerDarkGreenColor` | `#0EBE7E` | Success cards |
| `containerGreenColor` | `#07D9AD` | Success/active states |
| `emptyContainerColor` | `#D3F3EB` | Empty state backgrounds |

### Greens & Blues

| Name | Hex | Usage |
|------|-----|-------|
| `lightGreenColor` | `#C6DDF3DB` | Light green background |
| `shadowGreenColor` | `#B7EBD9` | Green shadows |
| `shadowBlueColor` | `#D8F3FF` | Blue shadows |
| `lightBlueColor` | `#4D2196F3` | Light blue overlay |
| `lightgreenColor` | `#BDCCE5` | Subtle green tint |
| `lightblueColor` | `#C6EFE5` | Subtle blue tint |

### Settings & Misc

| Name | Hex | Usage |
|------|-----|-------|
| `settingsRedColor` | `#EB5757` | Settings destructive actions |
| `settingsGreenColor` | `#219653` | Settings positive toggle |
| `settingsBlueColor` | `#56CCF2` | Settings info |
| `settingsOrangeColor` | `#F2994A` | Settings warning |
| `privacyPolicyColor` | `#AAB0C3` | Privacy text |
| `dividerColor` | `#D7F4F7` | Divider lines |
| `labelColor` | `#D8F2F3` | Input labels |
| `cameraContainerColor` | `#558190` | Camera overlay |
| `lightgrayColor` | `#C4C4C4` | Generic light grey |
| `lightColor` | `#E6F8F2` | Very light green bg |
| `afani` | `#AE9B2E` | Gold accent |

---

## Typography — `AppTextStyles`

### Context-Aware (use `context`)

| Method | Size | Weight | Color | Notes |
|--------|------|--------|-------|-------|
| `headline(context)` | 28sp | w500 | `titleColor` | Main headlines |
| `subtitle(context)` | 14sp | w400 | `darkGreyColor` | Subtitles |
| `hintText(context)` | 16sp | w300 | `darkGreyColor` | Search/input hints |
| `titleText(context)` | 18sp | w500 | `blackColor` | Section titles (Best Seller) |
| `headlineSize12(context)` | 12sp | w500 | `darkGreyColor` | Small labels |
| `headlineAppColor(context)` | 18sp | w500 | `blackColor` | App bar title |
| `subtitleS12(context)` | 12sp | w400 | `darkGreyColor` | Small subtitles |
| `subtitleS20(context)` | 20sp | w400 | `darkGreyColor` | Large subtitles (GT Sectra Fine) |
| `CardTitle(context)` | 14sp | w500 | `darkGreyColor` | Card titles |

### Static (no context needed)

| Name | Size | Weight | Font Family | Notes |
|------|------|--------|-------------|-------|
| `textStyle30` | 30 | w900 | GT Sectra Fine | Book title on details page |
| `textStyle20` | 20 | normal | GT Sectra Fine | Prices, secondary titles |
| `textStyle18` | 18 | w500 | default | Author name, medium text |
| `textStyle16` | 16 | w500 | default | Buttons, cart quantities |
| `textStyle14` | 14 | normal | default | Reviews, small text, descriptions |

---

## Assets — `AppAssets`

| Constant | Path | Usage |
|----------|------|-------|
| `appLogo` | `assets/images/app_logo.png` | App icon, splash, home bar |
| `books_background` | `assets/images/books_background.png` | Backgrounds |
| `google` | `assets/images/google_icon.png` | Google sign-in button |
| `book1` | `assets/images/test_image1.png` | Test/fallback book cover |
| `book2` | `assets/images/test_image2.png` | Test/fallback book cover |
| `book3` | `assets/images/test_image3.png` | Default fallback (error widget) |
| `book4` | `assets/images/test_image4.png` | Test/fallback book cover |

**Root:** `assets/images/`

---

## Screens & Pages

| Screen | Route | Main Widget | Key Components |
|--------|-------|-------------|----------------|
| **Splash** | `/` | `SplashView` | Animated logo, sliding text, 2s delay |
| **Onboarding** | `/onboarding` | `OnboardingScreen` | 4-step PageView: Welcome, Gender, Age, Interests. Signed-in profile recovery reuses Gender/Age/Interests via `?recovery=true` (no separate editor). |
| **Home** | `/homeView` | `HomeView` → `HomeViewBody` | CustomAppBar (logo + search + cart), FeaturedBooksListViewBlocBuilder (horizontal carousel), CategoryChips (8 categories), CustomDetailedBookBuilder (vertical list) |
| **Book Details** | `/bookDetailsView/:id` | `BookDetailsView` → `BookDetailsViewBody` | CustomBookDetailesAppBar (close + cart), book cover, name, author, RatingWidget (display-only), BooksActionButton (price + Add to Cart), SimilarBooksListView (horizontal, by category) |
| **Search** | `/searchView` | `SearchView` → `SearchViewBody` | CustomSearchTextField, debounced BlocBuilder results |
| **Cart** | `/cartView` | `CartView` → `CartViewBody` | Card list: cover + title + author + single price + quantity stepper + remove; order summary (product count, subtotal = TOTAL); full-width Checkout CTA. No vouchers, fees, or strikethrough prices (schema has `products.price` only). |
| **Checkout** | `/checkout` | `CheckoutView` | Delivery Notes card (`orders.notes` text field), non-interactive "Payment Method: Pay on Delivery", order summary (subtotal = TOTAL PAYMENT), Place Order → `place_order` RPC. No address book, shipping options, payment picker, or vouchers. |
| **Profile** | `/profile` | `ProfileView` | Email + generic person icon (no avatar upload), gender/age, incomplete-profile recovery button, favorite categories. |
| **Auth Sign-In** | `/auth/sign-in` | `AuthSignInView` | Email/password fields, Supabase sign-in |
| **Auth Sign-Up** | `/auth/sign-up` | `AuthSignUpView` | Email/password fields, Supabase sign-up |

---

## Key Widgets

| Widget | File | Purpose |
|--------|------|---------|
| `CustomAppBar` | `custom_app_bar.dart` | Home top bar: logo, title, search icon, cart icon |
| `CustomBookDetailesAppBar` | `custom_book_detailes_app_bar.dart` | Details top bar: close (pop), cart icon |
| `RatingWidget` | `rating_widget.dart` | Star icon + dynamic rating value + optional review count (display-only; no in-app rating write) |
| `BooksActionButton` | `booksActionButton.dart` | Price button (black) + "Add to Cart" button (orange) with SnackBar |
| `CustomButton` | `custom_button.dart` | Reusable button with optional `onPressed` callback |
| `CustomListViewItem` | `custom_list_view_item.dart` | Book cover image (CachedNetworkImage with fallback) |
| `CustomDetailedBookItem` | `custom_detailed_book_item.dart` | Full book row: cover + title + author + price + rating |
| `SimilarBooksListView` | `similar_books_listview.dart` | Horizontal list of books from same category |
| `FeaturedBooksListViewBlocBuilder` | `featured_books_listview_builder.dart` | Horizontal featured carousel |
| `_CategoryChips` | `home_view_body.dart` | Horizontal category filter chips |

---

*Source of truth: `lib/core/constant/` and `lib/Features/` — update here when UI changes.*
