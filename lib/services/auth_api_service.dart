import 'package:flutter/material.dart';
import 'api_client.dart';
import 'token_service.dart';
import '../models/api/user.dart';
import '../config/api_config.dart';

class AuthApiService extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  final TokenService _tokenService = TokenService();

  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    if (await _tokenService.hasValidToken()) {
      await fetchCurrentUser();
    }
  }

  Future<String?> login({
    required String emailOrPhone,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiClient.post(
        '${ApiConfig.auth}/login',
        data: {
          'emailOrPhone': emailOrPhone,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(response.data['data']);
        
        await _tokenService.saveTokens(
          accessToken: authResponse.accessToken,
          refreshToken: authResponse.refreshToken,
        );

        _user = authResponse.user;
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } on ApiException catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.message;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return 'An error occurred during login';
    }

    _isLoading = false;
    notifyListeners();
    return 'Login failed';
  }

  Future<String?> signup({
    required String firstname,
    required String lastname,
    required String email,
    required String phone,
    required String password,
    int? universityId,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiClient.post(
        '${ApiConfig.auth}/signup',
        data: {
          'firstname': firstname,
          'lastname': lastname,
          'email': email,
          'phone': phone,
          'password': password,
          'university_id': universityId,
        },
      );

      if (response.statusCode == 201) {
        final authResponse = AuthResponse.fromJson(response.data['data']);
        
        await _tokenService.saveTokens(
          accessToken: authResponse.accessToken,
          refreshToken: authResponse.refreshToken,
        );

        _user = authResponse.user;
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } on ApiException catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.message;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return 'An error occurred during signup';
    }

    _isLoading = false;
    notifyListeners();
    return 'Signup failed';
  }

  Future<void> logout() async {
    try {
      await _apiClient.post('${ApiConfig.auth}/logout');
    } catch (e) {
      // Ignore logout errors - just clear local tokens
    } finally {
      await _tokenService.clearTokens();
      _user = null;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCurrentUser() async {
    try {
      final response = await _apiClient.get('${ApiConfig.auth}/me');
      
      if (response.statusCode == 200) {
        _user = User.fromJson(response.data['data']);
        notifyListeners();
      }
    } catch (e) {
      // If fetching user fails, they might be logged out
      await _tokenService.clearTokens();
      _user = null;
      notifyListeners();
    }
  }

  Future<bool> refreshToken() async {
    try {
      final refreshToken = await _tokenService.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _apiClient.post(
        '${ApiConfig.auth}/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(response.data['data']);
        
        await _tokenService.saveTokens(
          accessToken: authResponse.accessToken,
          refreshToken: authResponse.refreshToken,
        );

        _user = authResponse.user;
        notifyListeners();
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }
}
