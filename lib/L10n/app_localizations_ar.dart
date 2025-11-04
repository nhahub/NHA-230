// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get confirmPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get nameLabel => 'الاسم الكامل';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get signupButton => 'إنشاء حساب';

  @override
  String get noAccount => 'ليس لديك حساب؟';

  @override
  String get haveAccount => 'هل لديك حساب بالفعل؟';

  @override
  String get or => 'أو';

  @override
  String get googleSignIn => 'المتابعة عبر جوجل';

  @override
  String get gooleSignUp => 'إنشاء حساب عبر جوجل';

  @override
  String get invalidEmail => 'يرجى إدخال بريد إلكتروني صالح';

  @override
  String get invalidPassword => 'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل';

  @override
  String get passwordsNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get enterName => 'يرجى إدخال الاسم';

  @override
  String get errorTryAgain => 'حدث خطأ, حاول مرة أخرى';

  @override
  String get resetPasswordSent => 'تم إرسال رسالة إعادة تعيين كلمة المرور';

  @override
  String get restaurants => 'مطاعم';

  @override
  String get cafes => 'مقاهي';

  @override
  String get malls => 'مولات';

  @override
  String get goodEvening => 'مساء الخير';

  @override
  String get search => 'ابحث';
}
