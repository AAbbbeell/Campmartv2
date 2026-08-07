import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/order.dart';
import '../widgets/app_header.dart';
import '../services/wallet_service.dart';
import 'delivery_tracking_screen.dart';

class PurchasesScreen extends StatefulWidget {
  final WalletService walletService;
  const PurchasesScreen({super.key, required this.walletService});

  @override
  State<PurchasesScreen> createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> {
  List<Order> _orders = [];
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() {
    setState(() {
      _orders = Order.getSampleOrders();
    });
  }

  List<Order> get _filteredOrders {
    if (_selectedFilter == 'All') return _orders;
    
    return _orders.where((order) {
      switch (_selectedFilter) {
        case 'In Progress':
          return order.status == OrderStatus.orderConfirmed ||
                 order.status == OrderStatus.pickedUp ||
                 order.status == OrderStatus.inTransit ||
                 order.status == OrderStatus.nearby;
        case 'Delivered':
          return order.status == OrderStatus.delivered;
        case 'Cancelled':
          return order.status == OrderStatus.cancelled;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              showBackButton: true,
              title: 'My Orders',
              walletService: widget.walletService,
            ),
            const SizedBox(height: 16),
            _buildFilterChips(),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredOrders.isEmpty
                  ? _buildEmptyState()
                  : _buildOrdersList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'In Progress', 'Delivered', 'Cancelled'];
    
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = filter),
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
                filter,
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

  Widget _buildOrdersList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredOrders.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final order = _filteredOrders[index];
        return _OrderCard(
          order: order,
          onTap: () {
            if (order.status != OrderStatus.delivered && 
                order.status != OrderStatus.cancelled) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DeliveryTrackingScreen(
                    deliveryLocation: order.deliveryLocation,
                    walletService: widget.walletService,
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 64,
            color: AppColors.outline.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No orders found',
            style: AppTextStyles.headlineMd,
          ),
          const SizedBox(height: 8),
          Text(
            'Start shopping to see your orders here',
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;

  const _OrderCard({
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.surfaceContainer),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.surfaceContainer,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: order.imageUrl != null
                        ? Image.network(
                            order.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => 
                              const Icon(Icons.image_not_supported),
                          )
                        : const Icon(Icons.shopping_bag),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.productName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.seller,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.formattedPrice,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getStatusIcon(),
                        size: 14,
                        color: _getStatusColor(),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        order.statusText,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  _formatDate(order.orderDate),
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 14,
                  color: AppColors.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    order.deliveryLocation,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
                if (order.status != OrderStatus.delivered && 
                    order.status != OrderStatus.cancelled)
                  const Text(
                    'Track Order →',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (order.status) {
      case OrderStatus.orderConfirmed:
        return AppColors.primary;
      case OrderStatus.pickedUp:
        return AppColors.primary;
      case OrderStatus.inTransit:
        return AppColors.brandGreen;
      case OrderStatus.nearby:
        return Colors.orange;
      case OrderStatus.delivered:
        return AppColors.brandGreen;
      case OrderStatus.cancelled:
        return AppColors.error;
    }
  }

  IconData _getStatusIcon() {
    switch (order.status) {
      case OrderStatus.orderConfirmed:
        return Icons.check_circle;
      case OrderStatus.pickedUp:
        return Icons.inventory_2;
      case OrderStatus.inTransit:
        return Icons.local_shipping;
      case OrderStatus.nearby:
        return Icons.near_me;
      case OrderStatus.delivered:
        return Icons.done_all;
      case OrderStatus.cancelled:
        return Icons.cancel;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}