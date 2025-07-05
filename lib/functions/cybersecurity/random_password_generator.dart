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
import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:sapphire/widgets/settings_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sapphire/widgets/info_modal_bottom_sheet.dart';
import 'package:flutter/services.dart';

class RandomPasswordGeneratorWidget extends StatefulWidget {
  const RandomPasswordGeneratorWidget({super.key});

  @override
  State<RandomPasswordGeneratorWidget> createState() =>
      _RandomPasswordGeneratorWidgetState();
}

class _RandomPasswordGeneratorWidgetState
    extends State<RandomPasswordGeneratorWidget> {
  List<String> _settings = ['16', 'true', 'true', 'true', 'true'];
  final TextEditingController _lengthController =
      TextEditingController(text: '16');
  bool _useUpper = true;
  bool _useLower = true;
  bool _useDigits = true;
  bool _useSymbols = true;
  String? _password;

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'randomPasswordSettings';
    final values = prefs.getStringList(key);
    setState(() {
      if (values != null && values.length == 5) {
        _settings = values;
        _lengthController.text = _settings[0];
        _useUpper = _settings[1] == 'true';
        _useLower = _settings[2] == 'true';
        _useDigits = _settings[3] == 'true';
        _useSymbols = _settings[4] == 'true';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _generatePassword();
  }

  void _generatePassword() {
    final int? length =
        int.tryParse(_lengthController.text) ?? int.tryParse(_settings[0]);
    if (length == null || length < 1) {
      setState(() {
        _password = null;
      });
      return;
    }
    String upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    String lower = 'abcdefghijklmnopqrstuvwxyz';
    String digits = '0123456789';
    String symbols = '!@#\$%^&*()-_=+[]{}|;:,.<>?/~';
    String chars = '';
    if (_useUpper) chars += upper;
    if (_useLower) chars += lower;
    if (_useDigits) chars += digits;
    if (_useSymbols) chars += symbols;
    if (chars.isEmpty) {
      setState(() {
        _password = null;
      });
      return;
    }
    final rng = Random.secure();
    setState(() {
      _password =
          List.generate(length, (index) => chars[rng.nextInt(chars.length)])
              .join();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('randomPasswordLongName')),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (context) => const SettingsWidget(
                        settings: [
                          'length',
                          'useUpper',
                          'useLower',
                          'useDigits',
                          'useSymbols',
                        ],
                        defaultValues: ['16', 'true', 'true', 'true', 'true'],
                        possibleValues: [[], ['true', 'false'], ['true', 'false'], ['true', 'false'], ['true', 'false'],],
                        pageName: 'randomPassword',
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
                      name: context.tr('randomPasswordLongName'),
                      description: context.tr('randomPasswordLongDescription'),
                      author: 'Wiktor Perskawiec (spageektti)',
                      authorUrl: 'https://spageektti.cc'));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _lengthController,
              decoration: InputDecoration(labelText: context.tr('length')),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              onChanged: (_) => setState(() {}),
            ),
            Row(
              children: [
                Checkbox(
                  value: _useUpper,
                  onChanged: (val) => setState(() => _useUpper = val ?? true),
                ),
                Text(context.tr('useUpper')),
                Checkbox(
                  value: _useLower,
                  onChanged: (val) => setState(() => _useLower = val ?? true),
                ),
                Text(context.tr('useLower')),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: _useDigits,
                  onChanged: (val) => setState(() => _useDigits = val ?? true),
                ),
                Text(context.tr('useDigits')),
                Checkbox(
                  value: _useSymbols,
                  onChanged: (val) => setState(() => _useSymbols = val ?? true),
                ),
                Text(context.tr('useSymbols')),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _generatePassword,
              child: Text(context.tr('generateButtonLabel')),
            ),
            const SizedBox(height: 24),
            if (_password != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectableText(
                    context.tr('randomPasswordResultLabel',
                        namedArgs: {'result': _password!}),
                    style: const TextStyle(fontSize: 24),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _password!));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(context.tr('copiedToClipboard'))),
                      );
                    },
                  ),
                ],
              ),
            if (_password == null)
              Text(
                context.tr('randomPasswordErrorMessage'),
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
