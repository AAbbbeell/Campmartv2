import 'api_client.dart';
import '../models/api/cart.dart';
import '../models/api/api_response.dart';
import '../config/api_config.dart';

class CartApiService {
  final ApiClient _apiClient = ApiClient();

  Future<ApiResponse<CartSummary>> getCart() async {
    final response = await _apiClient.get(ApiConfig.cart);
    return ApiResponse.fromJson(
      response.data,
      (json) => CartSummary.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<CartItem>> addToCart({
    required int productId,
    required int quantity,
    required String deliveryOption,
  }) async {
    final response = await _apiClient.post(
      ApiConfig.cart,
      data: {
        'product_id': productId,
        'quantity': quantity,
        'delivery_option': deliveryOption,
      },
    );

    return ApiResponse.fromJson(
      response.data,
      (json) => CartItem.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<CartItem>> updateCartItem(
    int id, {
    required int quantity,
    String? deliveryOption,
  }) async {
    final data = <String, dynamic>{'quantity': quantity};
    if (deliveryOption != null) data['delivery_option'] = deliveryOption;

    final response = await _apiClient.put('${ApiConfig.cart}/$id', data: data);

    return ApiResponse.fromJson(
      response.data,
      (json) => CartItem.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> removeFromCart(int id) async {
    final response = await _apiClient.delete('${ApiConfig.cart}/$id');
    return ApiResponse.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> clearCart() async {
    final response = await _apiClient.delete(ApiConfig.cart);
    return ApiResponse.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );
  }
}
