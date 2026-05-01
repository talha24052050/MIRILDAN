import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/localization/l10n_extensions.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/models/entry.dart';
import '../providers/list_view_providers.dart';
import 'widgets/date_group_header.dart';
import 'widgets/entry_list_tile.dart';
import 'widgets/filter_bar.dart';
import 'widgets/mini_player_bar.dart';

// FilterBar yüksekliği — Stack içi padding hesabı için
const double _kFilterBarHeight = 52.0;
// MiniPlayerBar tahmini yüksekliği
const double _kPlayerBarHeight = 96.0;

class ListViewScreen extends ConsumerWidget {
  const ListViewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final entriesAsync = ref.watch(filteredEntriesProvider);
    final currentlyPlayingId = ref.watch(playerProvider);

    ref.listen<AsyncValue<List<Entry>>>(filteredEntriesProvider, (_, next) {
      final playingId = ref.read(playerProvider);
      if (playingId == null) return;
      next.whenData((entries) {
        if (entries.every((e) => e.id != playingId)) {
          ref.read(playerProvider.notifier).stop();
        }
      });
    });

    final currentEntry = entriesAsync.maybeWhen(
      data: (entries) => currentlyPlayingId == null
          ? null
          : entries.where((e) => e.id == currentlyPlayingId).firstOrNull,
      orElse: () => null,
    );

    final hasPlayer = currentEntry != null;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkOnSurface),
          onPressed: () {
            if (context.canPop()) context.pop();
          },
        ),
        title: Text(
          l10n.listViewTitle,
          style: AppTextStyles.headlineLarge.copyWith(
            color: AppColors.darkOnSurface,
          ),
        ),
      ),
      // Stack: liste tam ekran, FilterBar + MiniPlayerBar üste bindirilir
      body: Stack(
        children: [
          // İçerik — üstten ve alttan glass bar için boşluk bırakır
          Positioned.fill(
            top: _kFilterBarHeight,
            bottom: hasPlayer ? _kPlayerBarHeight : 0,
            child: entriesAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.accent),
              ),
              error: (_, _) => _ErrorState(),
              data: (entries) => entries.isEmpty
                  ? const _EmptyState()
                  : _EntryList(entries: entries),
            ),
          ),

          // Glass filter bar — üstte sabitleniş
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _GlassFilterBar(),
          ),

          // Glass mini player — yalnızca aktif oynatma varsa altta gösterilir
          if (hasPlayer)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _GlassMiniPlayer(
                entry: currentEntry,
                key: ValueKey(currentEntry.id),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Glass wrapper'lar ────────────────────────────────────────────────────────

class _GlassFilterBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          height: _kFilterBarHeight,
          decoration: BoxDecoration(
            color: AppColors.darkBackground.withValues(alpha: 0.72),
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withValues(alpha: 0.06),
                width: 0.5,
              ),
            ),
          ),
          child: const FilterBar(),
        ),
      ),
    );
  }
}

class _GlassMiniPlayer extends StatelessWidget {
  const _GlassMiniPlayer({super.key, required this.entry});

  final Entry entry;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.darkSurface.withValues(alpha: 0.78),
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.07),
                width: 0.5,
              ),
            ),
          ),
          child: MiniPlayerBar(entry: entry),
        ),
      ),
    );
  }
}

// ── Yardımcı widget'lar ─────────────────────────────────────────────────────

class _EntryList extends StatelessWidget {
  const _EntryList({required this.entries});

  final List<Entry> entries;

  @override
  Widget build(BuildContext context) {
    final items = _buildItems(entries);
    final wide = isTablet(context);
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: wide ? 640 : double.infinity),
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
          itemCount: items.length,
          itemBuilder: (_, i) {
            final item = items[i];
            return item is DateTime
                ? DateGroupHeader(date: item)
                : EntryListTile(entry: item as Entry);
          },
        ),
      ),
    );
  }

  static List<Object> _buildItems(List<Entry> entries) {
    final groups = <DateTime, List<Entry>>{};
    for (final e in entries) {
      final key = DateTime(e.createdAt.year, e.createdAt.month, e.createdAt.day);
      (groups[key] ??= []).add(e);
    }

    final sorted = groups.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));

    final items = <Object>[];
    for (final g in sorted) {
      items.add(g.key);
      items.addAll(g.value);
    }
    return items;
  }
}

class _EmptyState extends StatefulWidget {
  const _EmptyState();

  @override
  State<_EmptyState> createState() => _EmptyStateState();
}

class _EmptyStateState extends State<_EmptyState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;
  late final Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3400),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: AnimatedBuilder(
        animation: _floatAnim,
        builder: (_, child) =>
            Transform.translate(offset: Offset(0, _floatAnim.value), child: child),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.listViewEmpty,
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.darkOnSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                l10n.listViewEmptySubtitle,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.darkOnSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        context.l10n.recordSaveError,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.darkOnSurfaceVariant,
        ),
      ),
    );
  }
}
