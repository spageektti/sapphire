import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageSelectPage extends StatelessWidget {
  const LanguageSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(context.tr('languageSelectPageTitle')),
        ),
        body: Center(
          child: ListView.builder(
            itemCount: context.supportedLocales.length,
            itemBuilder: (context, index) {
              final locale = context.supportedLocales[index];
              return ListTile(
                leading: CountryFlag.fromCountryCode(
                  locale.countryCode!,
                  height: 24,
                  width: 36,
                  shape: const RoundedRectangle(4),
                ),
                title: Text(
                  context.tr(locale.toString()),
                  style: TextStyle(
                    color: context.locale == locale ? Colors.blue : null,
                  ),
                ),
                subtitle: Text(
                  context.tr("${locale}NotTranslated"),
                  style: TextStyle(
                    color: context.locale == locale ? Colors.blue : null,
                  ),
                ),
                onTap: () {
                  context.setLocale(locale);
                },
              );
            },
          ),
        ));
  }
}
