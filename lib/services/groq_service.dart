import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../config/ai_config.dart';
import '../models/api/product.dart';
import '../models/api/service.dart';
import '../models/web_product.dart';

class GroqService {
  final Dio _dio = Dio();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    if (!AiConfig.isConfigured) {
      throw Exception('Groq API key not configured. Please set GROQ_API_KEY environment variable.');
    }
    
    _dio.options.headers['Authorization'] = 'Bearer ${AiConfig.groqApiKey}';
    _dio.options.headers['Content-Type'] = 'application/json';
    _isInitialized = true;
  }

  /// Generate product suggestions based on user query when no exact matches found
  Future<List<String>> getProductSuggestions({
    required String userQuery,
    required List<Product> availableProducts,
  }) async {
    await initialize();

    final productContext = availableProducts.take(50).map((p) =>
      '- ${p.title} (${p.category?.name ?? 'Uncategorized'}): ${_truncate(p.description, 80)}'
    ).join('\n');

    final systemPrompt = '''You are a helpful product recommendation assistant for a campus marketplace called Campmart. 
When users search for products that aren't available, suggest similar alternatives from the available products.

Guidelines:
- Suggest up to ${AiConfig.maxAiSuggestions} products
- Focus on relevance to the user's query
- Consider category, usage, and price range
- Return ONLY product titles, one per line
- If no relevant products exist, return "NO_SUGGESTIONS"''';

    final userPrompt = '''User is looking for: "$userQuery"

Available products:
$productContext

Suggest the most relevant products from the available list:''';

    try {
      final response = await _dio.post(
        'https://api.groq.com/openai/v1/chat/completions',
        data: {
          'model': AiConfig.groqModel,
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': userPrompt},
          ],
          'max_tokens': AiConfig.maxTokens,
          'temperature': AiConfig.temperature,
        },
      );

      final content = response.data['choices'][0]['message']['content'];
      return _parseSuggestions(content, availableProducts);
    } catch (e) {
      print('Groq API error: $e');
      return [];
    }
  }

  /// Generate service suggestions based on user query
  Future<List<String>> getServiceSuggestions({
    required String userQuery,
    required List<Service> availableServices,
  }) async {
    await initialize();
    
    final serviceContext = availableServices.take(50).map((s) =>
      '- ${s.title} (${s.category?.name ?? 'Uncategorized'}): ${_truncate(s.description, 80)}'
    ).join('\n');

    final systemPrompt = '''You are a helpful service recommendation assistant for a campus marketplace called Campmart. 
When users search for services that aren't available, suggest similar alternatives from the available services.

Guidelines:
- Suggest up to ${AiConfig.maxAiSuggestions} services
- Focus on relevance to the user's query
- Consider category, skills, and pricing
- Return ONLY service titles, one per line
- If no relevant services exist, return "NO_SUGGESTIONS"''';

    final userPrompt = '''User is looking for: "$userQuery"

Available services:
$serviceContext

Suggest the most relevant services from the available list:''';

    try {
      final response = await _dio.post(
        'https://api.groq.com/openai/v1/chat/completions',
        data: {
          'model': AiConfig.groqModel,
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': userPrompt},
          ],
          'max_tokens': AiConfig.maxTokens,
          'temperature': AiConfig.temperature,
        },
      );

      final content = response.data['choices'][0]['message']['content'];
      return _parseSuggestions(content, availableServices);
    } catch (e) {
      print('Groq API error: $e');
      return [];
    }
  }

  /// Search the internet for real products matching the query using Groq's
  /// built-in web search (groq/compound-mini). Returns products with prices,
  /// retailer sources and direct buy URLs.
  Future<List<WebProduct>> searchWebProducts(String query) async {
    await initialize();

    final systemPrompt = '''You are a product search assistant for a campus marketplace called Campmart.
Use web search to find REAL products available to buy right now that match the user's query.
Guidelines:
- Return up to ${AiConfig.webSearchMaxProducts} products
- Prefer well-known retailers (Amazon, Best Buy, Walmart, eBay, etc.)
- Only use information found by your web search. Never invent products, prices or URLs.
- Return ONLY a JSON object with this exact structure:
{"products":[{"title":"Product name","price":"\$100.00 or N/A","source":"bestbuy.com","url":"https://...","description":"one short sentence"}]}
- If nothing relevant is found, return {"products":[]}''';

    final userPrompt = 'Find products to buy for: "$query"';

    try {
      final response = await _dio.post(
        'https://api.groq.com/openai/v1/chat/completions',
        data: {
          'model': AiConfig.groqWebSearchModel,
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': userPrompt},
          ],
          'response_format': {'type': 'json_object'},
        },
      );

      final content = response.data['choices'][0]['message']['content'] ?? '';
      final cleaned = content.trim().replaceFirst(
        RegExp(r'^```[a-z]*\s*', caseSensitive: false),
        '',
      ).replaceFirst(RegExp(r'```\s*$'), '');
      final decoded = jsonDecode(cleaned);
      final items = decoded['products'] as List<dynamic>? ?? [];

      return items
          .whereType<Map<String, dynamic>>()
          .map(WebProduct.fromJson)
          .where((p) => p.title.isNotEmpty && p.url.isNotEmpty)
          .toList();
    } catch (e) {
      print('Groq web search error: $e');
      return [];
    }
  }

  List<String> _parseSuggestions(String response, List<dynamic> availableItems) {
    if (response.contains('NO_SUGGESTIONS')) {
      return [];
    }

    final titles = <String>[];
    for (final item in availableItems) {
      final title = item is Product ? item.title : (item as Service).title;
      titles.add(title);
    }

    final titleMap = <String, String>{};
    for (final title in titles) {
      titleMap[_normalize(title)] = title;
    }

    final suggestions = <String>[];
    for (final line in response.split('\n')) {
      final cleaned = _cleanSuggestionLine(line);
      if (cleaned.isEmpty) continue;

      var actual = titleMap[_normalize(cleaned)];
      if (actual == null) {
        final normalizedLine = _normalize(cleaned);
        String? best;
        for (final title in titles) {
          final normalizedTitle = _normalize(title);
          if (normalizedTitle.isNotEmpty &&
              normalizedLine.contains(normalizedTitle)) {
            if (best == null ||
                normalizedTitle.length > _normalize(best).length) {
              best = title;
            }
          }
        }
        actual = best;
      }

      if (actual != null && !suggestions.contains(actual)) {
        suggestions.add(actual);
      }
    }
    return suggestions;
  }

  String _cleanSuggestionLine(String line) {
    var text = line.trim();
    text = text.replaceFirst(RegExp(r'^[-–—•*]+\s*'), '');
    text = text.replaceFirst(RegExp(r'^\d+[.)]\s*'), '');
    while (text.isNotEmpty && (text.startsWith('"') || text.startsWith("'"))) {
      text = text.substring(1);
    }
    while (text.isNotEmpty && (text.endsWith('"') || text.endsWith("'"))) {
      text = text.substring(0, text.length - 1);
    }
    text = text.replaceFirst(RegExp(r'\s*\([^)]*\)\s*$'), '');
    text = text.replaceFirst(RegExp(r'[.:;]+$'), '');
    return text.trim();
  }

  String _normalize(String text) {
    return text.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  String _truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Check if Groq service is available
  bool get isAvailable => AiConfig.isConfigured;
}