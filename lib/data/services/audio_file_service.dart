import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class AudioFileService {
  static const _uuid = Uuid();

  static Future<String> generatePath() async {
    final dir = await _audioDir();
    final fileName = '${_uuid.v4()}.m4a';
    return join(dir.path, fileName);
  }

  static Future<void> delete(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  static Future<void> deleteOrphans(List<String> activePaths) async {
    final dir = await _audioDir();
    if (!await dir.exists()) return;

    final activeSet = activePaths.toSet();
    await for (final entity in dir.list()) {
      if (entity is File && !activeSet.contains(entity.path)) {
        await entity.delete();
      }
    }
  }

  static Future<Directory> _audioDir() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory(join(base.path, 'audio'));
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }
}
