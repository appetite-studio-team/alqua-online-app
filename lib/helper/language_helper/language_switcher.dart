import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:souq_alqua/helper/language_helper/l10n.dart';
import 'package:souq_alqua/helper/language_helper/locale_provider.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.translate('welcome') ?? ''),
        actions: [
          
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () async {
              String newLanguageCode =
                  Localizations.localeOf(context).languageCode == 'en'
                      ? 'ar'
                      : 'en';
              await localeProvider.setLocale(newLanguageCode);
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          AppLocalizations.of(context)?.translate('hello') ?? '',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
