import 'api_client.dart';
import '../models/api/bookmark.dart';
import '../models/api/api_response.dart';
import '../config/api_config.dart';

class BookmarksApiService {
  final ApiClient _apiClient = ApiClient();

  Future<PaginatedResponse<Bookmark>> getBookmarks({
    String? type,
    int page = 1,
    int perPage = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };

    if (type != null) queryParams['type'] = type;

    final response = await _apiClient.get(
      ApiConfig.bookmarks,
      queryParameters: queryParams,
    );

    return PaginatedResponse.fromJson(
      response.data,
      (json) => Bookmark.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<Bookmark>> addBookmark({
    required String type,
    required int itemId,
  }) async {
    final response = await _apiClient.post(
      ApiConfig.bookmarks,
      data: {
        'type': type,
        'item_id': itemId,
      },
    );

    return ApiResponse.fromJson(
      response.data,
      (json) => Bookmark.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> removeBookmark(int id) async {
    final response = await _apiClient.delete('${ApiConfig.bookmarks}/$id');
    return ApiResponse.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );
  }
}
