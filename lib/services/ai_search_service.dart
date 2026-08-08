import '../config/ai_config.dart';
import '../models/api/category.dart';
import '../models/api/product.dart';
import '../models/api/service.dart';
import '../models/product.dart' as ui_product;
import '../models/service.dart' as ui_service;
import '../models/web_product.dart';
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
    List<Product> exactMatches = [];
    List<Product> catalog = [];

    try {
      final apiResponse = await _productsService.getProducts(search: query);
      exactMatches = apiResponse.data ?? [];
      if (exactMatches.length >= AiConfig.minSearchResults) {
        return AiSearchResult(
          exactMatches: exactMatches,
          aiSuggestions: [],
          usedAiFallback: false,
        );
      }
    } catch (e) {
      print('Product API unavailable, using local catalog: $e');
    }

    try {
      final allProductsResponse = await _productsService.getProducts(
        perPage: 100,
      );
      catalog = allProductsResponse.data ?? [];
    } catch (e) {
      print('Product catalog API unavailable, using local catalog: $e');
    }

    if (catalog.isEmpty) {
      catalog = _sampleProductCatalog();
    }

    if (AiConfig.isConfigured && catalog.isNotEmpty) {
      try {
        final suggestedTitles = await _groqService.getProductSuggestions(
          userQuery: query,
          availableProducts: catalog,
        );

        final suggestedSet = suggestedTitles.map(_normalizeTitle).toSet();
        final suggestions = catalog.where((product) =>
          suggestedSet.contains(_normalizeTitle(product.title))
        ).toList();

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
      }
    }

    return AiSearchResult(
      exactMatches: exactMatches,
      aiSuggestions: [],
      usedAiFallback: false,
    );
  }

  /// Search services with AI fallback
  Future<AiSearchResult<Service>> searchServices(String query) async {
    List<Service> exactMatches = [];
    List<Service> catalog = [];

    try {
      final apiResponse = await _servicesService.getServices(perPage: 100);
      final allServices = apiResponse.data ?? [];

      final queryLower = query.toLowerCase();
      exactMatches = allServices.where((service) =>
        service.title.toLowerCase().contains(queryLower) ||
        service.description.toLowerCase().contains(queryLower) ||
        (service.category?.name ?? '').toLowerCase().contains(queryLower)
      ).toList();

      if (exactMatches.length >= AiConfig.minSearchResults) {
        return AiSearchResult(
          exactMatches: exactMatches,
          aiSuggestions: [],
          usedAiFallback: false,
        );
      }
    } catch (e) {
      print('Service API unavailable, using local catalog: $e');
    }

    try {
      final allServicesResponse = await _servicesService.getServices(
        perPage: 100,
      );
      catalog = allServicesResponse.data ?? [];
    } catch (e) {
      print('Service catalog API unavailable, using local catalog: $e');
    }

    if (catalog.isEmpty) {
      catalog = _sampleServiceCatalog();
    }

    if (AiConfig.isConfigured && catalog.isNotEmpty) {
      try {
        final suggestedTitles = await _groqService.getServiceSuggestions(
          userQuery: query,
          availableServices: catalog,
        );

        final suggestedSet = suggestedTitles.map(_normalizeTitle).toSet();
        final suggestions = catalog.where((service) =>
          suggestedSet.contains(_normalizeTitle(service.title))
        ).toList();

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
      }
    }

    return AiSearchResult(
      exactMatches: exactMatches,
      aiSuggestions: [],
      usedAiFallback: false,
    );
  }

  /// Search the internet for real products matching the query
  Future<List<WebProduct>> searchWebProducts(String query) async {
    if (!isAiAvailable) return [];
    return _groqService.searchWebProducts(query);
  }

  List<Product> _sampleProductCatalog() {
    return ui_product.Product.sampleProducts.asMap().entries.map((entry) {
      final index = entry.key;
      final p = entry.value;
      return Product(
        id: int.tryParse(p.id) ?? index + 1,
        title: p.name,
        slug: p.name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-'),
        description: p.description ?? '',
        price: p.price,
        conditionType: 'good',
        negotiable: false,
        availability: 'available',
        stockQuantity: p.stock,
        deliveryFee: 0,
        viewsCount: 0,
        bookmarksCount: 0,
        isBookmarked: false,
        createdAt: DateTime.now(),
        category: p.category != null
            ? Category(
                id: index + 1,
                name: p.category!,
                slug: p.category!.toLowerCase(),
                productCount: 0,
              )
            : null,
        seller: Seller(id: 0, fullName: p.seller, username: ''),
        primaryImage: p.imageUrl,
      );
    }).toList();
  }

  List<Service> _sampleServiceCatalog() {
    return ui_service.Service.sampleServices.asMap().entries.map((entry) {
      final index = entry.key;
      final s = entry.value;
      return Service(
        id: int.tryParse(s.id) ?? index + 1,
        title: s.title,
        slug: s.title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-'),
        description: s.description,
        shortDescription: null,
        pricingType: 'fixed',
        price: s.price,
        deliveryTime: null,
        availability: s.isAvailable ? 'available' : 'unavailable',
        rating: s.rating,
        totalRatings: s.reviewCount,
        totalOrders: 0,
        viewsCount: 0,
        bookmarksCount: 0,
        portfolioImages: s.imageUrl.isEmpty ? null : [s.imageUrl],
        skills: null,
        isFeatured: false,
        isBookmarked: false,
        category: Category(
          id: index + 1,
          name: s.category,
          slug: s.category.toLowerCase(),
          productCount: 0,
        ),
        provider: ServiceProvider(
          id: 0,
          fullName: s.providerName,
          username: '',
          rating: s.rating,
          profileImage: s.providerAvatarUrl.isEmpty ? null : s.providerAvatarUrl,
        ),
        createdAt: DateTime.now(),
      );
    }).toList();
  }

  /// Check if AI search is available
  bool get isAiAvailable => AiConfig.isConfigured;

  String _normalizeTitle(String title) => title.toLowerCase().trim();
}