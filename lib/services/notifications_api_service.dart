import 'api_client.dart';
import '../models/api/notification.dart';
import '../models/api/api_response.dart';
import '../config/api_config.dart';

class NotificationsApiService {
  final ApiClient _apiClient = ApiClient();

  Future<PaginatedResponse<Notification>> getNotifications({
    String? type,
    bool? unreadOnly,
    int page = 1,
    int perPage = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };

    if (type != null) queryParams['type'] = type;
    if (unreadOnly != null) queryParams['unread_only'] = unreadOnly;

    final response = await _apiClient.get(
      ApiConfig.notifications,
      queryParameters: queryParams,
    );

    return PaginatedResponse.fromJson(
      response.data,
      (json) => Notification.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<Notification>> markAsRead(int id) async {
    final response = await _apiClient.post('${ApiConfig.notifications}/$id/read');
    return ApiResponse.fromJson(
      response.data,
      (json) => Notification.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> markAllAsRead() async {
    final response = await _apiClient.post('${ApiConfig.notifications}/read-all');
    return ApiResponse.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> deleteNotification(int id) async {
    final response = await _apiClient.delete('${ApiConfig.notifications}/$id');
    return ApiResponse.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );
  }

  Future<ApiResponse<int>> getUnreadCount() async {
    final response = await _apiClient.get('${ApiConfig.notifications}/unread-count');
    return ApiResponse.fromJson(
      response.data,
      (json) => json as int,
    );
  }
}
