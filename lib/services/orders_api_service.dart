import 'api_client.dart';
import '../models/api/order.dart';
import '../models/api/api_response.dart';
import '../config/api_config.dart';

class OrdersApiService {
  final ApiClient _apiClient = ApiClient();

  Future<PaginatedResponse<Order>> getOrders({
    String? status,
    int page = 1,
    int perPage = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };

    if (status != null) queryParams['status'] = status;

    final response = await _apiClient.get(
      ApiConfig.orders,
      queryParameters: queryParams,
    );

    return PaginatedResponse.fromJson(
      response.data,
      (json) => Order.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<Order>> getOrder(int id) async {
    final response = await _apiClient.get('${ApiConfig.orders}/$id');
    return ApiResponse.fromJson(
      response.data,
      (json) => Order.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<Order>> createOrder({
    required int productId,
    required int quantity,
    required String paymentMethod,
    String? deliveryLocation,
  }) async {
    final response = await _apiClient.post(
      ApiConfig.orders,
      data: {
        'product_id': productId,
        'quantity': quantity,
        'payment_method': paymentMethod,
        'delivery_location': deliveryLocation,
      },
    );

    return ApiResponse.fromJson(
      response.data,
      (json) => Order.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<Order>> updateOrderStatus(
    int id, {
    required String status,
  }) async {
    final response = await _apiClient.patch(
      '${ApiConfig.orders}/$id/status',
      data: {'status': status},
    );

    return ApiResponse.fromJson(
      response.data,
      (json) => Order.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> cancelOrder(int id) async {
    final response = await _apiClient.post('${ApiConfig.orders}/$id/cancel');
    return ApiResponse.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );
  }
}
