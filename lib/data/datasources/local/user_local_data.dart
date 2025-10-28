import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:tal3a/data/models/user_model.dart';

class UserLocalData {
  static final UserLocalData _instance = UserLocalData._internal();
  factory UserLocalData() => _instance;
  UserLocalData._internal();

  //* initialize Hive box (call in main.dart before runApp)
  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox('userBox');
  }

  //* Write user data to Hive
  Future<void> writeUserData(UserModel user) async {
    final box = Hive.box('userBox');
    await box.put('user', user.toMap(user));
  }

  //* Read user data from Hive
  UserModel? readUserData() {
    try {
      final box = Hive.box('userBox');
      final data = box.get('user');
      
      if (data == null) return null;
      
      // Convert dynamic map to Map<String, dynamic>
      final userMap = Map<String, dynamic>.from(data as Map);
      
      // Extract uid as String
      final uid = userMap['uid'] as String;
      
      return UserModel.fromMap(uid, userMap);
    } catch (e) {
      print('Error reading user data: $e');
      return null;
    }
  }

  //* Delete user data
  Future<void> deleteUserData() async {
    final box = Hive.box('userBox');
    await box.delete('user');
  }
}