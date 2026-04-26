import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/emotion_colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../data/models/entry.dart';
import '../../../data/repositories/entry_repository.dart';
import '../../../data/services/audio_file_service.dart';

class ColorPickerScreen extends StatefulWidget {
  const ColorPickerScreen({
    super.key,
    this.audioPath,
    this.audioDurationMs,
    this.text,
  }) : assert(
         audioPath != null || text != null,
         'audioPath veya text sağlanmalı',
       );

  final String? audioPath;
  final int? audioDurationMs;
  final String? text;

  @override
  State<ColorPickerScreen> createState() => _ColorPickerScreenState();
}

class _ColorPickerScreenState extends State<ColorPickerScreen> {
  EmotionColor? _selected;
  final _noteController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_selected == null || _saving) return;
    setState(() => _saving = true);

    final router = GoRouter.of(context);

    try {
      final entryColor = EntryColor.values.byName(_selected!.name);
      final note = _noteController.text.trim();

      final entry = Entry(
        id: 0,
        createdAt: DateTime.now(),
        type: _resolveType(),
        color: entryColor,
        audioPath: widget.audioPath,
        audioDurationMs: widget.audioDurationMs,
        text: widget.text,
        note: note.isEmpty ? null : note,
      );

      await EntryRepository().insert(entry);

      if (!mounted) return;
      router.go(AppRoutes.galaxy);
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.recordSaveError),
          backgroundColor: AppColors.darkSurface,
        ),
      );
    }
  }

  Future<void> _cancel() async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: AppStrings.recordCancelConfirmTitle,
      body: AppStrings.recordCancelConfirmBodyColorPicker,
      cancelLabel: AppStrings.recordCancelConfirmNo,
      confirmLabel: AppStrings.recordCancelConfirmYes,
    );
    if (!mounted || !confirmed) return;

    if (widget.audioPath != null) {
      await AudioFileService.delete(widget.audioPath!);
    }
    if (!mounted) return;
    final router = GoRouter.of(context);
    if (router.canPop()) router.pop();
  }

  EntryType _resolveType() {
    if (widget.audioPath != null && widget.text != null) return EntryType.mixed;
    if (widget.audioPath != null) return EntryType.audio;
    return EntryType.text;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (!_saving) await _cancel();
      },
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        appBar: AppBar(
          backgroundColor: AppColors.darkBackground,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.darkOnSurface),
            onPressed: _saving ? null : _cancel,
          ),
        ),
        body: SingleChildScrollView(
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
                onSelect: (c) {
                  HapticFeedback.selectionClick();
                  setState(() => _selected = c);
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                AppStrings.recordAddNote,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.darkOnSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _noteController,
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
              const SizedBox(height: AppSpacing.xxl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_selected != null && !_saving) ? _save : null,
                  child: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(AppStrings.recordSave),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: _saving ? null : _cancel,
                  child: Text(
                    AppStrings.recordCancel,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.darkOnSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
      childAspectRatio: 0.85,
      children: EmotionColor.values.map((e) {
        final isSelected = selected == e;
        return GestureDetector(
          onTap: () => onSelect(e),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: AppDuration.fast),
                width: isSelected
                    ? AppSize.colorSwatchSizeSelected
                    : AppSize.colorSwatchSize,
                height: isSelected
                    ? AppSize.colorSwatchSizeSelected
                    : AppSize.colorSwatchSize,
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
