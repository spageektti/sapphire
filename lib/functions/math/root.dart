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
! To contribute, please read the CONTRIBUTING.md file in the root of the project.
? It contains important information about the project structure, code style, suggested VSCode extensions, and more.
*/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sapphire/widgets/info_modal_bottom_sheet.dart';
import 'package:sapphire/widgets/settings_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RootWidget extends StatefulWidget {
  const RootWidget({super.key});

  @override
  _RootWidgetState createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
  List<String> _settings = ['18'];

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'rootSettings';
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

  String root(BigInt a, BigInt b) {
    if (b == BigInt.zero) {
      return '';
    }

    Decimal low = Decimal.zero;
    Decimal high = Decimal.fromBigInt(a);
    Decimal mid;
    Decimal epsilon = Decimal.parse('0.0000000000000001');

    while ((high - low).abs() > epsilon) {
      mid = ((low + high) / Decimal.fromInt(2)).toDecimal();
      Decimal midPow = decimalPow(mid, b.toInt());

      if (midPow < Decimal.fromBigInt(a)) {
        low = mid;
      } else {
        high = mid;
      }
    }

    Decimal result = ((low + high) / Decimal.fromInt(2)).toDecimal();
    String resultString = result.toStringAsFixed(11);
    resultString = resultString.replaceAll(RegExp(r'0+$'), '');
    if (resultString.endsWith('.')) {
      resultString = '= ${resultString.substring(0, resultString.length - 1)}';
    } else {
      resultString = '≈ $resultString';
    }
    return resultString;
  }

  Decimal decimalPow(Decimal base, int exp) {
    Decimal result = Decimal.one;
    while (exp > 0) {
      if (exp % 2 == 1) {
        result *= base;
      }
      base *= base;
      exp ~/= 2;
    }
    return result;
  }

  BigInt _a = BigInt.zero;
  BigInt _b = BigInt.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('rootLongName')),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (context) => const SettingsWidget(
                        settings: ['maxDigits'],
                        defaultValues: ['18'],
                        pageName: 'root',
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
                      name: context.tr('rootLongName'),
                      description: context.tr('rootLongDescription'),
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
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                children: [
                  Math.tex(
                      r'\sqrt[' + _b.toString() + r']{' + _a.toString() + r'}',
                      mathStyle: MathStyle.display,
                      textStyle: const TextStyle(fontSize: 24)),
                  Text(root(_a, _b), style: const TextStyle(fontSize: 24)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 16),
              child: TextField(
                maxLength: int.parse(_settings[0]),
                decoration: InputDecoration(
                  labelText: context.tr('rootFirstButtonLabel'),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(
                      26) // TODO: Add ability to change this in the settings
                ],
                onChanged: (value) {
                  setState(() {
                    _a = BigInt.tryParse(value) ?? BigInt.zero;
                    if (_a == BigInt.zero) {
                      _a = BigInt.one;
                    }
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 16),
              child: TextField(
                maxLength: int.parse(_settings[0]),
                decoration: InputDecoration(
                  labelText: context.tr('rootSecondButtonLabel'),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(
                      2), // TODO: Add ability to change this in the settings
                ],
                onChanged: (value) {
                  setState(() {
                    _b = BigInt.tryParse(value) ?? BigInt.zero;
                    if (_b == BigInt.zero) {
                      _b = BigInt.one;
                    }
                    if (_b > BigInt.from(20)) {
                      _b = BigInt.from(
                          20); // TODO: Add ability to change this in the settings
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
