import 'dart:core';

mixin ValidationMixin {
  bool isValidEmail(String email) {
    // Email validation using a regular expression
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  bool isValidPassword(String password) {
    // Password validation using a regular expression
    // This regex enforces at least one uppercase letter, one lowercase letter,
    // one digit, one special character, and a minimum length of 8 characters.
    final passwordRegex = RegExp(
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    return passwordRegex.hasMatch(password);
  }

  bool isValidPhoneNumber(String phoneNumber) {
    // Phone number validation using a regular expression
    // This regex allows numbers with optional dashes, spaces, or parentheses
    final phoneRegex = RegExp(r'^\+?1?\d{10}$');
    return phoneRegex.hasMatch(phoneNumber);
  }
}
