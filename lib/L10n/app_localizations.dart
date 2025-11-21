import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get nameLabel;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotPassword;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get loginButton;

  /// No description provided for @signupButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signupButton;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don’t have an account? '**
  String get noAccount;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get haveAccount;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @googleSignIn.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get googleSignIn;

  /// No description provided for @gooleSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up with Google'**
  String get gooleSignUp;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get invalidEmail;

  /// No description provided for @invalidPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters long'**
  String get invalidPassword;

  /// No description provided for @passwordsNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsNotMatch;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get enterName;

  /// No description provided for @errorTryAgain.
  ///
  /// In en, this message translates to:
  /// **'There was an error, Please try again later'**
  String get errorTryAgain;

  /// No description provided for @resetPasswordSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent'**
  String get resetPasswordSent;

  /// No description provided for @restaurants.
  ///
  /// In en, this message translates to:
  /// **'Restaurants'**
  String get restaurants;

  /// No description provided for @cafes.
  ///
  /// In en, this message translates to:
  /// **'Cafes'**
  String get cafes;

  /// No description provided for @malls.
  ///
  /// In en, this message translates to:
  /// **'Malls'**
  String get malls;

  /// No description provided for @beaches.
  ///
  /// In en, this message translates to:
  /// **'Beaches'**
  String get beaches;

  /// No description provided for @amusementParks.
  ///
  /// In en, this message translates to:
  /// **'Amusement parks'**
  String get amusementParks;

  /// No description provided for @touristAttraction.
  ///
  /// In en, this message translates to:
  /// **'Tourist attractions'**
  String get touristAttraction;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'search'**
  String get search;

  /// No description provided for @searchPlaceOrAddress.
  ///
  /// In en, this message translates to:
  /// **'Search place or address'**
  String get searchPlaceOrAddress;

  /// No description provided for @searchForPlace.
  ///
  /// In en, this message translates to:
  /// **'Search for a place'**
  String get searchForPlace;

  /// No description provided for @centerMap.
  ///
  /// In en, this message translates to:
  /// **'Center map on current location'**
  String get centerMap;

  /// No description provided for @myLocation.
  ///
  /// In en, this message translates to:
  /// **'My Location'**
  String get myLocation;

  /// No description provided for @showRoute.
  ///
  /// In en, this message translates to:
  /// **'Show route'**
  String get showRoute;

  /// No description provided for @hideRoute.
  ///
  /// In en, this message translates to:
  /// **'Hide route'**
  String get hideRoute;

  /// No description provided for @clearDestination.
  ///
  /// In en, this message translates to:
  /// **'Clear destination'**
  String get clearDestination;

  /// No description provided for @noLikedPlaces.
  ///
  /// In en, this message translates to:
  /// **'No liked places'**
  String get noLikedPlaces;

  /// No description provided for @goToLocation.
  ///
  /// In en, this message translates to:
  /// **'Go tp location'**
  String get goToLocation;

  /// No description provided for @branches.
  ///
  /// In en, this message translates to:
  /// **'📍 Branches:'**
  String get branches;

  /// No description provided for @unnamedPlace.
  ///
  /// In en, this message translates to:
  /// **'Unnamed Place'**
  String get unnamedPlace;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating: '**
  String get rating;

  /// No description provided for @openingHours.
  ///
  /// In en, this message translates to:
  /// **'Opening Hours: '**
  String get openingHours;

  /// No description provided for @bestTimeToVisit.
  ///
  /// In en, this message translates to:
  /// **'Best Time to Visit'**
  String get bestTimeToVisit;

  /// No description provided for @visitOnSocialMedia.
  ///
  /// In en, this message translates to:
  /// **'Visit on Social Media'**
  String get visitOnSocialMedia;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @tal3a.
  ///
  /// In en, this message translates to:
  /// **'Tal3a'**
  String get tal3a;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile Updated!'**
  String get profileUpdated;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @onboardingFirstScreenFirstLine.
  ///
  /// In en, this message translates to:
  /// **'Not sure where to go in Alexandria?'**
  String get onboardingFirstScreenFirstLine;

  /// No description provided for @onboardingFirstScreenSecondLine.
  ///
  /// In en, this message translates to:
  /// **'Tal3a will guide you!'**
  String get onboardingFirstScreenSecondLine;

  /// No description provided for @onboardingSecondScreenFirstLine.
  ///
  /// In en, this message translates to:
  /// **'Restaurants, cafés, beaches…'**
  String get onboardingSecondScreenFirstLine;

  /// No description provided for @onboardingSecondScreenSecondLine.
  ///
  /// In en, this message translates to:
  /// **'Choose what suits you!'**
  String get onboardingSecondScreenSecondLine;

  /// No description provided for @onboardingThirdScreenFirstLine.
  ///
  /// In en, this message translates to:
  /// **'Save the places you like'**
  String get onboardingThirdScreenFirstLine;

  /// No description provided for @onboardingThirdScreenSecondLine.
  ///
  /// In en, this message translates to:
  /// **'and start your trip'**
  String get onboardingThirdScreenSecondLine;

  /// No description provided for @likedPlaces.
  ///
  /// In en, this message translates to:
  /// **'Liked Places'**
  String get likedPlaces;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
