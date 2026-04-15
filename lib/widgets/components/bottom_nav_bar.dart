import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// 앱 하단 네비게이션 탭 목록.
enum NavTab {
  photos,
  metadata,
  map,
  export,
}

extension NavTabExt on NavTab {
  String get label => switch (this) {
        NavTab.photos => 'Photos',
        NavTab.metadata => 'Metadata',
        NavTab.map => 'Map',
        NavTab.export => 'Export',
      };

  IconData get icon => switch (this) {
        NavTab.photos => Icons.photo_library_outlined,
        NavTab.metadata => Icons.list_alt_outlined,
        NavTab.map => Icons.map_outlined,
        NavTab.export => Icons.movie_filter_outlined,
      };

  IconData get activeIcon => switch (this) {
        NavTab.photos => Icons.photo_library,
        NavTab.metadata => Icons.list_alt,
        NavTab.map => Icons.map,
        NavTab.export => Icons.movie_filter,
      };
}

/// DESIGN.md "Media Controls → glassmorphic bar" 패턴의 하단 내비게이션.
///
/// - `BackdropFilter(blur: 20)` + surface 70% fill
/// - 상단 모서리 `radiusLg` (24px) 라운드
/// - 활성 탭: `secondary` (#00BFA5) 색상 + 아이콘 fill
/// - 비활성 탭: `onSurfaceVariant` 60% opacity
class AppBottomNavBar extends StatelessWidget {
  final NavTab currentTab;
  final ValueChanged<NavTab> onTabSelected;

  const AppBottomNavBar({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppSpacing.radiusLg),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: AppSpacing.glassBlur,
          sigmaY: AppSpacing.glassBlur,
        ),
        child: Container(
          height: 72 + MediaQuery.of(context).padding.bottom,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          decoration: const BoxDecoration(
            color: AppSpacing.glassFill,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowPrimary,
                blurRadius: 20,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: NavTab.values
                .map((tab) => _NavItem(
                      tab: tab,
                      isActive: tab == currentTab,
                      onTap: () => onTabSelected(tab),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final NavTab tab;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.tab,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? AppColors.secondary
        : AppColors.onSurfaceVariant.withValues(alpha: 0.5);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedScale(
          scale: isActive ? 1.1 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isActive ? tab.activeIcon : tab.icon,
                color: color,
                size: 24,
              ),
              const SizedBox(height: 2),
              Text(
                tab.label.toUpperCase(),
                style: AppTypography.dataLabel.copyWith(
                  color: color,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
