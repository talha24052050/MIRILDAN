import 'package:freezed_annotation/freezed_annotation.dart';

part 'entry.freezed.dart';
part 'entry.g.dart';

enum EntryType { audio, text, mixed }

enum EntryColor { yellow, blue, red, green, purple, gray, pink, orange }

@freezed
abstract class Entry with _$Entry {
  const factory Entry({
    required int id,
    required DateTime createdAt,
    required EntryType type,
    required EntryColor color,
    String? audioPath,
    int? audioDurationMs,
    String? text,
    String? note,
  }) = _Entry;

  factory Entry.fromJson(Map<String, dynamic> json) => _$EntryFromJson(json);
}
