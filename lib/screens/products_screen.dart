import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/product.dart';
import '../services/wallet_service.dart';
import '../widgets/product_card.dart';
import '../widgets/camp_search_bar.dart';
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        _buildSearchSection(),
        const SizedBox(height: 12),
        _buildCategoryChips(),
        const SizedBox(height: 12),
        Expanded(
          child: _filteredProducts.isEmpty
              ? _buildEmptyState()
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
          setState(() => _searchQuery = value);
        },
        onFilterTap: _showFilterSheet,
      ),
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
    final products = _filteredProducts;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${products.length} product${products.length == 1 ? '' : 's'} found',
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
        ],
      ),
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