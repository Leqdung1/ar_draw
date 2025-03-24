import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:ragnarok_flutter/utils/app_log.dart';
import 'package:ragnarok_flutter/utils/extensions/string_ext.dart';
import 'package:ragnarok_flutter/utils/i18n_ragnarok_constants.dart';

BuildContext? globalContext;
AppLog appLog = AppLog();
bool useMobileLayout = true;
Map<String, int> countPerSession = {};
bool isDevMode = true;
bool get isDebugMode => isDevMode || kDebugMode;

/// Default language for the app
List<AppLanguage> _defaultLanguages = [
  AppLanguage(
      code: I18nRagnarokConstants.english,
      name: I18nRagnarokConstants.englishName,
      nameEn: I18nRagnarokConstants.englishNameEn,
      flag: '🇬🇧'),
  AppLanguage(
      code: I18nRagnarokConstants.spanish,
      name: I18nRagnarokConstants.spanishName,
      nameEn: I18nRagnarokConstants.spanishNameEn,
      flag: '🇪🇸'),
  AppLanguage(
      code: I18nRagnarokConstants.portuguese,
      name: I18nRagnarokConstants.portugueseName,
      nameEn: I18nRagnarokConstants.portugueseNameEn,
      flag: '🇵🇹'),
  AppLanguage(
      code: I18nRagnarokConstants.french,
      name: I18nRagnarokConstants.frenchName,
      nameEn: I18nRagnarokConstants.frenchNameEn,
      flag: '🇫🇷'),
  AppLanguage(
      code: I18nRagnarokConstants.arabic,
      name: I18nRagnarokConstants.arabicName,
      nameEn: I18nRagnarokConstants.arabicNameEn,
      flag: '🇸🇦'),
  AppLanguage(
      code: I18nRagnarokConstants.chinese,
      name: I18nRagnarokConstants.chineseName,
      nameEn: I18nRagnarokConstants.chineseNameEn,
      flag: '🇨🇳'),
  AppLanguage(
      code: I18nRagnarokConstants.german,
      name: I18nRagnarokConstants.germanName,
      nameEn: I18nRagnarokConstants.germanNameEn,
      flag: '🇩🇪'),
  AppLanguage(
      code: I18nRagnarokConstants.hindi,
      name: I18nRagnarokConstants.hindiName,
      nameEn: I18nRagnarokConstants.hindiNameEn,
      flag: '🇮🇳'),
  AppLanguage(
      code: I18nRagnarokConstants.korean,
      name: I18nRagnarokConstants.koreanName,
      nameEn: I18nRagnarokConstants.koreanNameEn,
      flag: '🇰🇷'),
  AppLanguage(
      code: I18nRagnarokConstants.indonesian,
      name: I18nRagnarokConstants.indonesianName,
      nameEn: I18nRagnarokConstants.indonesianNameEn,
      flag: '🇮🇩'),
  AppLanguage(
      code: I18nRagnarokConstants.italian,
      name: I18nRagnarokConstants.italianName,
      nameEn: I18nRagnarokConstants.italianNameEn,
      flag: '🇮🇹'),
  AppLanguage(
      code: I18nRagnarokConstants.vietnamese,
      name: I18nRagnarokConstants.vietnameseName,
      nameEn: I18nRagnarokConstants.vietnameseNameEn,
      flag: '🇻🇳'),
];

List<AppLanguage> get defaultLanguages => _defaultLanguages;

void setDefaultLanguages(List<AppLanguage> languages) {
  _defaultLanguages = languages.isEmpty ? _defaultLanguages : languages;
}

class AppLanguage {
  final String code;
  final String name;
  final String nameEn;
  final String flag;

  AppLanguage({
    required this.code,
    required this.name,
    required this.nameEn,
    required this.flag,
  });

  static AppLanguage fromCode(String code) {
    code = code
        .valueOr(PlatformDispatcher.instance.locale.languageCode)
        .toLowerCase();
    return defaultLanguages.firstWhere((e) => e.code == code,
        orElse: () => defaultLanguages.first);
  }
}
