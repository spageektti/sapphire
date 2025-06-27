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

class PerimeterOfRectangleWidget extends StatefulWidget {
  const PerimeterOfRectangleWidget({super.key});

  @override
  _PerimeterOfRectangleWidgetState createState() =>
      _PerimeterOfRectangleWidgetState();
}

class _PerimeterOfRectangleWidgetState
    extends State<PerimeterOfRectangleWidget> {
  List<String> _settings = ['18'];
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  BigInt _length = BigInt.zero;
  BigInt _width = BigInt.zero;
  String _perimeter = "0";

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'perimeterOfRectangleSettings';
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

  String perimeterOfRectangle(BigInt length, BigInt width) {
    final l = length.toDouble();
    final w = width.toDouble();
    final p = 2 * (l + w);
    return p
        .toStringAsFixed(10)
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('perimeterOfRectangleLongName')),
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
                        pageName: 'perimeterOfRectangle',
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
                      name: context.tr('perimeterOfRectangleLongName'),
                      description:
                          context.tr('perimeterOfRectangleLongDescription'),
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
                _perimeter,
                style: const TextStyle(fontSize: 24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 8),
              child: TextField(
                controller: _lengthController,
                maxLength: int.parse(_settings[0]),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: context.tr("perimeterOfRectangleLengthLabel"),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onChanged: (value) {
                  setState(() {
                    _length = BigInt.tryParse(value) ?? BigInt.zero;
                    _perimeter = perimeterOfRectangle(_length, _width);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 8),
              child: TextField(
                controller: _widthController,
                maxLength: int.parse(_settings[0]),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: context.tr("perimeterOfRectangleWidthLabel"),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onChanged: (value) {
                  setState(() {
                    _width = BigInt.tryParse(value) ?? BigInt.zero;
                    _perimeter = perimeterOfRectangle(_length, _width);
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
