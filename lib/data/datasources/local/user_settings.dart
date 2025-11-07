// user_settings.dart
import 'package:hive_ce_flutter/hive_flutter.dart';

abstract class UserSettings {
  
  static Future<void> init() async {
    await Hive.openBox('settings'); 
  }
  
  Box get settingsBox => Hive.box('settings');
}

class LocalizationsSettings extends UserSettings{
  static final LocalizationsSettings _instance = LocalizationsSettings._internal();
  factory LocalizationsSettings() => _instance;
  LocalizationsSettings._internal();

  Future<void> setLocale(String locale) async{
    await settingsBox.put('localization', locale);
  }

  String getLocale(){
    return settingsBox.get('localization') ?? "en";
  }
}

class ThemeSettings extends UserSettings{
  static final ThemeSettings _instance = ThemeSettings._internal();
  factory ThemeSettings() => _instance;
  ThemeSettings._internal();

  bool isDark() {
    return settingsBox.get("isDark", defaultValue: false);
  }

  Future<void> toggleTheme(bool isDark)async{
    return settingsBox.put("isDark", isDark);
  }
}


