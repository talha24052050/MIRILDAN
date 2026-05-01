import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/localization/l10n_extensions.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/duration_formatter.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../domain/recording_state.dart';
import '../providers/recording_providers.dart';
import 'widgets/record_button.dart';
import 'widgets/waveform_display.dart';

class RecordingScreen extends ConsumerStatefulWidget {
  const RecordingScreen({super.key});

  @override
  ConsumerState<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends ConsumerState<RecordingScreen> {
  bool _textMode = false;
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleRecordStart() {
    ref.read(recordingControllerProvider.notifier).startRecording();
  }

  Future<void> _handleRecordEnd() async {
    final router = GoRouter.of(context);
    final controller = ref.read(recordingControllerProvider.notifier);
    final path = await controller.stopRecording();
    if (!mounted) return;

    if (path != null) {
      final durationMs = ref
          .read(recordingControllerProvider)
          .maybeMap(done: (d) => d.duration.inMilliseconds, orElse: () => 0);
      router.push(
        AppRoutes.colorPicker,
        extra: {'audioPath': path, 'durationMs': durationMs},
      );
    }
  }

  void _handleTextSave() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    context.push(AppRoutes.colorPicker, extra: {'text': text});
  }

  Future<void> _handleClose() async {
    final state = ref.read(recordingControllerProvider);
    final isCurrentlyRecording = state is RecordingInProgress;
    final l10n = context.l10n;

    if (isCurrentlyRecording) {
      final confirmed = await showConfirmDialog(
        context: context,
        title: l10n.recordCancelConfirmTitle,
        body: l10n.recordCancelConfirmBodyAudio,
        cancelLabel: l10n.recordCancelConfirmNo,
        confirmLabel: l10n.recordCancelConfirmYes,
      );
      if (!mounted || !confirmed) return;
      await ref.read(recordingControllerProvider.notifier).cancelRecording();
    } else if (_textMode && _textController.text.trim().isNotEmpty) {
      final confirmed = await showConfirmDialog(
        context: context,
        title: l10n.recordCancelConfirmTitle,
        body: l10n.recordCancelConfirmBodyText,
        cancelLabel: l10n.recordCancelConfirmNo,
        confirmLabel: l10n.recordCancelConfirmYes,
      );
      if (!mounted || !confirmed) return;
    }

    if (mounted) {
      final router = GoRouter.of(context);
      if (router.canPop()) router.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recordingControllerProvider);

    ref.listen(recordingControllerProvider, (_, next) {
      if (next is RecordingPermissionDenied && !_textMode) {
        setState(() => _textMode = true);
      }
    });

    final activeRecording = state is RecordingInProgress ? state : null;
    final isRecording = activeRecording != null;
    final amplitude = activeRecording?.amplitude ?? 0.0;
    final elapsed = activeRecording?.elapsed ?? Duration.zero;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _handleClose();
      },
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        appBar: AppBar(
          backgroundColor: AppColors.darkBackground,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: AppColors.darkOnSurface),
            onPressed: _handleClose,
          ),
          actions: [
            if (!isRecording)
              TextButton(
                onPressed: () => setState(() => _textMode = !_textMode),
                child: Text(
                  _textMode
                      ? context.l10n.recordSwitchToAudio
                      : context.l10n.recordWrite,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.accent,
                  ),
                ),
              ),
          ],
        ),
        body: _CenteredContent(
          child: _textMode
              ? _buildTextMode()
              : _buildAudioMode(isRecording, amplitude, elapsed, state),
        ),
      ),
    );
  }

  Widget _buildAudioMode(
    bool isRecording,
    double amplitude,
    Duration elapsed,
    RecordingState state,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        WaveformDisplay(isRecording: isRecording, amplitude: amplitude),
        const SizedBox(height: AppSpacing.xl),
        AnimatedOpacity(
          opacity: isRecording ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: Text(
            DurationFormatter.format(elapsed),
            style: AppTextStyles.displayMedium.copyWith(
              color: AppColors.darkOnSurface,
            ),
          ),
        ),
        const Spacer(),
        if (state is RecordingPermissionDenied)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Text(
              context.l10n.recordPermissionDenied,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
          ),
        Text(
          isRecording ? context.l10n.recordRelease : context.l10n.recordHold,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.darkOnSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        RecordButton(
          isRecording: isRecording,
          pulseValue: amplitude,
          onPressStart: _handleRecordStart,
          onPressEnd: _handleRecordEnd,
        ),
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }

  Widget _buildTextMode() {
    return Column(
      children: [
        const Spacer(),
        TextField(
          controller: _textController,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.darkOnSurface,
          ),
          decoration: InputDecoration(
            hintText: context.l10n.recordTextHint,
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
          maxLines: 6,
          maxLength: 280,
          buildCounter:
              (
                context, {
                required currentLength,
                required isFocused,
                maxLength,
              }) => Text(
                '$currentLength / $maxLength',
                style: AppTextStyles.labelSmall.copyWith(
                  color: currentLength >= maxLength!
                      ? AppColors.error
                      : AppColors.darkOnSurfaceVariant,
                ),
              ),
          autofocus: true,
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _handleTextSave,
            child: Text(context.l10n.recordContinue),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }
}

// Tablette içeriği ortalanmış, max genişlikte gösterir.
class _CenteredContent extends StatelessWidget {
  const _CenteredContent({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final wide = isTablet(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: wide
          ? Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: child,
              ),
            )
          : child,
    );
  }
}
