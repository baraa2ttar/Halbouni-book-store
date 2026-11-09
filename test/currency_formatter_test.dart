import 'dart:math';

import 'package:adv/core/utils/currency_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatSyp', () {
    test('formats whole numbers with a thousands separator and SYP suffix', () {
      expect(formatSyp(0), '0 SYP');
      expect(formatSyp(25), '25 SYP');
      expect(formatSyp(1250), '1,250 SYP');
      expect(formatSyp(1250000), '1,250,000 SYP');
    });

    test('rounds to a whole number', () {
      expect(formatSyp(1250.7), '1,251 SYP');
    });

    test('clamps negative values to 0', () {
      expect(formatSyp(-5), '0 SYP');
      expect(formatSyp(-1250.7), '0 SYP');
    });

    test('never contains a dollar sign or decimal point', () {
      const values = [0, 25, 1250, 1250000, 1250.7, -5, 9999999, 1000];
      for (final value in values) {
        final result = formatSyp(value);
        expect(
          result.contains(r'$'),
          isFalse,
          reason: 'value: $value -> "$result" must not contain a dollar sign',
        );
        expect(
          result.contains('.'),
          isFalse,
          reason: 'value: $value -> "$result" must not contain a decimal point',
        );
        expect(result.endsWith(' SYP'), isTrue);
      }
    });

    test('random integers stay whole, grouped, and SYP-suffixed', () {
      final rng = Random(42);
      for (var i = 0; i < 500; i++) {
        final value = rng.nextInt(10000000);
        final result = formatSyp(value);
        expect(result.endsWith(' SYP'), isTrue);
        expect(result.contains('.'), isFalse);
        expect(result.contains(r'$'), isFalse);
        // Strip " SYP" (4 chars) and commas; the remainder must be the digits.
        final digits = result
            .substring(0, result.length - 4)
            .replaceAll(',', '');
        expect(int.parse(digits), value);
      }
    });
  });
}
