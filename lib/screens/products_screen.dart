import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/product.dart';
import '../models/api/product.dart' as api_product;
import '../models/web_product.dart';
import '../services/wallet_service.dart';
import '../services/ai_search_service.dart';
import '../widgets/product_card.dart';
import '../widgets/camp_search_bar.dart';
import '../widgets/ai_suggestions_widget.dart';
import '../widgets/web_search_results_widget.dart';
import 'product_description_screen.dart';

class ProductsScreen extends StatefulWidget {
  final WalletService walletService;
  const ProductsScreen({super.key, required this.walletService});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  late TextEditingController _searchController;
  
  // AI Search
  final AiSearchService _aiSearchService = AiSearchService();
  AiSearchResult<api_product.Product>? _aiSearchResult;
  List<WebProduct>? _webResults;
  bool _isSearching = false;
  bool _showAiSuggestions = true;
  bool _showWebResults = true;

  final List<String> _categories = [
    'All',
    'Jewelry',
    'Accessories',
    'Bags',
    'Electronics',
    'Fashion',
    'Books',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Product> get _filteredProducts {
    var products = Product.sampleProducts;

    if (_selectedCategory != 'All') {
      products = products
          .where((p) => p.category == _selectedCategory)
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      products = products
          .where((p) =>
              p.name.toLowerCase().contains(query) ||
              p.seller.toLowerCase().contains(query) ||
              p.location.toLowerCase().contains(query))
          .toList();
    }

    return products;
  }

  // Results shown in the grid: API results when searching, sample data otherwise
  List<Product> get _displayedProducts {
    if (_searchQuery.isEmpty) return _filteredProducts;
    final result = _aiSearchResult;
    if (result == null) return _filteredProducts;

    var apiMatches = result.exactMatches.map(_toUiProduct).toList();
    if (_selectedCategory != 'All') {
      apiMatches = apiMatches
          .where((p) => p.category == _selectedCategory)
          .toList();
    }
    if (apiMatches.isNotEmpty) return apiMatches;
    return _filteredProducts;
  }

  Product _toUiProduct(api_product.Product product) {
    return Product(
      id: product.id.toString(),
      name: product.title,
      price: product.price,
      category: product.category?.name ?? 'Uncategorized',
      seller: product.seller?.fullName ?? 'Unknown',
      location: 'Campus',
      imageUrl: product.primaryImage ?? '',
      description: product.description,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        _buildSearchSection(),
        const SizedBox(height: 12),
        _buildCategoryChips(),
        const SizedBox(height: 12),
        if (_showWebResults && _webResults != null && _webResults!.isNotEmpty)
          _buildWebResults(),
        if (_showAiSuggestions && _aiSearchResult != null && _aiSearchResult!.aiSuggestions.isNotEmpty)
          _buildAiSuggestions(),
        Expanded(
          child: _displayedProducts.isEmpty
              ? ((_aiSearchResult != null && _aiSearchResult!.aiSuggestions.isNotEmpty) ||
                    (_showWebResults && _webResults != null && _webResults!.isNotEmpty)
                  ? const SizedBox.shrink()
                  : _buildEmptyState())
              : _buildProductGrid(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: CampSearchBar(
        controller: _searchController,
        hintText: 'Search products...',
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
            _aiSearchResult = null;
            _webResults = null;
            _showAiSuggestions = true;
            _showWebResults = true;
            _isSearching = false;
          });
        },
        onFilterTap: _showFilterSheet,
      ),
    );
  }

  Future<void> _performAiSearch([String? query]) async {
    final q = query ?? _searchQuery;
    if (q.isEmpty) {
      setState(() {
        _aiSearchResult = null;
        _showAiSuggestions = true;
        _isSearching = false;
      });
      return;
    }

    if (q.trim().length < 3) {
      setState(() {
        _aiSearchResult = null;
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    try {
      // Add minimum delay to ensure loading animation is visible
      await Future.delayed(const Duration(milliseconds: 400));

      final resultFuture = _aiSearchService.searchProducts(q);
      final webFuture = _aiSearchService.searchWebProducts(q);

      final result = await resultFuture;
      final webResults = await webFuture;

      if (!mounted || q != _searchQuery) return;

      print('AI Search Results: ${result.exactMatches.length} exact, ${result.aiSuggestions.length} AI suggestions, ${webResults.length} web results');

      setState(() {
        _aiSearchResult = result;
        _webResults = webResults;
        _isSearching = false;
        _showWebResults = true;
        _showAiSuggestions = true;
      });
    } catch (e) {
      if (!mounted || q != _searchQuery) return;
      print('Groq AI search error: $e');
      setState(() {
        _isSearching = false;
        _aiSearchResult = null;
        _webResults = null;
      });
    }
  }

  Widget _buildWebResults() {
    if (_webResults == null || _webResults!.isEmpty) {
      return const SizedBox.shrink();
    }

    return WebSearchResultsPanel(
      products: _webResults!,
      userQuery: _searchQuery,
      onDismiss: () => setState(() => _showWebResults = false),
      itemBuilder: (product) => WebProductCard(
        product: product,
        onTap: () => _openWebProduct(product),
      ),
    );
  }

  Future<void> _openWebProduct(WebProduct product) async {
    final uri = Uri.tryParse(product.url);
    if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) {
      return;
    }
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the retailer link.')),
      );
    }
  }

  Widget _buildAiSuggestions() {
    if (_aiSearchResult == null || _aiSearchResult!.aiSuggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return AiSuggestionsWidget<api_product.Product>(
      suggestions: _aiSearchResult!.aiSuggestions,
      userQuery: _searchQuery,
      onDismiss: () => setState(() => _showAiSuggestions = false),
      itemBuilder: (product) => ProductAiSuggestionCard(
        product: product,
        onTap: () {
          final uiProduct = _toUiProduct(product);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDescriptionScreen(
                product: uiProduct,
                walletService: widget.walletService,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAiSearchButton() {
    return ElevatedButton.icon(
      onPressed: () => _performAiSearch(),
      icon: const Icon(Icons.auto_awesome, size: 18),
      label: const Text('Search with AI'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildAiSearchingIndicator() {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
        SizedBox(width: 12),
        Text(
          'Searching with AI...',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = _selectedCategory == cat;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.outlineVariant,
                ),
              ),
              child: Text(
                cat,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : AppColors.onSurfaceVariant,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid() {
    final products = _displayedProducts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '${products.length} product${products.length == 1 ? '' : 's'} found',
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductCard(
                product: products[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDescriptionScreen(
                        product: products[index],
                        walletService: widget.walletService,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.outline.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No products found',
            style: AppTextStyles.headlineMd,
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search or category',
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          if (_searchQuery.trim().length >= 3) ...[
            const SizedBox(height: 24),
            _isSearching
                ? _buildAiSearchingIndicator()
                : _buildAiSearchButton(),
            if (_aiSearchResult != null &&
                _aiSearchResult!.exactMatches.isEmpty &&
                _aiSearchResult!.aiSuggestions.isEmpty &&
                (_webResults == null || _webResults!.isEmpty)) ...[
              const SizedBox(height: 12),
              Text(
                'No AI suggestions or web results found for this search.',
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Sort by', style: AppTextStyles.headlineMd),
              const SizedBox(height: 16),
              _FilterOption(
                title: 'Price: Low to High',
                icon: Icons.arrow_upward,
                onTap: () => Navigator.pop(context),
              ),
              _FilterOption(
                title: 'Price: High to Low',
                icon: Icons.arrow_downward,
                onTap: () => Navigator.pop(context),
              ),
              _FilterOption(
                title: 'Newest First',
                icon: Icons.access_time,
                onTap: () => Navigator.pop(context),
              ),
              _FilterOption(
                title: 'Most Popular',
                icon: Icons.trending_up,
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

class _FilterOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _FilterOption({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.onSurfaceVariant),
      title: Text(title, style: AppTextStyles.bodyLg),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.outline,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}