import 'dart:math';

import 'package:adv/core/helpers/ilike_escape.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test-only inverse: each backslash escapes the character that follows it.
String _unescape(String escaped) {
  final out = StringBuffer();
  for (var i = 0; i < escaped.length; i++) {
    if (escaped[i] == '\\' && i + 1 < escaped.length) {
      i++;
    }
    out.write(escaped[i]);
  }
  return out.toString();
}

int _metaCount(String s) =>
    s.split('').where((c) => c == '\\' || c == '%' || c == '_').length;

void main() {
  group('escapeIlikePattern', () {
    test('leaves ordinary text unchanged', () {
      expect(escapeIlikePattern(''), '');
      expect(escapeIlikePattern('Harry Potter'), 'Harry Potter');
      expect(escapeIlikePattern('كتاب'), 'كتاب');
    });

    test('escapes each metacharacter', () {
      expect(escapeIlikePattern('%'), '\\%');
      expect(escapeIlikePattern('_'), '\\_');
      expect(escapeIlikePattern('\\'), '\\\\');
    });

    test('escapes the backslash first (no double escaping)', () {
      expect(escapeIlikePattern('\\%'), '\\\\\\%');
      expect(escapeIlikePattern('a_b%c\\d'), 'a\\_b\\%c\\\\d');
    });

    test('round trip and length hold for random strings', () {
      final random = Random(42);
      const alphabet = ['a', 'Z', '1', ' ', 'ع', '%', '_', '\\', '-'];
      for (var i = 0; i < 200; i++) {
        final length = random.nextInt(20);
        final s = List.generate(
          length,
          (_) => alphabet[random.nextInt(alphabet.length)],
        ).join();
        final escaped = escapeIlikePattern(s);
        expect(_unescape(escaped), s, reason: 'round trip failed for "$s"');
        expect(escaped.length, s.length + _metaCount(s),
            reason: 'length invariant failed for "$s"');
      }
    });
  });
}
