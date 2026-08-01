import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../services/wallet_service.dart';

class EditProfileScreen extends StatefulWidget {
  final WalletService walletService;
  const EditProfileScreen({super.key, required this.walletService});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController(text: 'Jordan Smith');
  final _displayNameController = TextEditingController(text: 'JSeller2024');
  final _emailController = TextEditingController(text: 'j.smith@university.edu');
  final _phoneController = TextEditingController(text: '+1 (555) 123-4567');
  final _bioController = TextEditingController(
    text: 'Senior CS student. Selling tech gear and textbooks from previous semesters. Quick responses!',
  );

  final List<String> _availableInterests = [
    'Arts',
    'Sports',
    'Gadgets',
    'Textbooks',
    'Fashion',
    'Furniture',
    'Events',
  ];

  final Set<String> _selectedInterests = {'Arts', 'Gadgets'};

  @override
  void dispose() {
    _fullNameController.dispose();
    _displayNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _toggleInterest(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        _selectedInterests.add(interest);
      }
    });
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement save logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: AppColors.primary,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      _buildProfilePictureSection(),
                      const SizedBox(height: 24),
                      _buildFormFields(),
                      const SizedBox(height: 24),
                      _buildInterestsSection(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.primary,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 16),
          const Text(
            'Edit Profile',
            style: AppTextStyles.headlineMd,
          ),
          const Spacer(),
          const SizedBox(width: 40), // Spacer for symmetry
        ],
      ),
    );
  }

  Widget _buildProfilePictureSection() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuB8CJ3cMlB7Ldb2z6k75PWv3kxe-UMKdEojf2tgDQhE4tk29mtD25iZqOFL0N5xFVE8goffE2NhLCAQNqNznrsPwCBl-IOOPPykfTFf7MDrMgZ7PAmM-KXP1s1TdvezvU4ZSdqUXl-3SABuILZSv_BBEuWf-2TZ7ZL30vqpcAZMMBES2UTuEJ-sqmv2KlrAiWLEKA7sLgIbA4-8MwSBkGrvI8WYiv6mD2gwho2EjKaXTO8nw2_0HfiSkw',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.surfaceContainer,
                    child: const Icon(
                      Icons.person,
                      size: 64,
                      color: AppColors.outline,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  // TODO: Implement image picker
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.photo_camera,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Profile visibility: Public',
          style: AppTextStyles.labelSm.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            label: 'Full Name',
            controller: _fullNameController,
            hintText: 'Enter your full name',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Full name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Display Name',
            controller: _displayNameController,
            hintText: 'Choose a public username',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Display name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildReadOnlyField(
            label: 'University Email',
            controller: _emailController,
            icon: Icons.lock,
            hint: 'University emails cannot be changed for security.',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Phone Number',
            controller: _phoneController,
            hintText: '+1 (000) 000-0000',
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Phone number is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextArea(
            label: 'Bio',
            controller: _bioController,
            hintText: 'Tell us a bit about yourself or what you\'re selling...',
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
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
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: AppTextStyles.bodyMd.copyWith(
            color: AppColors.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            filled: true,
            fillColor: AppColors.surfaceBright,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.error),
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

  Widget _buildReadOnlyField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
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
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          readOnly: true,
          style: AppTextStyles.bodyMd.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surfaceContainerLow,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.outlineVariant),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.outlineVariant),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            suffixIcon: Icon(
              icon,
              color: AppColors.outline,
              size: 20,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          hint,
          style: AppTextStyles.labelSm.copyWith(
            color: AppColors.outline,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildTextArea({
    required String label,
    required TextEditingController controller,
    required String hintText,
    int maxLines = 3,
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
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: AppTextStyles.bodyMd.copyWith(
            color: AppColors.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            filled: true,
            fillColor: AppColors.surfaceBright,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary, width: 1),
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

  Widget _buildInterestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Buying & Selling Interests',
          style: AppTextStyles.labelLg.copyWith(
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableInterests.map((interest) {
            final isSelected = _selectedInterests.contains(interest);
            return GestureDetector(
              onTap: () => _toggleInterest(interest),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.secondaryContainer
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.outlineVariant,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected)
                      const Icon(
                        Icons.check,
                        size: 18,
                        color: AppColors.onSecondaryContainer,
                      ),
                    if (isSelected) const SizedBox(width: 4),
                    Text(
                      interest,
                      style: AppTextStyles.labelSm.copyWith(
                        color: isSelected
                            ? AppColors.onSecondaryContainer
                            : AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        border: Border(
          top: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _saveChanges,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 4,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.save, size: 20),
              SizedBox(width: 8),
              Text(
                'Save Changes',
                style: AppTextStyles.labelLg,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
