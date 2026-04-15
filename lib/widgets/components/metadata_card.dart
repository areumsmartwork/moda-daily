import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../models/photo_metadata.dart';

/// DESIGN.md "Cards & Lists" 패턴을 따르는 메타데이터 카드.
///
/// - 96×96 썸네일 + 카메라 정보 + GPS + 타임스탬프
/// - No-Line 원칙: 경계선 없음, shadow-only 분리
/// - `surface-container-lowest` 배경 위에 자연스럽게 pop
class MetadataCard extends StatelessWidget {
  final PhotoMetadata metadata;
  final AssetEntity? asset;

  const MetadataCard({
    super.key,
    required this.metadata,
    this.asset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: AppSpacing.cardShadow,
      ),
      padding: const EdgeInsets.all(AppSpacing.s4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Thumbnail ──────────────────────────────────────────
          _Thumbnail(asset: asset),
          const SizedBox(width: AppSpacing.s4),

          // ── Metadata ───────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: camera name + verified icon
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _DataLabel('Camera'),
                          const SizedBox(height: 2),
                          Text(
                            metadata.cameraInfo,
                            style: AppTypography.titleSm.copyWith(
                              color: AppColors.primary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s2),
                    const Icon(
                      Icons.verified_user_outlined,
                      size: 16,
                      color: AppColors.secondary,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s3),

                // Bottom row: GPS + Timestamp
                Row(
                  children: [
                    Expanded(
                      child: _MetaField(
                        label: 'GPS Coordinates',
                        value: _formatCoordinate(
                            metadata.latitude, metadata.longitude),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s4),
                    Expanded(
                      child: _MetaField(
                        label: 'Timestamp',
                        value: DateFormat('MMM d, HH:mm:ss')
                            .format(metadata.capturedAt),
                      ),
                    ),
                  ],
                ),

                // Optional: altitude row
                if (metadata.altitude != null) ...[
                  const SizedBox(height: AppSpacing.s2),
                  Row(
                    children: [
                      Expanded(
                        child: _MetaField(
                          label: 'Altitude',
                          value: metadata.altitudeText,
                        ),
                      ),
                      if (metadata.imageDirection != null)
                        Expanded(
                          child: _MetaField(
                            label: 'Heading',
                            value: metadata.directionText,
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatCoordinate(double lat, double lng) {
    final latDir = lat >= 0 ? 'N' : 'S';
    final lngDir = lng >= 0 ? 'E' : 'W';
    return '${lat.abs().toStringAsFixed(4)}° $latDir, '
        '${lng.abs().toStringAsFixed(4)}° $lngDir';
  }
}

// ── Thumbnail ─────────────────────────────────────────────────────────────────

class _Thumbnail extends StatelessWidget {
  final AssetEntity? asset;
  const _Thumbnail({this.asset});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: SizedBox(
        width: 88,
        height: 88,
        child: asset != null
            ? FutureBuilder<Uint8List?>(
                future: asset!.thumbnailDataWithSize(
                  const ThumbnailSize.square(176),
                ),
                builder: (_, snapshot) {
                  final data = snapshot.data;
                  if (data == null) return _Placeholder();
                  return Image.memory(data, fit: BoxFit.cover);
                },
              )
            : _Placeholder(),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.surfaceContainer,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          color: AppColors.onSurfaceVariant,
          size: 28,
        ),
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

/// All-caps data label (e.g., "GPS COORDINATES")
class _DataLabel extends StatelessWidget {
  final String text;
  const _DataLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: AppTypography.dataLabel.copyWith(
        fontSize: 9,
        letterSpacing: 1.0,
        color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
      ),
    );
  }
}

/// Label + value metadata field
class _MetaField extends StatelessWidget {
  final String label;
  final String value;
  const _MetaField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DataLabel(label),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.bodySm.copyWith(
            color: AppColors.onSurfaceVariant,
            fontWeight: FontWeight.w500,
            height: 1.3,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
