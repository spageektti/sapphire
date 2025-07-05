/*
 * SPDX-FileCopyrightText: 2025 Wiktor Perskawiec <wiktor@perskawiec.cc>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
/*
* Copyright (C) 2025 Wiktor Perskawiec <wiktor@perskawiec.cc>

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
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sapphire/widgets/info_modal_bottom_sheet.dart';
import 'package:sapphire/widgets/settings_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class passwordStrengthWidget extends StatefulWidget {
  const passwordStrengthWidget({super.key});

  @override
  _passwordStrengthWidgetState createState() => _passwordStrengthWidgetState();
}

class _passwordStrengthWidgetState extends State<passwordStrengthWidget> {
  List<String> _settings = ['!@#\$%^&*()-_=+[]{}|;:,.<>?/~\\\'"`'];
  double _result = 0;
  int _smallEnglish = 0;
  int _bigEnglish = 0;
  int _digits = 0;
  int _special = 0;
  int _moreSpecial = 0;
  String _strength = 'passwordStrengthVeryWeak';

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'passwordStrengthSettings';
    final values = prefs.getStringList(key);
    setState(() {
      if (values != null && values.isNotEmpty) {
        _settings = values;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('passwordStrengthLongName')),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (context) => const SettingsWidget(
                        settings: ['specialCharacters',],
                        defaultValues: ['!@#\$%^&*()-_=+[]{}|;:,.<>?/~\\\'"`'],
                        pageName: 'passwordStrength',
                      ),
                    ),
                  )
                  .then((_) => _loadSettings());
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => InfoModalBottomSheet(
                      name: context.tr('passwordStrengthLongName'),
                      description: context.tr('passwordStrengthLongDescription'),
                      author: 'Wiktor Perskawiec (spageektti)',
                      authorUrl: 'https://spageektti.cc'));
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Text(
                  context
                      .tr("passwordStrength", namedArgs: {"result": "$_result"}) + '(${context.tr(_strength)})',
                  style: const TextStyle(fontSize: 24)),
            ),
            Padding(padding: const EdgeInsets.only(bottom: 32), child: 
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(context.tr("passwordStrengthSmallEnglish", namedArgs: {"count": "$_smallEnglish"})),
                Text(context.tr("passwordStrengthBigEnglish", namedArgs: {"count": "$_bigEnglish"})),
                Text(context.tr("passwordStrengthDigits", namedArgs: {"count": "$_digits"})),
                Text(context.tr("passwordStrengthSpecial", namedArgs: {"count": "$_special"})),
                Text(context.tr("passwordStrengthMoreSpecial", namedArgs: {"count": "$_moreSpecial"})),
              ],
            )
            ,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 16),
              child: TextField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: context.tr("passwordStrengthInputLabel"),
                ),
                onChanged: (value) {
                  setState(() {
                    _smallEnglish = value
                        .split('')
                        .where((char) => char.codeUnitAt(0) >= 97 && char.codeUnitAt(0) <= 122)
                        .length;
                    _bigEnglish = value
                        .split('')
                        .where((char) => char.codeUnitAt(0) >= 65 && char.codeUnitAt(0) <= 90)
                        .length;
                    _digits = value
                        .split('')
                        .where((char) => char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57)
                        .length;
                    _special = value
                        .split('')
                        .where((char) => _settings[0].contains(char))
                        .length;
                    _moreSpecial = value
                        .split('')
                        .where((char) => char.codeUnitAt(0) < 32 || char.codeUnitAt(0) > 126)
                        .length;
                    int R = _smallEnglish > 0 ? 26 : 0 + _bigEnglish > 0 ? 26 : 0 + _digits > 0 ? 10 : 0 + _special > 0 ? _settings[0].length : 0 + _moreSpecial;
                    int L = value.length;
                    _result = (R > 0 && L > 0) ? log(R * L) / log(2) : 0;
                    if (_result < 6) {
                      _strength = 'passwordStrengthVeryWeak';
                    } else if (_result < 8) {
                      _strength = 'passwordStrengthWeak';
                    } else if (_result < 10) {
                      _strength = 'passwordStrengthMedium';
                    } else if (_result < 13) {
                      _strength = 'passwordStrengthStrong';
                    } else {
                      _strength = 'passwordStrengthVeryStrong';
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
