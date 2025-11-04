// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get nameLabel => 'Full Name';

  @override
  String get forgotPassword => 'Forgot your password?';

  @override
  String get loginButton => 'Log In';

  @override
  String get signupButton => 'Sign Up';

  @override
  String get noAccount => 'Don’t have an account?';

  @override
  String get haveAccount => 'Already have an account?';

  @override
  String get or => 'OR';

  @override
  String get googleSignIn => 'Continue with Google';

  @override
  String get gooleSignUp => 'Sign up with Google';

  @override
  String get invalidEmail => 'Please enter a valid email address';

  @override
  String get invalidPassword => 'Password must be at least 6 characters long';

  @override
  String get passwordsNotMatch => 'Passwords do not match';

  @override
  String get enterName => 'Please enter your name';

  @override
  String get errorTryAgain => 'There was an error, Please try again later';

  @override
  String get resetPasswordSent => 'Password reset email sent';

  @override
  String get restaurants => 'Restaurants';

  @override
  String get cafes => 'Cafes';

  @override
  String get malls => 'Malls';

  @override
  String get goodEvening => 'Good evening';

  @override
  String get search => 'search';
}
