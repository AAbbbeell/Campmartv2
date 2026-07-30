import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../services/wallet_service.dart';
import '../screens/my_cart_screen.dart';

const String _avatarUrl =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuC5zJSYSDijKSgzL8_FC28LrRRu2lzmP8lHW0uqdB8948RuBYtltgKXIm9usFsU3z1Va9qgJrjgJ4b_Nq-NlxxmbOgW6kuyYhTQw-rPjf4C6cQbLbimrWE4XofQjm8SfSy-xFucIm68GQbCHobgTAz_ZAet8jVRcCMx1Xb123zPfV-2DlHjsWGmiObbk3pm4C5RzMiRDTp8TUK6w_89aNqITy4fd3q72MFBbQ71IzBGdenqA9E_GPSA0DqA8ynnAcEeSYwMltR6Lo3N';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final String? title;
  final VoidCallback? onBackPressed;
  final VoidCallback? onCartPressed;
  final bool showAvatar;
  final bool transparent;
  final int cartItemCount;
  final WalletService walletService;

  const AppHeader({
    super.key,
    this.showBackButton = false,
    this.title,
    this.onBackPressed,
    this.onCartPressed,
    this.showAvatar = true,
    this.transparent = false,
    this.cartItemCount = 0,
    required this.walletService,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: transparent
            ? Colors.transparent
            : AppColors.surfaceContainerLowest,
        border: transparent
            ? null
            : const Border(
                bottom: BorderSide(
                  color: AppColors.outlineVariant,
                  width: 0.5,
                ),
              ),
      ),
      child: Row(
        children: [
          if (showBackButton)
            _buildBackButton(context)
          else
            _buildBrand(),
          if (title != null && !showBackButton) ...[
            const SizedBox(width: 12),
            Text(
              title!,
              style: AppTextStyles.headlineMd,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const Spacer(),
          if (showBackButton && title != null) ...[
            Expanded(
              child: Text(
                title!,
                style: AppTextStyles.headlineMd,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Spacer(),
          ],
          _buildCartButton(context),
          if (showAvatar) ...[
            const SizedBox(width: 4),
            _buildAvatar(),
          ],
        ],
      ),
    );
  }

  Widget _buildBrand() {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.shopping_bag_outlined,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'CampMart',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      onPressed: onBackPressed ?? () => Navigator.pop(context),
      icon: const Icon(
        Icons.arrow_back_ios,
        color: AppColors.onSurface,
        size: 20,
      ),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }

  Widget _buildCartButton(BuildContext context) {
    return GestureDetector(
      onTap: onCartPressed ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MyCartScreen(walletService: walletService),
              ),
            );
          },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.shopping_cart_outlined,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          if (cartItemCount > 0)
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  cartItemCount > 99 ? '99+' : '$cartItemCount',
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 36,
      height: 36,
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.outlineVariant, width: 2),
      ),
      child: ClipOval(
        child: Image.network(
          _avatarUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey.shade300,
            child: const Icon(Icons.person, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }
}
