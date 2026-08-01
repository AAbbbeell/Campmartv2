import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException(this.message, {this.statusCode, this.data});

  @override
  String toString() => 'ApiException: $message';
}

class ApiClient {
  late final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      sendTimeout: ApiConfig.sendTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add authorization header if token exists
        final token = await _storage.read(key: ApiConfig.accessTokenKey);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (error, handler) async {
        // Handle 401 Unauthorized - try to refresh token
        if (error.response?.statusCode == 401) {
          try {
            final refreshed = await _refreshToken();
            if (refreshed) {
              // Retry the original request
              final token = await _storage.read(key: ApiConfig.accessTokenKey);
              error.requestOptions.headers['Authorization'] = 'Bearer $token';
              final response = await _dio.fetch(error.requestOptions);
              return handler.resolve(response);
            }
          } catch (e) {
            // Refresh failed, clear tokens and proceed with error
            await _clearTokens();
          }
        }

        // Handle other errors
        final message = _parseErrorMessage(error);
        final exception = ApiException(
          message,
          statusCode: error.response?.statusCode,
          data: error.response?.data,
        );
        return handler.reject(DioException(
          requestOptions: error.requestOptions,
          error: exception,
          response: error.response,
          type: error.type,
        ));
      },
    ));
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _storage.read(key: ApiConfig.refreshTokenKey);
      if (refreshToken == null) return false;

      final response = await _dio.post(
        '${ApiConfig.auth}/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        await _storage.write(
          key: ApiConfig.accessTokenKey,
          value: data['access_token'],
        );
        await _storage.write(
          key: ApiConfig.refreshTokenKey,
          value: data['refresh_token'],
        );
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<void> _clearTokens() async {
    await _storage.delete(key: ApiConfig.accessTokenKey);
    await _storage.delete(key: ApiConfig.refreshTokenKey);
  }

  String _parseErrorMessage(DioException error) {
    if (error.response?.data != null) {
      final data = error.response!.data;
      if (data is Map) {
        if (data['message'] != null) {
          return data['message'] as String;
        }
        if (data['errors'] != null) {
          final errors = data['errors'];
          if (errors is Map) {
            return errors.values.join(', ');
          }
        }
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network.';
      case DioExceptionType.badResponse:
        return 'Server error: ${error.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.unknown:
        return 'An unexpected error occurred. Please try again.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  // HTTP Methods
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw e.error ?? ApiException('GET request failed');
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw e.error ?? ApiException('POST request failed');
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw e.error ?? ApiException('PUT request failed');
    }
  }

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw e.error ?? ApiException('PATCH request failed');
    }
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw e.error ?? ApiException('DELETE request failed');
    }
  }

  // FormData for file uploads
  Future<Response> upload(
    String path, {
    required FormData formData,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: formData,
        options: options ??
            Options(
              contentType: 'multipart/form-data',
            ),
      );
    } on DioException catch (e) {
      throw e.error ?? ApiException('Upload failed');
    }
  }
}
