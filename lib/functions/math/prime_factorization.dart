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
import 'package:flutter_math_fork/flutter_math.dart';

class PrimeFactorizationWidget extends StatefulWidget {
  const PrimeFactorizationWidget({super.key});

  @override
  _PrimeFactorizationWidgetState createState() =>
      _PrimeFactorizationWidgetState();
}

class _PrimeFactorizationWidgetState extends State<PrimeFactorizationWidget> {
  List<String> _settings = ['10', 'false'];

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'primeFactorizationSettings';
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

  List<BigInt> primeFactors(BigInt n) {
    List<BigInt> factors = [];
    if (n < BigInt.two) return factors;
    BigInt num = n;

    while (num.isEven) {
      factors.add(BigInt.two);
      num ~/= BigInt.two;
    }

    BigInt i = BigInt.from(3);
    while (i * i <= num) {
      while (num % i == BigInt.zero) {
        factors.add(i);
        num ~/= i;
      }
      i += BigInt.two;
    }

    if (num > BigInt.one) {
      factors.add(num);
    }

    return factors;
  }

  BigInt _n = BigInt.zero;
  List<BigInt> _result = [];
  bool _isMath = false;

  @override
  Widget build(BuildContext context) {
    String resultText;
    if (_n == BigInt.zero) {
      resultText = context.tr("primeFactorizationPromptLabel");
      _isMath = false;
    } else if (_result.isEmpty) {
      resultText = context
          .tr("primeFactorizationNoneLabel", namedArgs: {"number": "$_n"});
      _isMath = false;
    } else {
      if (_settings[1] == 'false') {
        resultText = "$_n = ${_result.map((f) => f.toString()).join(' × ')}";
      } else {
        final Map<BigInt, int> factorCounts = {};
        for (final f in _result) {
          factorCounts[f] = (factorCounts[f] ?? 0) + 1;
        }
        final powerForm = factorCounts.entries
            .map((e) => e.value > 1 ? "${e.key}^${e.value}" : "${e.key}")
            .join(' × ');
        resultText = "$_n = $powerForm";
      }
      _isMath = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('primeFactorizationLongName')),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (context) => const SettingsWidget(
                        settings: ['maxDigits', 'showInPowerForm'],
                        defaultValues: ['10', 'false'],
                        pageName: 'primeFactorization',
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
                      name: context.tr('primeFactorizationLongName'),
                      description:
                          context.tr('primeFactorizationLongDescription'),
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
                child: _isMath
                    ? Math.tex(resultText,
                        textStyle: const TextStyle(fontSize: 24))
                    : Text(resultText, style: const TextStyle(fontSize: 24)),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 64, vertical: 16),
                child: TextField(
                  maxLength: int.parse(_settings[0]),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: context.tr("primeFactorizationInputLabel"),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (value) {
                    setState(() {
                      _n = BigInt.tryParse(value) ?? BigInt.zero;
                      _result = primeFactors(_n);
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
