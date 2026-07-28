import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'createdAt': createdAt.toIso8601String(),
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

class AuthService extends ChangeNotifier {
  static const _userKey = 'auth_user';
  static const _passwordKey = 'auth_passwords';

  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      _user = User.fromJson(jsonDecode(userJson));
      notifyListeners();
    }
  }

  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    _user = user;
    notifyListeners();
  }

  Future<void> _storePassword(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final passwordsJson = prefs.getString(_passwordKey) ?? '{}';
    final passwords = Map<String, String>.from(jsonDecode(passwordsJson));
    passwords[email] = password;
    await prefs.setString(_passwordKey, jsonEncode(passwords));
  }

  Future<bool> _verifyPassword(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final passwordsJson = prefs.getString(_passwordKey) ?? '{}';
    final passwords = Map<String, String>.from(jsonDecode(passwordsJson));
    return passwords[email] == password;
  }

  String? _validateEmail(String email) {
    if (email.trim().isEmpty) return 'Email is required';
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(email.trim())) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) return 'Password is required';
    if (password.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    final emailError = _validateEmail(email);
    if (emailError != null) return emailError;

    final passwordError = _validatePassword(password);
    if (passwordError != null) return passwordError;

    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    final valid = await _verifyPassword(email.trim(), password);
    if (!valid) {
      _isLoading = false;
      notifyListeners();
      return 'Invalid email or password';
    }

    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString('auth_users') ?? '[]';
    final users = List<Map<String, dynamic>>.from(jsonDecode(usersJson));
    final userData = users.firstWhere(
      (u) => u['email'] == email.trim(),
      orElse: () => {},
    );

    if (userData.isEmpty) {
      _isLoading = false;
      notifyListeners();
      return 'Account not found';
    }

    await _saveUser(User.fromJson(userData));
    _isLoading = false;
    notifyListeners();
    return null;
  }

  Future<String?> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    if (name.trim().isEmpty) return 'Name is required';

    final emailError = _validateEmail(email);
    if (emailError != null) return emailError;

    if (phone.trim().isEmpty) return 'Phone number is required';

    final passwordError = _validatePassword(password);
    if (passwordError != null) return passwordError;

    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Check if email already exists
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString('auth_users') ?? '[]';
    final users = List<Map<String, dynamic>>.from(jsonDecode(usersJson));
    if (users.any((u) => u['email'] == email.trim())) {
      _isLoading = false;
      notifyListeners();
      return 'Email already registered';
    }

    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name.trim(),
      email: email.trim(),
      phone: phone.trim(),
      createdAt: DateTime.now(),
    );

    users.add(newUser.toJson());
    await prefs.setString('auth_users', jsonEncode(users));
    await _storePassword(email.trim(), password);
    await _saveUser(newUser);

    _isLoading = false;
    notifyListeners();
    return null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    _user = null;
    notifyListeners();
  }
}
