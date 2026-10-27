# Requirements Document

## Introduction

The Stock-Aware Catalog UI feature adds five capabilities to the Halbouni Book Store user app: correct SYP currency formatting, book descriptions on the details page, hidden ratings, stock-aware UI with cart re-validation, and pull-to-refresh with retry on catalog lists. All requirements are implemented within the existing architecture (feature-first, Cubit + sealed states, get_it, go_router, Either<Failure,T>) and read only existing backend columns (stock_quantity, is_active, description). No Supabase schema changes are required.

## Glossary

- **System**: The Halbouni Book Store user app (Flutter, package `adv`).
- **CurrencyFormatter**: A new core utility that formats numeric prices as whole-number Syrian pound (SYP) strings with thousands separators.
- **AppStrings**: A new constants class centralizing user-facing strings for this feature.
- **StockBadge**: A new widget that displays an "Out of stock" or "In stock" pill badge.
- **CollapsibleDescription**: A new widget that renders a product description with a heading, collapsing to ~4 lines with a "Read more" / "Show less" toggle.
- **RetryButton**: A new reusable widget for error-state retry actions.
- **CartValidationResult**: A new value object describing what changed during cart re-validation (removed items, price changes, stock reductions).
- **ProductEntity**: The domain entity for a product, extended with `stockQuantity` and `isActive` fields.
- **CartItemModel**: The Hive-backed cart item model, extended with a `stockQuantity` Hive field (index 6).
- **HomeRepo**: The repository interface for catalog data, extended with `fetchProductsByIds`.
- **CartCubit**: The cart state manager, extended with `revalidateCart` and `acknowledgeValidation` methods.
- **needsReview**: A computed property on `CartLoaded` state that returns true when validation found changes and the user has not yet acknowledged them.
- **SYP**: The new Syrian pound currency. All prices are whole numbers (no decimals), displayed with a thousands separator and an "SYP" suffix.
- **place_order RPC**: The existing server-side function that creates an order. Takes `(items jsonb, order_notes text)`. Contract C1 is NOT live.

## Requirements

### Requirement 1: SYP Currency Formatting

**User Story:** As a customer, I want all prices displayed in the correct Syrian pound format, so that I understand pricing without confusion from a foreign currency symbol.

#### Acceptance Criteria

1. THE CurrencyFormatter SHALL format any numeric amount as a whole number rounded to the nearest integer with thousands separators and an " SYP" suffix.
2. THE CurrencyFormatter SHALL never produce output containing the character "$" or a decimal point.
3. WHEN a price is zero, THE CurrencyFormatter SHALL return "0 SYP".
4. WHEN a fractional price is provided, THE CurrencyFormatter SHALL round to the nearest integer before formatting.
5. THE System SHALL replace every hardcoded "$" price rendering in `lib/` with the CurrencyFormatter output.
6. WHEN a unit test exercises the CurrencyFormatter with inputs 0, 25, 1250, 1250000, and a fractional value, THE test SHALL verify the output matches the expected whole-number SYP format.

### Requirement 2: Book Description on Details Page

**User Story:** As a customer, I want to read the description of a book on its details page, so that I can decide whether to purchase it.

#### Acceptance Criteria

1. WHEN the product details page is displayed and the product has a non-empty description, THE System SHALL render a CollapsibleDescription widget below the main product information.
2. WHEN the product has a BookDetailEntity (i.e., it is a book), THE CollapsibleDescription SHALL use the heading "About this book".
3. WHEN the product does not have a BookDetailEntity (i.e., it is not a book), THE CollapsibleDescription SHALL use the heading "Description".
4. WHEN the description text exceeds approximately 4 lines, THE CollapsibleDescription SHALL collapse the text and display a "Read more" toggle.
5. WHEN the "Read more" toggle is activated, THE CollapsibleDescription SHALL expand the full text and display a "Show less" toggle.
6. WHEN the product has an empty or null description, THE System SHALL hide the description section entirely.
7. WHEN a widget test exercises the CollapsibleDescription with a short description, a long description, and an empty description, THE test SHALL verify the toggle appears only for long text and the section is hidden for empty text.

### Requirement 3: Hide Ratings

**User Story:** As a customer, I do not want to see a constant 0.0 rating, so that I am not misled about product quality.

#### Acceptance Criteria

1. THE System SHALL stop rendering the RatingWidget on the product details page (BookDetailsViewBody).
2. THE System SHALL stop rendering the RatingWidget on the product card (CustomDetailedBookItem).
3. THE System SHALL retain the `rating` field on ProductEntity and ProductModel so future data can use it.
4. THE System SHALL not delete the RatingWidget file if other code imports it.

### Requirement 4: Stock-Aware UI and Cart Re-Validation

**User Story:** As a customer, I want to see stock availability on products and have my cart updated when stock or prices change, so that I cannot order items that are out of stock or pay incorrect prices.

#### Acceptance Criteria

4.1. WHEN a product has `stockQuantity <= 0`, THE System SHALL display an "Out of stock" StockBadge on the product card and the details page.
4.2. WHEN a product has `stockQuantity <= 0`, THE System SHALL disable the add-to-cart button on the details page.
4.3. WHEN the cart screen or checkout opens, THE CartCubit SHALL re-fetch price, stock_quantity, and is_active for all items in the cart using a single `fetchProductsByIds` query with an in-list filter.
4.4. WHEN a cart item's corresponding product is inactive, out of stock, or deleted, THE CartCubit SHALL remove the item from the cart and record the item name in `removedItemNames`.
4.5. WHEN a cart item's server-side price differs from the cart snapshot, THE CartCubit SHALL update the cart item price to the server price and record the item name in `priceChangedNames`.
4.6. WHEN a cart item's quantity exceeds the server-side stock_quantity, THE CartCubit SHALL clamp the quantity to `min(stockQuantity, 20)` and record the item name in `stockReducedNames`.
4.7. WHEN any changes were detected during re-validation, THE System SHALL display a validation message listing what changed and SHALL disable the Place Order button until the customer acknowledges the changes.
4.8. WHEN the customer taps the acknowledge button, THE CartCubit SHALL clear the `pendingValidation` field so that the Place Order button is enabled.
4.9. WHEN no changes were detected during re-validation, THE System SHALL enable the Place Order button without requiring acknowledgment.
4.10. THE cart quantity stepper SHALL not allow the quantity to exceed `min(stockQuantity, 20)`.
4.11. WHEN cubit tests exercise the cart re-validation with scenarios for price changed, stock reduced, item inactive, item out of stock, and nothing changed, THE tests SHALL verify the correct CartValidationResult fields are populated using `bloc_test` and `mocktail`.

### Requirement 5: Pull-to-Refresh and Retry

**User Story:** As a customer, I want to refresh catalog lists by pulling down and retry when errors occur, so that I can recover from network problems without restarting the app.

#### Acceptance Criteria

5.1. WHEN the user pulls down on the home catalog screen, THE System SHALL trigger a refresh of both the featured books and the newest books (respecting the active category filter).
5.2. WHEN the featured books fetch fails, THE System SHALL display a friendly error message and a RetryButton instead of the book list.
5.3. WHEN the newest books fetch fails, THE System SHALL display a friendly error message and a RetryButton instead of the book list.
5.4. WHEN the user taps the RetryButton, THE System SHALL re-fetch the data for that list.
5.5. THE System SHALL not display raw exception messages in error states.

### Requirement 6: Centralized Strings and Direction-Neutral Layout

**User Story:** As a developer, I want user-facing strings centralized and layouts direction-neutral, so that Arabic/RTL localization can be added later without refactoring.

#### Acceptance Criteria

6.1. THE System SHALL store all new user-facing strings introduced by this feature in the AppStrings constants class.
6.2. THE System SHALL use EdgeInsetsDirectional or start/end alignment instead of hardcoded left/right in all new or modified layout code.
6.3. THE System SHALL replace `Alignment.centerLeft` with `AlignmentDirectional.centerStart` in modified views.

### Requirement 7: Data Model Extension

**User Story:** As a developer, I want the product and cart models to carry stock and availability data, so that the UI can make stock-aware decisions.

#### Acceptance Criteria

7.1. THE ProductEntity SHALL include a `stockQuantity` field of type `int` (default 0) and an `isActive` field of type `bool` (default true).
7.2. THE ProductModel.fromJson SHALL parse `stock_quantity` and `is_active` from the JSON response, defaulting to 0 and true respectively when absent.
7.3. THE CartItemModel SHALL include a `stockQuantity` field as `@HiveField(6)` with a default of 0, maintaining backward compatibility with existing Hive-stored cart items.
7.4. THE HomeRepo SHALL define a `fetchProductsByIds` method that takes a list of product IDs and returns a list of ProductEntity.
7.5. THE HomeRepoImpl SHALL implement `fetchProductsByIds` using a Supabase in-filter query that does not filter by `is_active`, so inactive products are returned for validation.
7.6. WHEN `fetchProductsByIds` is called with an empty list, THE HomeRepoImpl SHALL return an empty list without making a network call.
