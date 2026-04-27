import 'package:flutter_test/flutter_test.dart';
import 'package:mirildan/data/models/entry.dart';
import 'package:mirildan/data/repositories/entry_repository.dart';
import 'package:mirildan/data/services/database_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late EntryRepository repository;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    await DatabaseService.initInMemory();
    repository = EntryRepository();
  });

  tearDown(() async {
    await DatabaseService.close();
  });

  group('EntryRepository', () {
    test('boş veritabanında getAll boş liste döner', () async {
      final entries = await repository.getAll();
      expect(entries, isEmpty);
    });

    test('insert ve getAll çalışır', () async {
      final entry = Entry(
        id: 0,
        createdAt: DateTime(2025, 1, 15),
        type: EntryType.text,
        color: EntryColor.blue,
        text: 'Bugün güzel bir gündü.',
      );

      final saved = await repository.insert(entry);
      expect(saved.id, isPositive);

      final all = await repository.getAll();
      expect(all.length, 1);
      expect(all.first.text, 'Bugün güzel bir gündü.');
      expect(all.first.color, EntryColor.blue);
    });

    test('getById var olan kayıtı döner', () async {
      final entry = Entry(
        id: 0,
        createdAt: DateTime(2025, 1, 15),
        type: EntryType.audio,
        color: EntryColor.purple,
        audioPath: '/audio/test.m4a',
        audioDurationMs: 3000,
      );
      final saved = await repository.insert(entry);

      final fetched = await repository.getById(saved.id);
      expect(fetched, isNotNull);
      expect(fetched!.audioPath, '/audio/test.m4a');
      expect(fetched.audioDurationMs, 3000);
    });

    test('getById olmayan kayıt null döner', () async {
      final result = await repository.getById(999);
      expect(result, isNull);
    });

    test('update kayıtı günceller', () async {
      final entry = Entry(
        id: 0,
        createdAt: DateTime(2025, 1, 15),
        type: EntryType.text,
        color: EntryColor.yellow,
        text: 'Eski metin',
      );
      final saved = await repository.insert(entry);

      await repository.update(saved.copyWith(text: 'Yeni metin'));
      final updated = await repository.getById(saved.id);
      expect(updated!.text, 'Yeni metin');
    });

    test('delete kayıtı siler', () async {
      final entry = Entry(
        id: 0,
        createdAt: DateTime.now(),
        type: EntryType.text,
        color: EntryColor.red,
      );
      final saved = await repository.insert(entry);
      await repository.delete(saved.id);

      final result = await repository.getById(saved.id);
      expect(result, isNull);
    });

    test('renk filtresi çalışır', () async {
      await repository.insert(
        Entry(
          id: 0,
          createdAt: DateTime.now(),
          type: EntryType.text,
          color: EntryColor.green,
        ),
      );
      await repository.insert(
        Entry(
          id: 0,
          createdAt: DateTime.now(),
          type: EntryType.text,
          color: EntryColor.blue,
        ),
      );

      final greens = await repository.getAll(color: EntryColor.green);
      expect(greens.length, 1);
      expect(greens.first.color, EntryColor.green);
    });

    test('count doğru sayı döner', () async {
      expect(await repository.count(), 0);
      await repository.insert(
        Entry(
          id: 0,
          createdAt: DateTime.now(),
          type: EntryType.text,
          color: EntryColor.gray,
        ),
      );
      expect(await repository.count(), 1);
    });
  });
}
