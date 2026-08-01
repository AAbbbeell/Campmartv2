import 'api_client.dart';
import '../models/api/message.dart';
import '../models/api/api_response.dart';
import '../config/api_config.dart';

class MessagesApiService {
  final ApiClient _apiClient = ApiClient();

  Future<PaginatedResponse<Conversation>> getConversations({
    int page = 1,
    int perPage = 20,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };

    final response = await _apiClient.get(
      ApiConfig.conversations,
      queryParameters: queryParams,
    );

    return PaginatedResponse.fromJson(
      response.data,
      (json) => Conversation.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<Conversation>> getConversation(int id) async {
    final response = await _apiClient.get('${ApiConfig.conversations}/$id');
    return ApiResponse.fromJson(
      response.data,
      (json) => Conversation.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<Conversation>> createConversation({
    required int userId,
    int? productId,
    int? serviceId,
  }) async {
    final data = <String, dynamic>{'user_id': userId};
    if (productId != null) data['product_id'] = productId;
    if (serviceId != null) data['service_id'] = serviceId;

    final response = await _apiClient.post(ApiConfig.conversations, data: data);

    return ApiResponse.fromJson(
      response.data,
      (json) => Conversation.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<PaginatedResponse<Message>> getMessages(
    int conversationId, {
    int page = 1,
    int perPage = 50,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };

    final response = await _apiClient.get(
      '${ApiConfig.conversations}/$conversationId/messages',
      queryParameters: queryParams,
    );

    return PaginatedResponse.fromJson(
      response.data,
      (json) => Message.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<Message>> sendMessage({
    required int conversationId,
    required String message,
    String? attachmentUrl,
  }) async {
    final data = <String, dynamic>{'message': message};
    if (attachmentUrl != null) data['attachment_url'] = attachmentUrl;

    final response = await _apiClient.post(
      '${ApiConfig.conversations}/$conversationId/messages',
      data: data,
    );

    return ApiResponse.fromJson(
      response.data,
      (json) => Message.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<Message>> markMessageAsRead(int conversationId, int messageId) async {
    final response = await _apiClient.post(
      '${ApiConfig.conversations}/$conversationId/messages/$messageId/read',
    );

    return ApiResponse.fromJson(
      response.data,
      (json) => Message.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> markConversationAsRead(int conversationId) async {
    final response = await _apiClient.post('${ApiConfig.conversations}/$conversationId/read');
    return ApiResponse.fromJson(
      response.data,
      (json) => json as Map<String, dynamic>,
    );
  }
}
