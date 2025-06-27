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

class AreaOfTrapezoidWidget extends StatefulWidget {
  const AreaOfTrapezoidWidget({super.key});

  @override
  _AreaOfTrapezoidWidgetState createState() => _AreaOfTrapezoidWidgetState();
}

class _AreaOfTrapezoidWidgetState extends State<AreaOfTrapezoidWidget> {
  List<String> _settings = ['18'];
  final TextEditingController _baseAController = TextEditingController();
  final TextEditingController _baseBController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  BigInt _baseA = BigInt.zero;
  BigInt _baseB = BigInt.zero;
  BigInt _height = BigInt.zero;
  BigInt _area = BigInt.zero;

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'areaOfTrapezoidSettings';
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

  BigInt areaOfTrapezoid(BigInt a, BigInt b, BigInt h) {
    return ((a + b) * h) ~/ BigInt.two;
  }

  void _updateArea() {
    setState(() {
      _baseA = BigInt.tryParse(_baseAController.text) ?? BigInt.zero;
      _baseB = BigInt.tryParse(_baseBController.text) ?? BigInt.zero;
      _height = BigInt.tryParse(_heightController.text) ?? BigInt.zero;
      _area = areaOfTrapezoid(_baseA, _baseB, _height);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('areaOfTrapezoidLongName')),
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
                        pageName: 'areaOfTrapezoid',
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
                      name: context.tr('areaOfTrapezoidLongName'),
                      description: context.tr('areaOfTrapezoidLongDescription'),
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
                context.tr("areaResultLabel", namedArgs: {"result": "$_area"}),
                style: const TextStyle(fontSize: 24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 8),
              child: TextField(
                controller: _baseAController,
                maxLength: int.parse(_settings[0]),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: context.tr("areaOfTrapezoidBaseALabel"),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onChanged: (_) => _updateArea(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 8),
              child: TextField(
                controller: _baseBController,
                maxLength: int.parse(_settings[0]),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: context.tr("areaOfTrapezoidBaseBLabel"),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onChanged: (_) => _updateArea(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 8),
              child: TextField(
                controller: _heightController,
                maxLength: int.parse(_settings[0]),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: context.tr("areaOfTrapezoidHeightLabel"),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onChanged: (_) => _updateArea(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
