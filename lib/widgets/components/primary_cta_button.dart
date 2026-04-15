import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// DESIGN.md "Buttons → Primary" 스펙을 구현한 그라디언트 pill CTA 버튼.
///
/// - `primaryDark` → `primaryContainer` 그라디언트 (Deep Ink effect)
/// - `full` 라운드 (pill)
/// - 선택적 앞 아이콘
///
/// 사용 예:
/// ```dart
/// PrimaryCtaButton(
///   label: 'Generate Map Archive',
///   icon: Icons.map,
///   onPressed: () { … },
/// )
/// ```
class PrimaryCtaButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;

  /// 버튼 너비를 부모에 맞게 늘릴지 여부. 기본 true (floating bar 용).
  final bool expanded;

  const PrimaryCtaButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final child = _ButtonContent(label: label, icon: icon);

    return AnimatedScale(
      scale: onPressed != null ? 1.0 : 0.97,
      duration: const Duration(milliseconds: 150),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: AppSpacing.pillRadius,
          boxShadow: AppSpacing.floatingShadow,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: AppSpacing.pillRadius,
          child: InkWell(
            onTap: onPressed,
            borderRadius: AppSpacing.pillRadius,
            splashColor: Colors.white12,
            highlightColor: Colors.white10,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.s4,
                horizontal: AppSpacing.s8,
              ),
              child: expanded
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [child],
                    )
                  : child,
            ),
          ),
        ),
      ),
    );
  }
}

class _ButtonContent extends StatelessWidget {
  final String label;
  final IconData? icon;
  const _ButtonContent({required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: AppSpacing.s3),
        ],
        Text(
          label,
          style: AppTypography.titleSm.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
