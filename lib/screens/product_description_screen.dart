import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/product.dart';
import '../models/cart.dart';
import '../services/wallet_service.dart';
import '../widgets/app_header.dart';
import 'cart_screen.dart';

class ProductDescriptionScreen extends StatefulWidget {
  final Product product;
  final WalletService walletService;

  const ProductDescriptionScreen({
    super.key,
    required this.product,
    required this.walletService,
  });

  @override
  State<ProductDescriptionScreen> createState() =>
      _ProductDescriptionScreenState();
}

class _ProductDescriptionScreenState extends State<ProductDescriptionScreen> {
  final Cart _cart = Cart();

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              showBackButton: true,
              title: 'Product Details',
              walletService: widget.walletService,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildImage(product),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitleRow(product),
                          const SizedBox(height: 12),
                          _buildPriceStock(product),
                          const SizedBox(height: 16),
                          _buildSellerInfo(product),
                          if (product.description != null &&
                              product.description!.isNotEmpty) ...[
                            const SizedBox(height: 20),
                            _buildDescription(product),
                          ],
                          const SizedBox(height: 20),
                          _buildActionButtons(product),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(Product product) {
    return Container(
      width: double.infinity,
      height: 300,
      color: AppColors.surfaceContainerHigh,
      child: Image.network(
        product.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(
            Icons.image,
            color: AppColors.outline,
            size: 64,
          ),
        ),
      ),
    );
  }

  Widget _buildTitleRow(Product product) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            product.name,
            style: AppTextStyles.headlineMd,
          ),
        ),
        if (product.isVerified)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              size: 14,
              color: Colors.white,
            ),
          ),
      ],
    );
  }

  Widget _buildPriceStock(Product product) {
    return Row(
      children: [
        Text(
          product.formattedPrice,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.priceGreen,
          ),
        ),
        const Spacer(),
        if (product.stock > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              product.stock <= 5 ? 'Only ${product.stock} left' : 'In Stock',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: product.stock <= 5
                    ? AppColors.error
                    : AppColors.secondary,
              ),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.errorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Out of Stock',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSellerInfo(Product product) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Text(
              product.seller.isNotEmpty
                  ? product.seller[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.seller,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      product.location,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (product.category != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                product.category!,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDescription(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            product.description!,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(Product product) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              _cart.addItem(product);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.name} added to cart'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.shopping_cart_outlined, size: 18),
            label: const Text(
              'Add to Cart',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CartScreen(
                    product: product,
                    walletService: widget.walletService,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            icon: const Icon(Icons.shopping_bag_outlined, size: 18),
            label: const Text(
              'Buy Now',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }
}
