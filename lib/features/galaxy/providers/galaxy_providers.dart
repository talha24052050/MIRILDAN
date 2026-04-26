import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/entry.dart';
import '../../../data/repositories/entry_repository.dart';

part 'galaxy_providers.g.dart';

// Galaksi filtre durumu — renk ve tip seçimi
@riverpod
class GalaxyFilter extends _$GalaxyFilter {
  @override
  ({EntryColor? color, EntryType? type}) build() => (color: null, type: null);

  void setColor(EntryColor? color) =>
      state = (color: color, type: state.type);

  void setType(EntryType? type) =>
      state = (color: state.color, type: type);

  void clear() => state = (color: null, type: null);
}

// Filtreli tüm kayıtlar — galaksi canvas'ı için
@riverpod
Future<List<Entry>> galaxyEntries(Ref ref) {
  final filter = ref.watch(galaxyFilterProvider);
  return EntryRepository().getAll(color: filter.color, type: filter.type);
}
