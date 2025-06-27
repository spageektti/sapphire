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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sapphire/widgets/info_modal_bottom_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sapphire/widgets/settings_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DivisorsWidget extends StatefulWidget {
  const DivisorsWidget({super.key});

  @override
  _DivisorsWidgetState createState() => _DivisorsWidgetState();
}

class _DivisorsWidgetState extends State<DivisorsWidget> {
  List<String> _settings = ['10'];

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'divisorsSettings';
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

  List<BigInt> findDivisors(BigInt n) {
    if (n <= BigInt.zero) return [];
    Set<BigInt> divisors = {};
    BigInt i = BigInt.one;
    while (i * i <= n) {
      if (n % i == BigInt.zero) {
        divisors.add(i);
        divisors.add(n ~/ i);
      }
      i += BigInt.one;
    }
    List<BigInt> result = divisors.toList();
    result.sort();
    return result;
  }

  BigInt _n = BigInt.zero;
  List<BigInt> _result = [];

  @override
  Widget build(BuildContext context) {
    String resultText;
    if (_n == BigInt.zero) {
      resultText = context.tr("divisorsPromptLabel");
    } else if (_result.isEmpty) {
      resultText =
          context.tr("divisorsNoneLabel", namedArgs: {"number": "$_n"});
    } else {
      resultText = _result.map((divisor) => divisor.toString()).join(', ');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('divisorsLongName')),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (context) => const SettingsWidget(
                        settings: ['maxDigits'],
                        defaultValues: ['10'],
                        pageName: 'divisors',
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
                      name: context.tr('divisorsLongName'),
                      description: context.tr('divisorsLongDescription'),
                      author: 'Wiktor Perskawiec (spageektti)',
                      authorUrl: 'https://spageektti.cc'));
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Text(
                  resultText,
                  style: const TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 64, vertical: 16),
                child: TextField(
                  maxLength: int.parse(_settings[0]),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: context.tr("divisorsInputLabel"),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (value) {
                    setState(() {
                      _n = BigInt.tryParse(value) ?? BigInt.zero;
                      _result = findDivisors(_n);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
