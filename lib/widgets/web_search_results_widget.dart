import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/web_product.dart';

class WebSearchResultsPanel extends StatelessWidget {
  final List<WebProduct> products;
  final String userQuery;
  final VoidCallback? onDismiss;
  final Widget Function(WebProduct product) itemBuilder;

  const WebSearchResultsPanel({
    super.key,
    required this.products,
    required this.userQuery,
    this.onDismiss,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.public, color: AppColors.tertiary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Found on the web for "$userQuery"',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
              if (onDismiss != null)
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: onDismiss,
                  color: AppColors.onSurfaceVariant,
                ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Real products from online retailers. Tap to open.',
            style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 340),
            child: SingleChildScrollView(
              child: Column(
                children: products.map((p) => itemBuilder(p)).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WebProductCard extends StatelessWidget {
  final WebProduct product;
  final VoidCallback onTap;

  const WebProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final price = product.price;
    final hasPrice = price != null &&
        price.isNotEmpty &&
        !price.toLowerCase().contains('n/a');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.tertiary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.shopping_bag_outlined, color: AppColors.tertiary),
        ),
        title: Text(
          product.title,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasPrice)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  product.price!,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.priceGreen,
                  ),
                ),
              ),
            if (product.source.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  product.source,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            if (product.description != null && product.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  product.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ),
        isThreeLine: true,
        trailing: const Icon(Icons.open_in_new, size: 18, color: AppColors.tertiary),
        onTap: onTap,
      ),
    );
  }
}
