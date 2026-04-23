import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  final String firstName;
  final String lastName;

  const UserSession({
    required this.firstName,
    required this.lastName,
  });

  String get fullName => '$firstName $lastName'.trim();
}

class SessionManager {
  static const String _firstNameKey = 'session_first_name';
  static const String _lastNameKey = 'session_last_name';
  static const String _isLoggedInKey = 'session_is_logged_in';

  static final ValueNotifier<UserSession?> currentUser =
      ValueNotifier<UserSession?>(null);

  static Future<void> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
    if (!isLoggedIn) {
      currentUser.value = null;
      return;
    }
    final String firstName = prefs.getString(_firstNameKey) ?? '';
    final String lastName = prefs.getString(_lastNameKey) ?? '';
    if (firstName.trim().isEmpty) {
      currentUser.value = null;
      return;
    }
    currentUser.value = UserSession(
      firstName: firstName,
      lastName: lastName,
    );
  }

  static Future<void> signIn({
    required String firstName,
    required String lastName,
  }) async {
    final String normalizedFirst = firstName.trim();
    final String normalizedLast = lastName.trim();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_firstNameKey, normalizedFirst);
    await prefs.setString(_lastNameKey, normalizedLast);
    await prefs.setBool(_isLoggedInKey, true);
    currentUser.value = UserSession(
      firstName: normalizedFirst,
      lastName: normalizedLast,
    );
  }

  static Future<void> signOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
    currentUser.value = null;
  }
}
