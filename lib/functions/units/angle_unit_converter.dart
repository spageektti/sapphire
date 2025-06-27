/*
 * SPDX-FileCopyrightText: 2025 Wiktor Perskawiec <wiktor@perskawiec.cc>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
/*
* Copyright (C) 2025 Wiktor Perskawiec <wiktor@perskawiec.cc>
*
? This program is free software: you can redistribute it and/or modify
? it under the terms of the GNU General Public License as published by
? the Free Software Foundation, either version 3 of the License, or
? (at your option) any later version.
!
! This program is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/
/* 
! To contribute, please read the README.md file in the root of the project.
? It contains important information about the project structure, code style, suggested VSCode extensions, and more.
*/
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sapphire/widgets/settings_widget.dart';
import 'package:sapphire/widgets/info_modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AngleUnitConvertWidget extends StatefulWidget {
  const AngleUnitConvertWidget({super.key});

  @override
  State<AngleUnitConvertWidget> createState() => _AngleUnitConvertWidgetState();
}

class _AngleUnitConvertWidgetState extends State<AngleUnitConvertWidget> {
  List<String> _settings = ['Degree', 'Radian'];
  final List<String> _units = [
    'Degree',
    'Radian',
    'Gradian',
    'AngleMinute',
    'Second',
    'Turn'
  ];
  String _fromUnit = 'Degree';
  String _toUnit = 'Radian';
  double? _inputValue;
  String? _result;

  final TextEditingController _inputController = TextEditingController();

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'angleUnitConvertSettings';
    final values = prefs.getStringList(key);
    setState(() {
      if (values != null && values.length == 2) {
        _settings = values;
      }
      _fromUnit = _settings[0];
      _toUnit = _settings[1];
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  // Conversion factors to degrees
  static const Map<String, double> _toDegree = {
    'Degree': 1.0,
    'Radian': 180.0 / 3.1415926535897932,
    'Gradian': 0.9,
    'AngleMinute': 1.0 / 60.0,
    'Second': 1.0 / 3600.0,
    'Turn': 360.0,
  };

  double _convertAngle(double value, String from, String to) {
    if (from == to) return value;
    double valueInDegrees = value * (_toDegree[from] ?? 1.0);
    return valueInDegrees / (_toDegree[to] ?? 1.0);
  }

  void _updateResult() {
    if (_inputValue == null) {
      setState(() {
        _result = null;
      });
      return;
    }
    final converted = _convertAngle(_inputValue!, _fromUnit, _toUnit);
    setState(() {
      _result =
          "${_inputValue!.toStringAsFixed(6)} ${context.tr(_fromUnit)} = ${converted.toStringAsFixed(6)} ${context.tr(_toUnit)}";
    });
  }

  @override
  Widget build(BuildContext context) {
    String resultText;
    if (_result == null) {
      resultText = context.tr("angleUnitConvertPromptLabel");
    } else {
      resultText = _result!;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('angleUnitConvertLongName')),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => const SettingsWidget(
                    settings: ['fromUnitAngle', 'toUnitAngle'],
                    defaultValues: ['Degree', 'Radian'],
                    pageName: 'angleUnitConvert',
                  ),
                ),
              )
                  .then((_) async {
                await _loadSettings();
                _updateResult();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => InfoModalBottomSheet(
                      name: context.tr('angleUnitConvertLongName'),
                      description:
                          context.tr('angleUnitConvertLongDescription'),
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
                    const EdgeInsets.symmetric(horizontal: 64, vertical: 8),
                child: TextField(
                  controller: _inputController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: context.tr("angleUnitConvertInputLabel"),
                  ),
                  onChanged: (value) {
                    _inputValue = double.tryParse(value);
                    _updateResult();
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 64, vertical: 8),
                child: DropdownButtonFormField<String>(
                  value: _fromUnit,
                  items: _units
                      .map((unit) => DropdownMenuItem(
                            value: unit,
                            child: Text(context.tr(unit)),
                          ))
                      .toList(),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: context.tr("angleUnitConvertFromLabel"),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _fromUnit = value ?? _fromUnit;
                      _updateResult();
                    });
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 64, vertical: 8),
                child: DropdownButtonFormField<String>(
                  value: _toUnit,
                  items: _units
                      .map((unit) => DropdownMenuItem(
                            value: unit,
                            child: Text(context.tr(unit)),
                          ))
                      .toList(),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: context.tr("angleUnitConvertToLabel"),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _toUnit = value ?? _toUnit;
                      _updateResult();
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
