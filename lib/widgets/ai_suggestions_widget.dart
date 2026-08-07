import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/api/product.dart';
import '../models/api/service.dart';

class AiSuggestionsWidget<T> extends StatelessWidget {
  final List<T> suggestions;
  final String userQuery;
  final VoidCallback? onDismiss;
  final Widget Function(T item) itemBuilder;

  const AiSuggestionsWidget({
    super.key,
    required this.suggestions,
    required this.userQuery,
    this.onDismiss,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'AI Suggestions for "$userQuery"',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
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
          const SizedBox(height: 8),
          const Text(
            'No exact matches found. Here are some similar items:',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          ...suggestions.map((item) => itemBuilder(item)),
        ],
      ),
    );
  }
}

class ProductAiSuggestionCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductAiSuggestionCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: product.primaryImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.primaryImage!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => 
                    const Icon(Icons.image_not_supported),
                ),
              )
            : const Icon(Icons.shopping_bag, color: AppColors.primary),
        title: Text(
          product.title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          '\$${product.price.toStringAsFixed(2)} • ${product.category?.name ?? 'Uncategorized'}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

class ServiceAiSuggestionCard extends StatelessWidget {
  final Service service;
  final VoidCallback onTap;

  const ServiceAiSuggestionCard({
    super.key,
    required this.service,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: service.provider?.profileImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  service.provider!.profileImage!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => 
                    const Icon(Icons.person),
                ),
              )
            : const Icon(Icons.miscellaneous_services, color: AppColors.primary),
        title: Text(
          service.title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          '\$${service.price.toStringAsFixed(2)} • ${service.provider?.fullName ?? 'Unknown'}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}