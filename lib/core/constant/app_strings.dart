/// Central place for user-facing strings.
///
/// English for now; Arabic/RTL comes later, so keep every user-facing string
/// here instead of hardcoding it. New strings are added incrementally; do not
/// refactor strings that already live elsewhere.
class AppStrings {
  AppStrings._();

  /// Currency suffix appended by `formatSyp`, e.g. "1,250 SYP".
  static const String sypSuffix = 'SYP';

  /// Heading shown above the description on the book details page when the
  /// product has a `book_details` row.
  static const String aboutThisBook = 'About this book';

  /// Heading shown above the description when the product has no book details.
  static const String descriptionHeading = 'Description';

  /// Toggle labels for the collapsible description.
  static const String readMore = 'Read more';
  static const String showLess = 'Show less';

  /// Friendly error shown when a list fails to load, with a Retry button.
  static const String retry = 'Retry';
  static const String friendlyError = 'Something went wrong. Please try again.';
}
