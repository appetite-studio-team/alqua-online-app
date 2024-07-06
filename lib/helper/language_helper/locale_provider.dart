import 'package:flutter/material.dart';
import 'l10n.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    _locale = await LanguageHelper.getLocale();
    notifyListeners();
  }

  Future<void> setLocale(String languageCode) async {
    _locale = await LanguageHelper.setLocale(languageCode);
    notifyListeners();
  }
}
