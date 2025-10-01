import 'package:shared_preferences/shared_preferences.dart';

enum UserState { onBoarding, onReg, onHome }

//save the state (call when navigating to save the state)
//get state (call in main)

class States {
  static UserState _currentState = UserState.onBoarding;

  static UserState getState() => _currentState;

  static Future<void> updateState(UserState userState) async {
    _currentState = userState;
    await _saveUserState();
  }

  static Future<void> _saveUserState() async =>
      await SharedPreferences.getInstance().then(
        (value) async => await value.setInt('state', _currentState.index), 
        //0 for onboarding
        //1 for registration screens
        //2 for home screen
      );

  static Future<void> storeUserState() async =>
      await SharedPreferences.getInstance().then(
        (value) => _currentState = UserState.values[value.getInt('state') ?? 0],
      );
}
