import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/entry.dart';
import '../providers/list_view_providers.dart';
import 'widgets/date_group_header.dart';
import 'widgets/entry_list_tile.dart';
import 'widgets/filter_bar.dart';
import 'widgets/mini_player_bar.dart';

class ListViewScreen extends ConsumerWidget {
  const ListViewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(filteredEntriesProvider);
    final currentlyPlayingId = ref.watch(playerProvider);

    // Çalan kayıt silinince player'ı durdur
    ref.listen<AsyncValue<List<Entry>>>(filteredEntriesProvider, (_, next) {
      final playingId = ref.read(playerProvider);
      if (playingId == null) return;
      next.whenData((entries) {
        if (entries.every((e) => e.id != playingId)) {
          ref.read(playerProvider.notifier).stop();
        }
      });
    });

    // Çalan kaydı bul
    final currentEntry = entriesAsync.maybeWhen(
      data: (entries) => currentlyPlayingId == null
          ? null
          : entries.where((e) => e.id == currentlyPlayingId).firstOrNull,
      orElse: () => null,
    );

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
          AppStrings.listViewTitle,
          style: AppTextStyles.headlineLarge.copyWith(
            color: AppColors.darkOnSurface,
          ),
        ),
      ),
      body: Column(
        children: [
          const FilterBar(),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
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
          if (currentEntry != null)
            MiniPlayerBar(key: ValueKey(currentEntry.id), entry: currentEntry),
        ],
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
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final item = items[i];
        return item is DateTime
            ? DateGroupHeader(date: item)
            : EntryListTile(entry: item as Entry);
      },
    );
  }

  // DateTime ve Entry nesnelerini tek listede birleştirir
  static List<Object> _buildItems(List<Entry> entries) {
    final groups = <DateTime, List<Entry>>{};
    for (final e in entries) {
      final key = DateTime(
        e.createdAt.year,
        e.createdAt.month,
        e.createdAt.day,
      );
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

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStrings.listViewEmpty,
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.darkOnSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              AppStrings.listViewEmptySubtitle,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.darkOnSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
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
        AppStrings.recordSaveError,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.darkOnSurfaceVariant,
        ),
      ),
    );
  }
}
