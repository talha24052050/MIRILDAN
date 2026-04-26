import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_preferences.dart';

class PreferencesRepository {
  static const _key = 'user_preferences';

  Future<UserPreferences> get() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);
    if (json == null) return const UserPreferences();
    return UserPreferences.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<void> save(UserPreferences preferences) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(preferences.toJson()));
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
