import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/database/app_database.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// 저장된 영상 아카이브 1건을 표시하는 카드.
///
/// 썸네일 + 제목 + 날짜 + GPS 포인트 수 + 편집 이력 배지.
/// 로직 없음 — 탭/삭제/편집 콜백을 생성자로만 받는다.
class ArchiveCard extends StatelessWidget {
  final VideoArchive archive;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ArchiveCard({
    super.key,
    required this.archive,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          boxShadow: AppSpacing.cardShadow,
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 썸네일 ──────────────────────────────────────────────
            _Thumbnail(
              thumbnailPath: archive.thumbnailPath,
              durationSeconds: archive.durationSeconds,
              editCount: archive.editCount,
            ),

            // ── 메타데이터 ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(AppSpacing.s4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 제목
                  Text(
                    archive.title,
                    style: AppTypography.titleSm
                        .copyWith(color: AppColors.primary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.s2),

                  // 날짜 + GPS 개수
                  Row(
                    children: [
                      _MetaChip(
                        icon: Icons.calendar_today_outlined,
                        label: DateFormat('yy.MM.dd').format(archive.createdAt),
                      ),
                      const SizedBox(width: AppSpacing.s2),
                      _MetaChip(
                        icon: Icons.location_on_outlined,
                        label: '${archive.gpsPointCount}곳',
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s3),

                  // 액션 버튼
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (onEdit != null)
                        _ActionBtn(
                          icon: Icons.edit_outlined,
                          label: '편집',
                          onTap: onEdit!,
                        ),
                      if (onEdit != null && onDelete != null)
                        const SizedBox(width: AppSpacing.s2),
                      if (onDelete != null)
                        _ActionBtn(
                          icon: Icons.delete_outline,
                          label: '삭제',
                          onTap: onDelete!,
                          destructive: true,
                        ),
                    ],
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

// ── 썸네일 ─────────────────────────────────────────────────────────────────────

class _Thumbnail extends StatelessWidget {
  final String? thumbnailPath;
  final int durationSeconds;
  final int editCount;

  const _Thumbnail({
    this.thumbnailPath,
    required this.durationSeconds,
    required this.editCount,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 9 / 16 * 2.5, // 카드 내 가로형 프리뷰
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 썸네일 이미지 or placeholder
          _buildImage(),

          // 하단 그라디언트
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.primaryContainer.withValues(alpha: 0.6),
                  ],
                  stops: const [0.5, 1.0],
                ),
              ),
            ),
          ),

          // 재생 시간 배지 (우하단)
          Positioned(
            right: AppSpacing.s3,
            bottom: AppSpacing.s3,
            child: _Badge(
              label: _formatDuration(durationSeconds),
              color: Colors.black54,
            ),
          ),

          // 편집 횟수 배지 (좌하단)
          if (editCount > 0)
            Positioned(
              left: AppSpacing.s3,
              bottom: AppSpacing.s3,
              child: _Badge(
                label: 'v${editCount + 1}',
                color: AppColors.secondary.withValues(alpha: 0.85),
              ),
            ),

          // 플레이 아이콘 (중앙)
          const Center(
            child: Icon(Icons.play_circle_outline,
                color: Colors.white70, size: 40),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (thumbnailPath != null) {
      final file = File(thumbnailPath!);
      if (file.existsSync()) {
        return Image.file(file, fit: BoxFit.cover);
      }
    }
    return const ColoredBox(
      color: AppColors.primaryContainer,
      child: Center(
        child: Icon(Icons.movie_outlined, color: AppColors.onPrimaryContainer, size: 40),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return m > 0 ? '${m}m ${s}s' : '${s}s';
  }
}

// ── 서브 위젯 ──────────────────────────────────────────────────────────────────

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.onSurfaceVariant),
        const SizedBox(width: 3),
        Text(label,
            style: AppTypography.dataLabel.copyWith(
              color: AppColors.onSurfaceVariant,
              fontSize: 10,
            )),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
      ),
      child: Text(label,
          style: AppTypography.dataLabel.copyWith(
            color: Colors.white,
            fontSize: 9,
            letterSpacing: 0.5,
          )),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = destructive ? AppColors.tertiary : AppColors.secondary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s3, vertical: AppSpacing.s2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(label,
                style: AppTypography.labelMd.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                )),
          ],
        ),
      ),
    );
  }
}
