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

class FibonacciWidget extends StatefulWidget {
  const FibonacciWidget({super.key});

  @override
  _FibonacciWidgetState createState() => _FibonacciWidgetState();
}

class _FibonacciWidgetState extends State<FibonacciWidget> {
  List<String> _settings = ['10', '0'];

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'fibonacciSettings';
    final values = prefs.getStringList(key);
    setState(() {
      if (values != null && values.length == 2) {
        _settings = values;
      }
    });
    _countController.text = _settings[0];
    _startController.text = _settings[1];
    _count = int.tryParse(_settings[0]) ?? 10;
    _start = int.tryParse(_settings[1]) ?? 0;
    _updateResult();
  }

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  final TextEditingController _countController = TextEditingController();
  final TextEditingController _startController = TextEditingController();

  List<BigInt> fibonacci(int count, int start) {
    List<BigInt> fibs = [];
    if (count <= 0) return fibs;
    BigInt a = BigInt.zero, b = BigInt.one;
    for (int i = 0; i < start + count; i++) {
      if (i >= start) fibs.add(a);
      BigInt next = a + b;
      a = b;
      b = next;
    }
    return fibs;
  }

  int _count = 10;
  int _start = 0;
  List<BigInt> _result = [];

  void _updateResult() {
    setState(() {
      _result = fibonacci(_count, _start);
    });
  }

  @override
  Widget build(BuildContext context) {
    String resultText;
    if (_result.isEmpty) {
      resultText = context.tr("fibonacciPromptLabel");
    } else {
      resultText = _result.map((fib) => fib.toString()).join(', ');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('fibonacciLongName')),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => const SettingsWidget(
                    settings: ['count', 'start'],
                    defaultValues: ['10', '0'],
                    pageName: 'fibonacci',
                  ),
                ),
              )
                  .then((_) async {
                await _loadSettings();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => InfoModalBottomSheet(
                      name: context.tr('fibonacciLongName'),
                      description: context.tr('fibonacciLongDescription'),
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
                resultText,
                style: const TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 8),
              child: TextField(
                controller: _countController,
                maxLength: 4,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: context.tr("fibonacciCountInputLabel"),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onChanged: (value) {
                  _count = int.tryParse(value) ?? 0;
                  _updateResult();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 8),
              child: TextField(
                controller: _startController,
                maxLength: 4,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: context.tr("fibonacciStartInputLabel"),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onChanged: (value) {
                  _start = int.tryParse(value) ?? 0;
                  _updateResult();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
