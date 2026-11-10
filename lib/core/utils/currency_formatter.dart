import '../constant/app_strings.dart';

/// Formats [amount] as a whole-number price in the NEW Syrian pound (SYP).
///
/// - Rounds to the nearest whole number.
/// - Inserts a comma as the thousands separator.
/// - Appends the " SYP" suffix from [AppStrings].
/// - Clamps negative values to 0.
/// - The result never contains "$" or ".".
String formatSyp(num amount) {
  final rounded = amount < 0 ? 0 : amount.round();
  final digits = rounded.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i != 0 && (digits.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(digits[i]);
  }
  return '${buffer.toString()} ${AppStrings.sypSuffix}';
}
