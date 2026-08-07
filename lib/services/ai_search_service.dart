import '../config/ai_config.dart';
import '../models/api/product.dart';
import '../models/api/service.dart';
import 'products_api_service.dart';
import 'services_api_service.dart';
import 'groq_service.dart';

class AiSearchResult<T> {
  final List<T> exactMatches;
  final List<T> aiSuggestions;
  final bool usedAiFallback;

  AiSearchResult({
    required this.exactMatches,
    required this.aiSuggestions,
    required this.usedAiFallback,
  });

  List<T> get allResults => [...exactMatches, ...aiSuggestions];
}

class AiSearchService {
  final ProductsApiService _productsService = ProductsApiService();
  final ServicesApiService _servicesService = ServicesApiService();
  final GroqService _groqService = GroqService();

  /// Search products with AI fallback
  Future<AiSearchResult<Product>> searchProducts(String query) async {
    try {
      // First, try exact search using existing API
      final apiResponse = await _productsService.getProducts(search: query);
      final exactMatches = apiResponse.data ?? [];

      // If we have enough exact matches, return them without AI
      if (exactMatches.length >= AiConfig.minSearchResults) {
        return AiSearchResult(
          exactMatches: exactMatches,
          aiSuggestions: [],
          usedAiFallback: false,
        );
      }

      // If not enough results, try AI suggestions
      if (AiConfig.isConfigured) {
        try {
          // Get all available products for AI context
          final allProductsResponse = await _productsService.getProducts(
            perPage: 100,
          );
          final allProducts = allProductsResponse.data ?? [];

          // Get AI suggestions
          final suggestedTitles = await _groqService.getProductSuggestions(
            userQuery: query,
            availableProducts: allProducts,
          );

          // Find the actual product objects for suggested titles
          final suggestedSet = suggestedTitles.map(_normalizeTitle).toSet();
          final suggestions = allProducts.where((product) =>
            suggestedSet.contains(_normalizeTitle(product.title))
          ).toList();

          // Remove duplicates from exact matches
          final exactMatchIds = exactMatches.map((p) => p.id).toSet();
          final uniqueSuggestions = suggestions.where((s) => 
            !exactMatchIds.contains(s.id)
          ).toList();

          return AiSearchResult(
            exactMatches: exactMatches,
            aiSuggestions: uniqueSuggestions,
            usedAiFallback: true,
          );
        } catch (e) {
          print('AI fallback failed: $e');
          // Return just the exact matches if AI fails
          return AiSearchResult(
            exactMatches: exactMatches,
            aiSuggestions: [],
            usedAiFallback: false,
          );
        }
      }

      // AI not configured, return exact matches only
      return AiSearchResult(
        exactMatches: exactMatches,
        aiSuggestions: [],
        usedAiFallback: false,
      );
    } catch (e) {
      print('Product search failed: $e');
      return AiSearchResult(
        exactMatches: [],
        aiSuggestions: [],
        usedAiFallback: false,
      );
    }
  }

  /// Search services with AI fallback
  Future<AiSearchResult<Service>> searchServices(String query) async {
    try {
      // First, try exact search using existing API
      final apiResponse = await _servicesService.getServices(perPage: 100);
      final allServices = apiResponse.data ?? [];

      // Filter by search query (basic implementation)
      final queryLower = query.toLowerCase();
      final exactMatches = allServices.where((service) =>
        service.title.toLowerCase().contains(queryLower) ||
        service.description.toLowerCase().contains(queryLower) ||
        (service.category?.name ?? '').toLowerCase().contains(queryLower)
      ).toList();

      // If we have enough exact matches, return them without AI
      if (exactMatches.length >= AiConfig.minSearchResults) {
        return AiSearchResult(
          exactMatches: exactMatches,
          aiSuggestions: [],
          usedAiFallback: false,
        );
      }

      // If not enough results, try AI suggestions
      if (AiConfig.isConfigured) {
        try {
          // Get AI suggestions
          final suggestedTitles = await _groqService.getServiceSuggestions(
            userQuery: query,
            availableServices: allServices,
          );

          // Find the actual service objects for suggested titles
          final suggestedSet = suggestedTitles.map(_normalizeTitle).toSet();
          final suggestions = allServices.where((service) =>
            suggestedSet.contains(_normalizeTitle(service.title))
          ).toList();

          // Remove duplicates from exact matches
          final exactMatchIds = exactMatches.map((s) => s.id).toSet();
          final uniqueSuggestions = suggestions.where((s) => 
            !exactMatchIds.contains(s.id)
          ).toList();

          return AiSearchResult(
            exactMatches: exactMatches,
            aiSuggestions: uniqueSuggestions,
            usedAiFallback: true,
          );
        } catch (e) {
          print('AI fallback failed: $e');
          // Return just the exact matches if AI fails
          return AiSearchResult(
            exactMatches: exactMatches,
            aiSuggestions: [],
            usedAiFallback: false,
          );
        }
      }

      // AI not configured, return exact matches only
      return AiSearchResult(
        exactMatches: exactMatches,
        aiSuggestions: [],
        usedAiFallback: false,
      );
    } catch (e) {
      print('Service search failed: $e');
      return AiSearchResult(
        exactMatches: [],
        aiSuggestions: [],
        usedAiFallback: false,
      );
    }
  }

  /// Check if AI search is available
  bool get isAiAvailable => AiConfig.isConfigured;

  String _normalizeTitle(String title) => title.toLowerCase().trim();
}