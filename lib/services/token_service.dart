import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';

class TokenService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: ApiConfig.accessTokenKey, value: accessToken);
    await _storage.write(key: ApiConfig.refreshTokenKey, value: refreshToken);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: ApiConfig.accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: ApiConfig.refreshTokenKey);
  }

  Future<bool> hasValidToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: ApiConfig.accessTokenKey);
    await _storage.delete(key: ApiConfig.refreshTokenKey);
  }

  Future<bool> isTokenExpired() async {
    // Simple implementation - you can add JWT expiration checking here
    final token = await getAccessToken();
    return token == null || token.isEmpty;
  }
}
