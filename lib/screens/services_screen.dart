import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/service.dart';
import '../models/api/service.dart' as api_service;
import '../models/web_product.dart';
import '../services/ai_search_service.dart';
import '../widgets/service_card.dart';
import '../widgets/ai_suggestions_widget.dart';
import '../widgets/web_search_results_widget.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  String _searchQuery = '';
  String _selectedLocation = 'ALL';
  late TextEditingController _searchController;
  
  // AI Search
  final AiSearchService _aiSearchService = AiSearchService();
  AiSearchResult<api_service.Service>? _aiSearchResult;
  List<WebProduct>? _webResults;
  bool _isSearching = false;
  bool _showAiSuggestions = true;
  bool _showWebResults = true;

  final List<String> _locations = ['ALL', 'Main Campus', 'Student Village', 'Tech Hub'];

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

      final resultFuture = _aiSearchService.searchServices(q);
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

    return AiSuggestionsWidget<api_service.Service>(
      suggestions: _aiSearchResult!.aiSuggestions,
      userQuery: _searchQuery,
      onDismiss: () => setState(() => _showAiSuggestions = false),
      itemBuilder: (service) => ServiceAiSuggestionCard(
        service: service,
        onTap: () {
          _toUiService(service);
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

  List<Service> get _filteredServices {
    var services = Service.sampleServices;

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      services = services
          .where((s) =>
              s.title.toLowerCase().contains(query) ||
              s.providerName.toLowerCase().contains(query) ||
              s.category.toLowerCase().contains(query))
          .toList();
    }

    return services;
  }

  // Results shown in the list: API results when searching, sample data otherwise
  List<Service> get _displayedServices {
    if (_searchQuery.isEmpty) return _filteredServices;
    final result = _aiSearchResult;
    if (result == null) return _filteredServices;

    final apiMatches = result.exactMatches.map(_toUiService).toList();
    if (apiMatches.isNotEmpty) return apiMatches;
    return _filteredServices;
  }

  Service _toUiService(api_service.Service service) {
    return Service(
      id: service.id.toString(),
      title: service.title,
      description: service.description,
      providerName: service.provider?.fullName ?? 'Unknown',
      providerAvatarUrl: service.provider?.profileImage ?? '',
      rating: service.rating,
      reviewCount: service.totalRatings,
      price: service.price,
      category: service.category?.name ?? 'Uncategorized',
      imageUrl: service.portfolioImages?.first ?? '',
      isAvailable: service.availability == 'available',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroSection(),
                _buildFilterSection(),
                if (_showWebResults && _webResults != null && _webResults!.isNotEmpty)
                  _buildWebResults(),
                if (_showAiSuggestions && _aiSearchResult != null && _aiSearchResult!.aiSuggestions.isNotEmpty)
                  _buildAiSuggestions(),
                _buildServiceCount(),
                _buildServiceList(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            // Location selector
            GestureDetector(
              onTap: _showLocationPicker,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _selectedLocation,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: Colors.grey.shade500,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 1,
              height: 24,
              color: Colors.grey.shade300,
            ),
            const SizedBox(width: 4),
            // Search input
            Expanded(
              child: TextField(
                controller: _searchController,
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
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade400,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
            // Search button
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search,
                size: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Campus Services',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Connect with talented students offering professional services',
            style: AppTextStyles.bodyLg,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: GestureDetector(
        onTap: _showFilterSheet,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.tune,
                size: 20,
                color: AppColors.onSurface,
              ),
              SizedBox(width: 8),
              Text(
                'Filters',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCount() {
    final count = _displayedServices.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: RichText(
        text: TextSpan(
          text: 'Showing ',
          style: AppTextStyles.bodyMd.copyWith(
            color: AppColors.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
          children: [
            TextSpan(
              text: '$count',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            TextSpan(
              text: ' service${count == 1 ? '' : 's'}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceList() {
    final services = _displayedServices;

    if (services.isEmpty &&
        ((_aiSearchResult != null && _aiSearchResult!.aiSuggestions.isNotEmpty) ||
            (_showWebResults && _webResults != null && _webResults!.isNotEmpty))) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: services.isEmpty
          ? _buildEmptyState()
          : Column(
              children: services.map((service) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ServiceCard(service: service),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.outline.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'No services found',
              style: AppTextStyles.headlineMd,
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different search or location',
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
      ),
    );
  }

  void _showLocationPicker() {
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
              const Text('Select Location', style: AppTextStyles.headlineMd),
              const SizedBox(height: 16),
              ..._locations.map((loc) {
                final isSelected = _selectedLocation == loc;
                return ListTile(
                  leading: Icon(
                    Icons.location_on_outlined,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.onSurfaceVariant,
                  ),
                  title: Text(
                    loc,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.onSurface,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() => _selectedLocation = loc);
                    Navigator.pop(context);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
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
              const Text('Filter Services', style: AppTextStyles.headlineMd),
              const SizedBox(height: 16),
              const Text(
                'Category',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _FilterChip(label: 'All', isSelected: true, onTap: () {}),
                  _FilterChip(label: 'Writing', isSelected: false, onTap: () {}),
                  _FilterChip(
                      label: 'Photography', isSelected: false, onTap: () {}),
                  _FilterChip(label: 'Beauty', isSelected: false, onTap: () {}),
                  _FilterChip(label: 'Laundry', isSelected: false, onTap: () {}),
                  _FilterChip(label: 'Design', isSelected: false, onTap: () {}),
                  _FilterChip(label: 'Fashion', isSelected: false, onTap: () {}),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Availability',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              const Row(
                children: [
                  Icon(Icons.circle, size: 8, color: Color(0xFF065F46)),
                  SizedBox(width: 8),
                  Text(
                    'Available Now',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.onSurface,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.check_circle, color: AppColors.primary),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Apply Filters',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade200,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
