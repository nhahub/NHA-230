import 'package:firebase_core/firebase_core.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:tal3a/data/datasources/local/user_local_data.dart';
import 'package:flutter/widgets.dart';

class AppInitializer {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await Hive.initFlutter();
    await UserLocalData().init();
  }
}
