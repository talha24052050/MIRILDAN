import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  DatabaseService._();

  static Isar? _instance;

  static Isar get instance {
    assert(_instance != null, 'DatabaseService.init() çağrılmadan önce erişim yapıldı.');
    return _instance!;
  }

  static Future<void> init() async {
    if (_instance != null) return;
    final dir = await getApplicationDocumentsDirectory();
    _instance = await Isar.open(
      [],
      directory: dir.path,
      name: 'mirildan',
    );
  }

  static Future<void> close() async {
    await _instance?.close();
    _instance = null;
  }
}
