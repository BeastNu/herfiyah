/// Shared form-validation helpers used across the app.

class Validators {
  Validators._();

  /// Returns an error message if [email] is not a valid email address,
  /// or `null` if it passes.
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an email address';
    }
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!regex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Returns an error message if [password] is too short / weak, or `null`.
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Generic "required" check — rejects null / blank strings.
  static String? required(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Phone number validation (simple — accepts 7-15 digits).
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a phone number';
    }
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length < 7 || digitsOnly.length > 15) {
      return 'Please enter a valid phone number';
    }
    return null;
  }
}