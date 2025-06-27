/*
 * SPDX-FileCopyrightText: 2024 Wiktor Perskawiec <wiktor@perskawiec.cc>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
/*
* Copyright (C) 2024 Wiktor Perskawiec <wiktor@perskawiec.cc>

? This program is free software: you can redistribute it and/or modify
? it under the terms of the GNU General Public License as published by
? the Free Software Foundation, either version 3 of the License, or
? (at your option) any later version.

! This program is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.

* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/
/* 
! To contribute, please read the README.md file in the root of the project.
? It contains important information about the project structure, code style, suggested VSCode extensions, and more.
*/
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
