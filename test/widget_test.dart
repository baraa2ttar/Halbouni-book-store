import 'package:adv/core/helpers/validation_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ValidationService.email', () {
    test('accepts standard email addresses', () {
      expect(ValidationService.email('user@example.com'), isNull);
      expect(ValidationService.email('first.last@sub.domain.org'), isNull);
      expect(ValidationService.email('user+tag@domain.co'), isNull);
    });

    test('accepts long TLDs such as .store and .online', () {
      expect(ValidationService.email('reader@publisher.store'), isNull);
      expect(ValidationService.email('reader@shop.online'), isNull);
      expect(ValidationService.email('a@b.museum'), isNull);
    });

    test('rejects empty or whitespace-only values', () {
      expect(ValidationService.email(null), 'Email is required');
      expect(ValidationService.email(''), 'Email is required');
      expect(ValidationService.email('   '), 'Email is required');
    });

    test('rejects malformed addresses', () {
      const invalid = 'Enter a valid email address';
      expect(ValidationService.email('plainaddress'), invalid);
      expect(ValidationService.email('user@'), invalid);
      expect(ValidationService.email('@domain.com'), invalid);
      expect(ValidationService.email('user@domain'), invalid);
      expect(ValidationService.email('user name@domain.com'), invalid);
    });
  });
}