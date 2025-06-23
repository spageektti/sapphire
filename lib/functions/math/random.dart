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
! To contribute, please read the CONTRIBUTING.md file in the root of the project.
? It contains important information about the project structure, code style, suggested VSCode extensions, and more.
*/
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:sapphire/widgets/settings_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sapphire/widgets/info_modal_bottom_sheet.dart';
import 'package:flutter/services.dart';

class RandomNumberWidget extends StatefulWidget {
  const RandomNumberWidget({super.key});

  @override
  State<RandomNumberWidget> createState() => _RandomNumberWidgetState();
}

class _RandomNumberWidgetState extends State<RandomNumberWidget> {
  List<String> _settings = ['1', '100', ''];
  final TextEditingController _minController = TextEditingController(text: '1');
  final TextEditingController _maxController =
      TextEditingController(text: '100');
  final TextEditingController _seedController = TextEditingController();
  int? _randomNumber;

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'randomSettings';
    final values = prefs.getStringList(key);
    setState(() {
      if (values != null && values.isNotEmpty) {
        _settings = values;
        _minController.text = _settings[0];
        _maxController.text = _settings[1];
        _seedController.text = _settings[2];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _generateRandomNumber();
  }

  void _generateRandomNumber() {
    final int? min =
        int.tryParse(_minController.text) ?? int.tryParse(_settings[0]);
    final int? max =
        int.tryParse(_maxController.text) ?? int.tryParse(_settings[1]);
    final int? seed = int.tryParse(_seedController.text) ??
        (_settings[2].isNotEmpty ? int.tryParse(_settings[2]) : null);

    if (min == null || max == null || min > max) {
      setState(() {
        _randomNumber = null;
      });
      return;
    }

    final rng = seed != null ? Random(seed) : Random();
    setState(() {
      _randomNumber = min + rng.nextInt(max - min + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('randomLongName')),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (context) => const SettingsWidget(
                        settings: [
                          'min',
                          'max',
                          'seed',
                        ],
                        defaultValues: ['1', '100', ''],
                        pageName: 'random',
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
                      name: context.tr('randomLongName'),
                      description: context.tr('randomLongDescription'),
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
              controller: _minController,
              decoration: InputDecoration(labelText: context.tr('min')),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            TextField(
              controller: _maxController,
              decoration: InputDecoration(labelText: context.tr('max')),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            TextField(
              controller: _seedController,
              decoration: InputDecoration(labelText: context.tr('seed')),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _generateRandomNumber,
              child: Text(context.tr('generateButtonLabel')),
            ),
            const SizedBox(height: 24),
            if (_randomNumber != null)
              Text(
                context.tr("randomResultLabel",
                    namedArgs: {"result": "$_randomNumber"}),
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            if (_randomNumber == null)
              Text(
                context.tr('randomErrorMessage'),
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
