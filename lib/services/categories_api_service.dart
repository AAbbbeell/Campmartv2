import 'api_client.dart';
import '../models/api/category.dart';
import '../models/api/user.dart';
import '../models/api/api_response.dart';
import '../config/api_config.dart';

class CategoriesApiService {
  final ApiClient _apiClient = ApiClient();

  Future<ApiResponse<List<Category>>> getCategories() async {
    final response = await _apiClient.get(ApiConfig.categories);
    return ApiResponse.fromJson(
      response.data,
      (json) => (json as List)
          .map((item) => Category.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<ApiResponse<Category>> getCategory(int id) async {
    final response = await _apiClient.get('${ApiConfig.categories}/$id');
    return ApiResponse.fromJson(
      response.data,
      (json) => Category.fromJson(json as Map<String, dynamic>),
    );
  }
}

class UniversitiesApiService {
  final ApiClient _apiClient = ApiClient();

  Future<ApiResponse<List<University>>> getUniversities() async {
    final response = await _apiClient.get(ApiConfig.universities);
    return ApiResponse.fromJson(
      response.data,
      (json) => (json as List)
          .map((item) => University.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<ApiResponse<University>> getUniversity(int id) async {
    final response = await _apiClient.get('${ApiConfig.universities}/$id');
    return ApiResponse.fromJson(
      response.data,
      (json) => University.fromJson(json as Map<String, dynamic>),
    );
  }
}
