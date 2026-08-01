import 'api_client.dart';
import '../models/api/service.dart';
import '../models/api/api_response.dart';
import '../config/api_config.dart';

class ServicesApiService {
  final ApiClient _apiClient = ApiClient();

  Future<PaginatedResponse<Service>> getServices({
    int? category,
    String? search,
    String? availability,
    String? sort,
    double? minPrice,
    double? maxPrice,
    int? providerId,
    int page = 1,
    int perPage = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };

    if (category != null) queryParams['category'] = category;
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (availability != null) queryParams['availability'] = availability;
    if (sort != null) queryParams['sort'] = sort;
    if (minPrice != null) queryParams['min_price'] = minPrice;
    if (maxPrice != null) queryParams['max_price'] = maxPrice;
    if (providerId != null) queryParams['provider_id'] = providerId;

    final response = await _apiClient.get(
      ApiConfig.services,
      queryParameters: queryParams,
    );

    return PaginatedResponse.fromJson(
      response.data,
      (json) => Service.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<Service>> getService(int id) async {
    final response = await _apiClient.get('${ApiConfig.services}/$id');
    return ApiResponse.fromJson(
      response.data,
      (json) => Service.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<Service>> createService({
    required String title,
    required int categoryId,
    required double price,
    required String description,
    String? shortDescription,
    String pricingType = 'fixed',
    String? deliveryTime,
    String availability = 'available',
    List<String>? portfolioImages,
    List<String>? skills,
  }) async {
    final data = <String, dynamic>{
      'title': title,
      'category_id': categoryId,
      'price': price,
      'description': description,
      'pricing_type': pricingType,
      'availability': availability,
    };

    if (shortDescription != null) data['short_description'] = shortDescription;
    if (deliveryTime != null) data['delivery_time'] = deliveryTime;
    if (portfolioImages != null) data['portfolio_images'] = portfolioImages;
    if (skills != null) data['skills'] = skills;

    final response = await _apiClient.post(ApiConfig.services, data: data);

    return ApiResponse.fromJson(
      response.data,
      (json) => Service.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<Service>> updateService(
    int id, {
    String? title,
    int? categoryId,
    double? price,
    String? description,
    String? shortDescription,
    String? pricingType,
    String? deliveryTime,
    String? availability,
    List<String>? portfolioImages,
    List<String>? skills,
  }) async {
    final data = <String, dynamic>{};
    if (title != null) data['title'] = title;
    if (categoryId != null) data['category_id'] = categoryId;
    if (price != null) data['price'] = price;
    if (description != null) data['description'] = description;
    if (shortDescription != null) data['short_description'] = shortDescription;
    if (pricingType != null) data['pricing_type'] = pricingType;
    if (deliveryTime != null) data['delivery_time'] = deliveryTime;
    if (availability != null) data['availability'] = availability;
    if (portfolioImages != null) data['portfolio_images'] = portfolioImages;
    if (skills != null) data['skills'] = skills;

    final response = await _apiClient.put('${ApiConfig.services}/$id', data: data);

    return ApiResponse.fromJson(
      response.data,
      (json) => Service.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> deleteService(int id) async {
    final response = await _apiClient.delete('${ApiConfig.services}/$id');
    return ApiResponse.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> bookmarkService(int id) async {
    final response = await _apiClient.post('${ApiConfig.services}/$id/bookmark');
    return ApiResponse.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> unbookmarkService(int id) async {
    final response = await _apiClient.delete('${ApiConfig.services}/$id/bookmark');
    return ApiResponse.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );
  }
}
