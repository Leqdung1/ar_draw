import 'package:hive_flutter/hive_flutter.dart';
import 'package:ragnarok_flutter/local_storage/hive/database_utils.dart';
import 'package:ragnarok_flutter/local_storage/ragnarok_local_storage_key.dart';
import 'package:ragnarok_flutter/top_level_variable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RagnarokLocalStorage {
  static late final SharedPreferences _preferences;

  static Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
    await DatabaseUtils.initDatabase();
  }

  static Future<void> setString(String key, String value) async {
    await _preferences.setString(key, value);
  }

  static String? getString(String key) {
    return _preferences.getString(key);
  }

  static Future<void> setBool(String key, bool value) async {
    await _preferences.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _preferences.getBool(key);
  }

  static Future<void> setInt(String key, int value) async {
    await _preferences.setInt(key, value);
  }

  static int? getInt(String key) {
    return _preferences.getInt(key);
  }

  static Future<void> setDouble(String key, double value) async {
    await _preferences.setDouble(key, value);
  }

  static double? getDouble(String key) {
    return _preferences.getDouble(key);
  }

  static Future<void> setStringList(String key, List<String> value) async {
    await _preferences.setStringList(key, value);
  }

  static List<String>? getStringList(String key) {
    return _preferences.getStringList(key);
  }

  static Future<void> remove(String key) async {
    await _preferences.remove(key);
  }

  static Future<void> clear() async {
    await _preferences.clear();
  }

  static AppLanguage get appLanguage {
    final code = getString(RagnarokLocalStorageKey.languageCode);
    return AppLanguage.fromCode(code ?? '');
  }

  static set appLanguage(AppLanguage language) {
    setString(RagnarokLocalStorageKey.languageCode, language.code);
  }

  static bool get reviewStatus {
    return getBool(RagnarokLocalStorageKey.reviewStatus) ?? false;
  }

  static set reviewStatus(bool status) {
    setBool(RagnarokLocalStorageKey.reviewStatus, status);
  }
}
