import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/localization/l10n_extensions.dart';
import '../../../core/router/app_router.dart';
import '../../../data/models/entry.dart';
import '../providers/galaxy_providers.dart';
import 'galaxy_painter.dart';
import 'widgets/entry_detail_sheet.dart';

class GalaxyScreen extends ConsumerStatefulWidget {
  const GalaxyScreen({super.key});

  @override
  ConsumerState<GalaxyScreen> createState() => _GalaxyScreenState();
}

class _GalaxyScreenState extends ConsumerState<GalaxyScreen>
    with TickerProviderStateMixin {
  final TransformationController _transformController =
      TransformationController();

  int? _highlightedId;
  late final AnimationController _pulseController;
  GalaxyPainter? _lastPainter;

  GoRouter? _router;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    // Context hazır olunca router listener'ı kaydet (test ortamında GoRouter olmayabilir)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _router = GoRouter.maybeOf(context);
      _router?.routerDelegate.addListener(_onRouteChange);
    });
  }

  void _onRouteChange() {
    final location =
        _router?.routerDelegate.currentConfiguration.uri.path ?? '';
    if (location == AppRoutes.galaxy && mounted) {
      ref.invalidate(galaxyEntriesProvider);
    }
  }

  @override
  void dispose() {
    _router?.routerDelegate.removeListener(_onRouteChange);
    _transformController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details, List<Entry> entries) {
    if (_lastPainter == null) return;

    // Dokunulan noktayı InteractiveViewer'ın dönüşüm matrisine göre hesapla
    final matrix = _transformController.value;
    final inverted = Matrix4.inverted(matrix);
    final local = MatrixUtils.transformPoint(inverted, details.localPosition);

    const hitRadius = 20.0;
    for (final dot in _lastPainter!.dots) {
      if ((dot.position - local).distance <= hitRadius) {
        setState(() => _highlightedId = dot.entry.id);
        EntryDetailSheet.show(
          context,
          dot.entry,
          onDeleted: () {
            setState(() => _highlightedId = null);
            ref.invalidate(galaxyEntriesProvider);
          },
        ).then((_) => setState(() => _highlightedId = null));
        return;
      }
    }
    setState(() => _highlightedId = null);
  }

  @override
  Widget build(BuildContext context) {
    final entriesAsync = ref.watch(galaxyEntriesProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.list_rounded,
              color: AppColors.darkOnSurface,
            ),
            onPressed: () => context.push(AppRoutes.listView),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: entriesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
        error: (e, _) => Center(
          child: Text(
            context.l10n.recordSaveError,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.darkOnSurfaceVariant,
            ),
          ),
        ),
        data: (entries) => entries.isEmpty
            ? _EmptyState(onRecord: () => context.push(AppRoutes.record))
            : _GalaxyCanvas(
                entries: entries,
                highlightedId: _highlightedId,
                pulseController: _pulseController,
                transformController: _transformController,
                onPainterBuilt: (p) => _lastPainter = p,
                onTapDown: (d) => _onTapDown(d, entries),
                onRecord: () => context.push(AppRoutes.record),
              ),
      ),
    );
  }
}

// ── Galaksi canvas + kayıt butonu ────────────────────────────────────────────

class _GalaxyCanvas extends StatelessWidget {
  const _GalaxyCanvas({
    required this.entries,
    required this.highlightedId,
    required this.pulseController,
    required this.transformController,
    required this.onPainterBuilt,
    required this.onTapDown,
    required this.onRecord,
  });

  final List<Entry> entries;
  final int? highlightedId;
  final AnimationController pulseController;
  final TransformationController transformController;
  final void Function(GalaxyPainter) onPainterBuilt;
  final void Function(TapDownDetails) onTapDown;
  final VoidCallback onRecord;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Arkaplan yıldız efekti — hafif noise
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [AppColors.darkSurface, AppColors.darkBackground],
              ),
            ),
          ),
        ),

        // Canvas
        Positioned.fill(
          child: AnimatedBuilder(
            animation: pulseController,
            builder: (context, _) {
              final painter = GalaxyPainter(
                entries: entries,
                highlightedId: highlightedId,
                animationValue: pulseController.value,
              );
              onPainterBuilt(painter);
              return GestureDetector(
                onTapDown: onTapDown,
                child: InteractiveViewer(
                  transformationController: transformController,
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: CustomPaint(
                    painter: painter,
                    child: const SizedBox.expand(),
                  ),
                ),
              );
            },
          ),
        ),

        // Kayıt butonu — sağ alt
        Positioned(
          right: AppSpacing.xl,
          bottom: AppSpacing.xl + AppSpacing.lg,
          child: _RecordButton(onPressed: onRecord),
        ),
      ],
    );
  }
}

// ── Boş durum ─────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onRecord});

  final VoidCallback onRecord;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.galaxyEmpty,
            style: AppTextStyles.displayMedium.copyWith(
              color: AppColors.darkOnSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.galaxyEmptySubtitle,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.darkOnSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxl),
          _RecordButton(onPressed: onRecord),
        ],
      ),
    );
  }
}

// ── Kayıt butonu ──────────────────────────────────────────────────────────────

class _RecordButton extends StatelessWidget {
  const _RecordButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: AppSize.recordButtonSize,
        height: AppSize.recordButtonSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.accent,
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.35),
              blurRadius: 20,
              spreadRadius: 4,
            ),
          ],
        ),
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: AppSize.iconSizeLg,
        ),
      ),
    );
  }
}
