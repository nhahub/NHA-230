// locale_cubit.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tal3a/cubit/localization/local_state.dart';
import 'package:tal3a/data/datasources/local/user_settings.dart';

class LocaleCubit extends Cubit<LocaleState> {

  LocaleCubit({String? initialLocale})
      : super(LocaleState(locale: Locale(initialLocale ?? 'en')));

  Future<void> loadLocale() async {
    final localeCode = LocalizationsSettings().getLocale();
    emit(LocaleState(locale: Locale(localeCode)));
  }

  Future<void> toggleLocale(String localeCode) async {
    await LocalizationsSettings().setLocale(localeCode);
    emit(LocaleState(locale: Locale(localeCode)));
  }
}
