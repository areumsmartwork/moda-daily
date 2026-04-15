import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// DESIGN.md 스타일을 따르는 브랜드 TopAppBar.
///
/// - "TravelMap ArchiVer" 타이틀 (Plus Jakarta Sans, bold)
/// - 뒤로가기 버튼 (primary color)
/// - 선택적 trailing 위젯 (아바타, 액션 버튼 등)
/// - surface 배경 + 하단 gradient fade (경계선 대신)
///
/// [PreferredSizeWidget]을 구현하므로 `Scaffold.appBar`에 직접 사용 가능.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  /// null이면 뒤로가기 버튼 숨김 (최상위 화면용)
  final VoidCallback? onBack;

  /// AppBar 우측 위젯 (아바타, 아이콘 버튼 등)
  final Widget? trailing;

  const AppTopBar({
    super.key,
    this.onBack,
    this.trailing,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Container(
        height: preferredSize.height + MediaQuery.of(context).padding.top,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowPrimary,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s6),
          child: Row(
            children: [
              // Back button
              if (onBack != null) ...[
                _IconBtn(
                  icon: Icons.arrow_back,
                  onTap: onBack!,
                ),
                const SizedBox(width: AppSpacing.s4),
              ],

              // Brand title
              Expanded(
                child: Text(
                  'TravelMap ArchiVer',
                  style: AppTypography.titleLg.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ),

              // Trailing
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s1),
        child: Icon(icon, color: AppColors.primary, size: 24),
      ),
    );
  }
}

/// 원형 아바타 trailing 위젯 (AppTopBar.trailing으로 전달).
class AppBarAvatar extends StatelessWidget {
  final ImageProvider image;
  final VoidCallback? onTap;

  const AppBarAvatar({super.key, required this.image, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primaryContainer.withValues(alpha: 0.2),
            width: 2,
          ),
          image: DecorationImage(image: image, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
