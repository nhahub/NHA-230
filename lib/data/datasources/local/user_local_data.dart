import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:tal3a/data/models/user_model.dart';

class UserLocalData {
  static final UserLocalData _instance = UserLocalData._internal();
  factory UserLocalData() => _instance;
  UserLocalData._internal();

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox('userBox');
  }

  Future<void> writeUserData(UserModel user) async {
    final box = Hive.box('userBox');
    await box.put('user', user.toMap(user));
  }

  UserModel? readUserData() {
    try {
      final box = Hive.box('userBox');
      final data = box.get('user');
      
      if (data == null) return null;
      final userMap = Map<String, dynamic>.from(data as Map);
      final uid = userMap['uid'] as String;
      return UserModel.fromMap(uid, userMap);
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteUserData() async {
    final box = Hive.box('userBox');
    await box.delete('user');
  }
}