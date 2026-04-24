import 'package:sqflite/sqflite.dart';
import '../models/entry.dart';
import '../services/database_service.dart';

class EntryRepository {
  Database get _db => DatabaseService.db;

  Future<List<Entry>> getAll({
    EntryColor? color,
    EntryType? type,
    DateTime? from,
    DateTime? to,
  }) async {
    final where = <String>[];
    final args = <Object>[];

    if (color != null) {
      where.add('color = ?');
      args.add(color.name);
    }
    if (type != null) {
      where.add('type = ?');
      args.add(type.name);
    }
    if (from != null) {
      where.add('created_at >= ?');
      args.add(from.millisecondsSinceEpoch);
    }
    if (to != null) {
      where.add('created_at <= ?');
      args.add(to.millisecondsSinceEpoch);
    }

    final rows = await _db.query(
      'entries',
      where: where.isEmpty ? null : where.join(' AND '),
      whereArgs: args.isEmpty ? null : args,
      orderBy: 'created_at DESC',
    );

    return rows.map(_rowToEntry).toList();
  }

  Future<Entry?> getById(int id) async {
    final rows = await _db.query(
      'entries',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return _rowToEntry(rows.first);
  }

  Future<Entry> insert(Entry entry) async {
    final id = await _db.insert('entries', _entryToRow(entry));
    return entry.copyWith(id: id);
  }

  Future<void> update(Entry entry) async {
    await _db.update(
      'entries',
      _entryToRow(entry),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<void> delete(int id) async {
    await _db.delete('entries', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> count() async {
    final result = await _db.rawQuery('SELECT COUNT(*) FROM entries');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Map<String, Object?> _entryToRow(Entry e) => {
    'created_at': e.createdAt.millisecondsSinceEpoch,
    'type': e.type.name,
    'color': e.color.name,
    'audio_path': e.audioPath,
    'audio_duration_ms': e.audioDurationMs,
    'text': e.text,
    'note': e.note,
  };

  Entry _rowToEntry(Map<String, Object?> row) => Entry(
    id: row['id'] as int,
    createdAt: DateTime.fromMillisecondsSinceEpoch(row['created_at'] as int),
    type: EntryType.values.byName(row['type'] as String),
    color: EntryColor.values.byName(row['color'] as String),
    audioPath: row['audio_path'] as String?,
    audioDurationMs: row['audio_duration_ms'] as int?,
    text: row['text'] as String?,
    note: row['note'] as String?,
  );
}
