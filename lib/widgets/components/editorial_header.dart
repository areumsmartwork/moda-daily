import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// DESIGN.md "Editorial Header" 패턴.
///
/// ```
/// ARCHIVE SESSION          ← sessionLabel (all-caps, secondary)
/// Metadata Logs            ← title (headline, primary)
/// 14 items captured from … ← subtitle (body, on-surface-variant)
/// ```
class EditorialHeader extends StatelessWidget {
  final String sessionLabel;
  final String title;
  final String? subtitle;

  const EditorialHeader({
    super.key,
    required this.sessionLabel,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.s4,
        right: AppSpacing.s6,
        top: AppSpacing.s2,
        bottom: AppSpacing.s6,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Session label — all-caps data label
          Text(
            sessionLabel.toUpperCase(),
            style: AppTypography.dataLabel.copyWith(
              color: AppColors.secondary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: AppSpacing.s2),
          // Title
          Text(
            title,
            style: AppTypography.headlineLg.copyWith(
              color: AppColors.primary,
              letterSpacing: -0.5,
              height: 1.15,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.s1),
            Text(
              subtitle!,
              style: AppTypography.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
