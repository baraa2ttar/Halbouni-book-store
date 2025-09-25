class ValidationService {

  static String? requiredField(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? "This field"} is required';
    }
    return null;
  }


  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }


  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Enter a valid phone number';
    }
    return null;
  }


  static String? minLength(String? value, int length, {String? fieldName}) {
    if (value == null || value.trim().length < length) {
      return '${fieldName ?? "This field"} must be at least $length characters';
    }
    return null;
  }

  /// Validates that two fields match (e.g. password confirmation)
  static String? matchFields(String? value, String? compareValue, {String? fieldName}) {
    if (value != compareValue) {
      return '${fieldName ?? "Fields"} do not match';
    }
    return null;
  }
  /// General numeric range validator for integer inputs like age.
  /// Checks required, integer parsing, and optional min/max range.
  static String? intRange({
    required String? value,
    String? fieldName,
    int? min,
    int? max,
  }) {
    // Check required
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? "This field"} is required';
    }

    // Parse to int
    final number = int.tryParse(value.trim());
    if (number == null) {
      return 'Enter a valid number for ${fieldName ?? "this field"}';
    }

    // Check min
    if (min != null && number < min) {
      return '${fieldName ?? "This field"} must be at least $min';
    }

    // Check max
    if (max != null && number > max) {
      return '${fieldName ?? "This field"} must be at most $max';
    }

    return null;
  }
}
