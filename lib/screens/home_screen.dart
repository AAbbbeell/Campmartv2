import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/product.dart';
import '../models/vendor.dart';
import '../widgets/product_card.dart';
import '../widgets/vendor_card.dart';
import '../widgets/camp_search_bar.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/app_header.dart';
import 'products_screen.dart';
import 'services_screen.dart';
import 'sell_screen.dart';
import 'account_screen.dart';
import 'cart_screen.dart';
import 'my_cart_screen.dart';
import '../models/cart.dart';
import '../services/auth_service.dart';
import '../services/wallet_service.dart';

class HomeScreen extends StatefulWidget {
  final AuthService authService;
  final WalletService walletService;
  const HomeScreen({
    super.key,
    required this.authService,
    required this.walletService,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;
  final Cart _cart = Cart();

  @override
  void initState() {
    super.initState();
    _cart.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    _cart.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onCartChanged() {
    if (mounted) setState(() {});
  }

  void _onNavTap(int index) {
    setState(() => _currentNavIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              cartItemCount: _cart.totalQuantity,
              walletService: widget.walletService,
            ),
            Expanded(
              child: IndexedStack(
                index: _currentNavIndex,
                children: [
                  _HomeContent(
                    onSeeAllTap: () => setState(() => _currentNavIndex = 1),
                    walletService: widget.walletService,
                  ),
                  ProductsScreen(walletService: widget.walletService),
                  const ServicesScreen(),
                  AccountScreen(
                    authService: widget.authService,
                    walletService: widget.walletService,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
        cartItemCount: _cart.totalQuantity,
        onCartTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MyCartScreen(walletService: widget.walletService),
            ),
          );
        },
        onSellTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SellScreen(walletService: widget.walletService),
            ),
          );
        },
      ),
    );
  }
}

class _HomeContent extends StatefulWidget {
  final VoidCallback onSeeAllTap;
  final WalletService walletService;

  const _HomeContent({
    required this.onSeeAllTap,
    required this.walletService,
  });

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  int _currentBannerIndex = 0;
  final PageController _bannerController = PageController();

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildWelcomeSection(),
          const SizedBox(height: 16),
          _buildSearchBar(),
          const SizedBox(height: 24),
          _buildBannerSlider(),
          const SizedBox(height: 24),
          _buildRecentProducts(),
          const SizedBox(height: 24),
          _buildTopVendors(),
          const SizedBox(height: 24),
          _buildTrendingProducts(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good Afternoon Abel 👋',
            style: AppTextStyles.headlineLg,
          ),
          SizedBox(height: 4),
          Text(
            'What are we looking for today?',
            style: AppTextStyles.bodyMd,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: CampSearchBar(),
    );
  }

  Widget _buildBannerSlider() {
    return Column(
      children: [
        SizedBox(
          height: 176,
          child: PageView(
            controller: _bannerController,
            onPageChanged: (index) {
              setState(() => _currentBannerIndex = index);
            },
            children: const [
              _BannerCard(
                badge: 'LIMITED TIME',
                title: 'Free Delivery Today',
                subtitle: 'On all lunch orders above \$15 from local vendors.',
              ),
              _BannerCard(
                badge: 'NEW',
                title: 'Weekend Deals',
                subtitle: 'Up to 30% off on select items this weekend.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(2, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentBannerIndex == index
                    ? AppColors.primary
                    : AppColors.outlineVariant,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildRecentProducts() {
    final products = Product.sampleProducts;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent Products', style: AppTextStyles.headlineMd),
              TextButton(
                onPressed: widget.onSeeAllTap,
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
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
                      builder: (_) => CartScreen(
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

  Widget _buildTopVendors() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Top Vendors', style: AppTextStyles.headlineMd),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'View Rankings',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...Vendor.sampleVendors.take(2).map(
                (vendor) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: VendorCard(vendor: vendor),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildTrendingProducts() {
    final products = Product.sampleProducts;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Trending Products', style: AppTextStyles.headlineMd),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: products.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return SizedBox(
                width: 160,
                child: ProductCard(
                  product: products[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CartScreen(
                          product: products[index],
                          walletService: widget.walletService,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _BannerCard extends StatelessWidget {
  final String badge;
  final String title;
  final String subtitle;

  const _BannerCard({
    required this.badge,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 176,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.primary,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      AppColors.primary.withValues(alpha: 0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      badge,
                      style: AppTextStyles.labelSm.copyWith(
                        color: AppColors.onSecondaryContainer,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: AppTextStyles.headlineMd.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodyMd.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
