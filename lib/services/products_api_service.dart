import 'package:dio/dio.dart';
import 'api_client.dart';
import '../models/api/product.dart';
import '../models/api/api_response.dart';
import '../config/api_config.dart';

class ProductsApiService {
  final ApiClient _apiClient = ApiClient();

  Future<PaginatedResponse<Product>> getProducts({
    int? category,
    String? search,
    String? condition,
    String? sort,
    double? minPrice,
    double? maxPrice,
    int? sellerId,
    int page = 1,
    int perPage = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };

    if (category != null) queryParams['category'] = category;
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (condition != null) queryParams['condition'] = condition;
    if (sort != null) queryParams['sort'] = sort;
    if (minPrice != null) queryParams['min_price'] = minPrice;
    if (maxPrice != null) queryParams['max_price'] = maxPrice;
    if (sellerId != null) queryParams['seller_id'] = sellerId;

    final response = await _apiClient.get(
      ApiConfig.products,
      queryParameters: queryParams,
    );

    return PaginatedResponse.fromJson(
      response.data,
      (json) => Product.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<Product>> getProduct(int id) async {
    final response = await _apiClient.get('${ApiConfig.products}/$id');
    return ApiResponse.fromJson(
      response.data,
      (json) => Product.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<Product>> createProduct({
    required String title,
    required int categoryId,
    required double price,
    required String description,
    double? originalPrice,
    String conditionType = 'good',
    bool negotiable = false,
    int availableQuantity = 1,
    double deliveryFee = 1500,
    required List<String> imagePaths,
  }) async {
    final formData = FormData.fromMap({
      'title': title,
      'category_id': categoryId,
      'price': price,
      'description': description,
      'condition_type': conditionType,
      'negotiable': negotiable ? 1 : 0,
      'available_quantity': availableQuantity,
      'delivery_fee': deliveryFee,
      'original_price': originalPrice,
    });

    for (var i = 0; i < imagePaths.length; i++) {
      formData.files.add(MapEntry(
        'images[$i]',
        await MultipartFile.fromFile(imagePaths[i]),
      ));
    }

    final response = await _apiClient.upload(
      ApiConfig.products,
      formData: formData,
    );

    return ApiResponse.fromJson(
      response.data,
      (json) => Product.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<Product>> updateProduct(
    int id, {
    String? title,
    int? categoryId,
    double? price,
    String? description,
    String? conditionType,
    bool? negotiable,
    int? availableQuantity,
    double? deliveryFee,
  }) async {
    final data = <String, dynamic>{};
    if (title != null) data['title'] = title;
    if (categoryId != null) data['category_id'] = categoryId;
    if (price != null) data['price'] = price;
    if (description != null) data['description'] = description;
    if (conditionType != null) data['condition_type'] = conditionType;
    if (negotiable != null) data['negotiable'] = negotiable ? 1 : 0;
    if (availableQuantity != null) data['available_quantity'] = availableQuantity;
    if (deliveryFee != null) data['delivery_fee'] = deliveryFee;

    final response = await _apiClient.put('${ApiConfig.products}/$id', data: data);

    return ApiResponse.fromJson(
      response.data,
      (json) => Product.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> deleteProduct(int id) async {
    final response = await _apiClient.delete('${ApiConfig.products}/$id');
    return ApiResponse.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> bookmarkProduct(int id) async {
    final response = await _apiClient.post('${ApiConfig.products}/$id/bookmark');
    return ApiResponse.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> unbookmarkProduct(int id) async {
    final response = await _apiClient.delete('${ApiConfig.products}/$id/bookmark');
    return ApiResponse.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );
  }
}