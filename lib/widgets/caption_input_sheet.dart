import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/caption_style.dart';
import '../models/photo_caption.dart';

/// 사진 캡션 입력/편집 바텀시트.
///
/// [existing]이 있으면 기존 값을 초기값으로 채운다.
/// 저장 시 [onSave] 호출, 삭제 시 [onDelete] 호출.
class CaptionInputSheet extends StatefulWidget {
  final String assetId;
  final PhotoCaption? existing;
  final void Function(String text, CaptionStyle style) onSave;
  final VoidCallback? onDelete;

  const CaptionInputSheet({
    super.key,
    required this.assetId,
    required this.existing,
    required this.onSave,
    this.onDelete,
  });

  @override
  State<CaptionInputSheet> createState() => _CaptionInputSheetState();
}

class _CaptionInputSheetState extends State<CaptionInputSheet> {
  late final TextEditingController _textCtrl;
  late CaptionStyle _style;

  @override
  void initState() {
    super.initState();
    _textCtrl = TextEditingController(text: widget.existing?.text ?? '');
    _style = widget.existing?.style ?? CaptionStyle.modern;
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottom),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 핸들
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 제목
          Text(
            widget.existing == null ? '문구 추가' : '문구 편집',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),

          // 텍스트 입력
          TextField(
            controller: _textCtrl,
            autofocus: true,
            maxLength: 60,
            maxLines: 2,
            style: _previewTextStyle(_style),
            decoration: InputDecoration(
              hintText: '이 사진의 기억을 남겨보세요',
              filled: true,
              fillColor: Colors.black.withAlpha(8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 12),

          // 스타일 프리셋 선택
          const Text(
            '스타일',
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: kCaptionStylePresets.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final preset = kCaptionStylePresets[i];
                final selected = _style.fontStyle == preset.style.fontStyle &&
                    _style.textColorHex == preset.style.textColorHex;
                return GestureDetector(
                  onTap: () => setState(() => _style = preset.style),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Colors.black.withAlpha(10),
                      borderRadius: BorderRadius.circular(12),
                      border: selected
                          ? Border.all(
                              color:
                                  Theme.of(context).colorScheme.primary,
                              width: 1.5,
                            )
                          : null,
                    ),
                    child: Text(
                      preset.label,
                      style: _previewTextStyle(preset.style).copyWith(
                        fontSize: 14,
                        color: selected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // 미리보기
          if (_textCtrl.text.isNotEmpty)
            _CaptionPreview(text: _textCtrl.text, style: _style),

          const SizedBox(height: 16),

          // 하단 버튼
          Row(
            children: [
              if (widget.existing != null)
                OutlinedButton.icon(
                  onPressed: widget.onDelete,
                  icon: const Icon(Icons.delete_outline, size: 16),
                  label: const Text('삭제'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red.shade700,
                    side: BorderSide(color: Colors.red.shade200),
                  ),
                ),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('취소'),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: _textCtrl.text.trim().isEmpty
                    ? null
                    : () {
                        widget.onSave(_textCtrl.text.trim(), _style);
                        Navigator.pop(context);
                      },
                child: const Text('저장'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextStyle _previewTextStyle(CaptionStyle s) {
    return switch (s.fontStyle) {
      CaptionFontStyle.serif => GoogleFonts.notoSerif(fontSize: 15),
      CaptionFontStyle.handwriting =>
        GoogleFonts.caveat(fontSize: 16, fontWeight: FontWeight.w600),
      CaptionFontStyle.sansSerif => GoogleFonts.notoSans(fontSize: 15),
      CaptionFontStyle.bold =>
        GoogleFonts.notoSans(fontSize: 15, fontWeight: FontWeight.w700),
    };
  }
}

// ── 미리보기 위젯 ─────────────────────────────────────────────────────────────

class _CaptionPreview extends StatelessWidget {
  final String text;
  final CaptionStyle style;

  const _CaptionPreview({required this.text, required this.style});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const Text('미리보기',
              style: TextStyle(fontSize: 10, color: Colors.white38)),
          const SizedBox(height: 4),
          Container(
            padding: style.hasBg
                ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
                : EdgeInsets.zero,
            decoration: style.hasBg
                ? BoxDecoration(
                    color: style.bgColor,
                    borderRadius: BorderRadius.circular(4),
                  )
                : null,
            child: Text(
              text,
              style: TextStyle(
                color: style.textColor,
                fontSize: 16,
                fontWeight:
                    style.fontStyle == CaptionFontStyle.bold
                        ? FontWeight.bold
                        : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
