import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../models/service.dart';
import '../services/wallet_service.dart';
import '../widgets/app_header.dart';

class AddServiceScreen extends StatefulWidget {
  final Service? service;
  final WalletService walletService;

  const AddServiceScreen({
    super.key,
    this.service,
    required this.walletService,
  });

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _providerNameController;
  late TextEditingController _providerAvatarUrlController;
  late TextEditingController _imageUrlController;
  String _selectedCategory = 'Writing Services';
  bool _isAvailable = true;

  final List<String> _categories = [
    'Writing Services',
    'Photography',
    'Beauty',
    'Laundry',
    'Design',
    'Fashion',
    'Tutoring',
    'Other',
  ];

  bool get _isEditing => widget.service != null;

  @override
  void initState() {
    super.initState();
    final s = widget.service;
    _titleController = TextEditingController(text: s?.title ?? '');
    _descriptionController = TextEditingController(text: s?.description ?? '');
    _priceController = TextEditingController(
      text: s != null ? s.price.toStringAsFixed(0) : '',
    );
    _providerNameController = TextEditingController(text: s?.providerName ?? '');
    _providerAvatarUrlController = TextEditingController(text: s?.providerAvatarUrl ?? '');
    _imageUrlController = TextEditingController(text: s?.imageUrl ?? '');
    if (s?.category != null && _categories.contains(s!.category)) {
      _selectedCategory = s.category;
    }
    _isAvailable = s?.isAvailable ?? true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _providerNameController.dispose();
    _providerAvatarUrlController.dispose();
    _imageUrlController.dispose();
    super.dispose();
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
              title: _isEditing ? 'Edit Service' : 'New Service',
              walletService: widget.walletService,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImagePreview(),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: _titleController,
                        label: 'Service Title',
                        hint: 'e.g. Math Tutoring',
                        validator: (v) =>
                            v!.isEmpty ? 'Service title is required' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _descriptionController,
                        label: 'Description',
                        hint: 'Describe your service...',
                        maxLines: 3,
                        validator: (v) =>
                            v!.isEmpty ? 'Description is required' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildCategoryDropdown(),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _priceController,
                        label: 'Price (₦)',
                        hint: 'e.g. 5000',
                        keyboardType: TextInputType.number,
                        validator: (v) =>
                            v!.isEmpty ? 'Price is required' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _providerNameController,
                        label: 'Provider Name',
                        hint: 'Your name or business name',
                        validator: (v) =>
                            v!.isEmpty ? 'Provider name is required' : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _providerAvatarUrlController,
                        label: 'Provider Avatar URL',
                        hint: 'https://example.com/avatar.jpg',
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _imageUrlController,
                        label: 'Service Image URL',
                        hint: 'https://example.com/service.jpg',
                      ),
                      const SizedBox(height: 16),
                      _buildAvailabilityToggle(),
                      const SizedBox(height: 24),
                      _buildSubmitButton(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: _imageUrlController.text.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                _imageUrlController.text,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
              ),
            )
          : _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.miscellaneous_services,
            size: 48,
            color: AppColors.outline.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 8),
          Text(
            'Service Image',
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelLg.copyWith(
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: (value) => setState(() {}),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            filled: true,
            fillColor: AppColors.surfaceContainerLowest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.error),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
              items: _categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedCategory = value!);
              },
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.onSurface,
              ),
              dropdownColor: AppColors.surfaceContainerLowest,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvailabilityToggle() {
    return Row(
      children: [
        Switch(
          value: _isAvailable,
          onChanged: (value) => setState(() => _isAvailable = value),
          activeThumbColor: AppColors.primary,
        ),
        const SizedBox(width: 12),
        const Text(
          'Available for booking',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          _isEditing ? 'Update Service' : 'Publish Service',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final service = Service(
      id: _isEditing ? widget.service!.id : DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory,
      price: double.tryParse(_priceController.text) ?? 0,
      providerName: _providerNameController.text.trim(),
      providerAvatarUrl: _providerAvatarUrlController.text.trim(),
      rating: _isEditing ? widget.service!.rating : 0.0,
      reviewCount: _isEditing ? widget.service!.reviewCount : 0,
      imageUrl: _imageUrlController.text.trim(),
      isAvailable: _isAvailable,
    );

    Navigator.pop(context, service);
  }
}