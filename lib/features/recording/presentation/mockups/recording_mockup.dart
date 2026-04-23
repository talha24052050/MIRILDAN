import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/emotion_colors.dart';

// Adım 1: Ses kaydı ekranı
class RecordingMockup extends StatefulWidget {
  const RecordingMockup({super.key});

  @override
  State<RecordingMockup> createState() => _RecordingMockupState();
}

class _RecordingMockupState extends State<RecordingMockup>
    with SingleTickerProviderStateMixin {
  bool _isRecording = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onRecordStart() {
    setState(() => _isRecording = true);
    _pulseController.repeat(reverse: true);
  }

  void _onRecordEnd() {
    setState(() => _isRecording = false);
    _pulseController.stop();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ColorPickerMockup()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.darkOnSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            // Dalga formu placeholder
            _WaveformPlaceholder(isRecording: _isRecording),
            const SizedBox(height: AppSpacing.xl),
            AnimatedOpacity(
              opacity: _isRecording ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                '0:05',
                style: AppTextStyles.displayMedium.copyWith(
                  color: AppColors.darkOnSurface,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
            const Spacer(),
            Text(
              _isRecording ? 'Bırak, bitir.' : AppStrings.recordHold,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.darkOnSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            GestureDetector(
              onTapDown: (_) => _onRecordStart(),
              onTapUp: (_) => _onRecordEnd(),
              onLongPressStart: (_) => _onRecordStart(),
              onLongPressEnd: (_) => _onRecordEnd(),
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (_, _) {
                  final scale = _isRecording
                      ? 1.0 + _pulseController.value * 0.12
                      : 1.0;
                  return Transform.scale(
                    scale: scale,
                    child: _RecordButton(isRecording: _isRecording),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

class _WaveformPlaceholder extends StatelessWidget {
  const _WaveformPlaceholder({required this.isRecording});
  final bool isRecording;

  static const _waveHeights = [
    16.0, 24.0, 40.0, 32.0, 56.0, 48.0, 64.0, 48.0,
    72.0, 56.0, 40.0, 64.0, 48.0, 32.0, 56.0, 40.0,
    72.0, 64.0, 48.0, 56.0, 40.0, 32.0, 48.0, 24.0,
    40.0, 32.0, 16.0, 8.0,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(28, (i) {
          final h = isRecording ? _waveHeights[i] : 4.0;
          return AnimatedContainer(
            duration: Duration(milliseconds: 200 + i * 10),
            curve: Curves.easeInOut,
            width: 4,
            height: h,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: isRecording
                  ? AppColors.accent.withValues(alpha: 0.6 + (i % 3) * 0.13)
                  : AppColors.darkSurfaceVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      ),
    );
  }
}

class _RecordButton extends StatelessWidget {
  const _RecordButton({required this.isRecording});
  final bool isRecording;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: isRecording ? 88 : 80,
      height: isRecording ? 88 : 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isRecording ? AppColors.error : AppColors.accent,
        boxShadow: [
          BoxShadow(
            color: (isRecording ? AppColors.error : AppColors.accent)
                .withValues(alpha: 0.45),
            blurRadius: 28,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Icon(
        isRecording ? Icons.stop_rounded : Icons.mic_rounded,
        color: Colors.white,
        size: 32,
      ),
    );
  }
}

// Adım 2: Renk seçim ekranı
class ColorPickerMockup extends StatefulWidget {
  const ColorPickerMockup({super.key});

  @override
  State<ColorPickerMockup> createState() => _ColorPickerMockupState();
}

class _ColorPickerMockupState extends State<ColorPickerMockup> {
  EmotionColor? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkOnSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.recordColorTitle,
              style: AppTextStyles.headlineLarge.copyWith(
                color: AppColors.darkOnSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            _ColorGrid(
              selected: _selected,
              onSelect: (c) => setState(() => _selected = c),
            ),
            const SizedBox(height: AppSpacing.xl),
            // Opsiyonel not alanı
            Text(
              AppStrings.recordAddNote,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.darkOnSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.darkOnSurface,
              ),
              decoration: InputDecoration(
                hintText: AppStrings.recordNoteHint,
                hintStyle: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.darkOnSurfaceVariant,
                ),
                filled: true,
                fillColor: AppColors.darkSurfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(AppSpacing.md),
              ),
              maxLines: 3,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _selected != null ? () {} : null,
              child: const Text(AppStrings.recordSave),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(AppStrings.recordCancel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorGrid extends StatelessWidget {
  const _ColorGrid({required this.selected, required this.onSelect});
  final EmotionColor? selected;
  final ValueChanged<EmotionColor> onSelect;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppSpacing.md,
      mainAxisSpacing: AppSpacing.md,
      children: EmotionColor.values.map((e) {
        final isSelected = selected == e;
        return GestureDetector(
          onTap: () => onSelect(e),
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: isSelected ? 56 : 48,
                height: isSelected ? 56 : 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: e.color,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: e.color.withValues(alpha: 0.6),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                  border: isSelected
                      ? Border.all(color: Colors.white, width: 2)
                      : null,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                e.labelTr,
                style: AppTextStyles.labelSmall.copyWith(
                  color: isSelected
                      ? AppColors.darkOnSurface
                      : AppColors.darkOnSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

