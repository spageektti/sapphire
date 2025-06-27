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
import 'package:easy_localization/easy_localization.dart';
import 'package:sapphire/widgets/settings_widget.dart';
import 'package:sapphire/widgets/info_modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VolumeUnitConvertWidget extends StatefulWidget {
  const VolumeUnitConvertWidget({super.key});

  @override
  State<VolumeUnitConvertWidget> createState() =>
      _VolumeUnitConvertWidgetState();
}

class _VolumeUnitConvertWidgetState extends State<VolumeUnitConvertWidget> {
  List<String> _settings = ['Liter', 'Cubic meter'];
  final List<String> _units = [
    'Milliliter',
    'Centiliter',
    'Deciliter',
    'Liter',
    'Cubic decimeter',
    'Cubic meter',
    'Cubic centimeter',
    'Cubic millimeter',
    'Cubic inch',
    'Cubic foot',
    'Cubic yard',
    'US gallon',
    'US quart',
    'US pint',
    'US cup',
    'US fluid ounce',
    'Imperial gallon',
    'Imperial quart',
    'Imperial pint',
    'Imperial cup',
    'Imperial fluid ounce',
  ];
  String _fromUnit = 'Liter';
  String _toUnit = 'Cubic meter';
  double? _inputValue;
  String? _result;

  final TextEditingController _inputController = TextEditingController();

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'volumeUnitConvertSettings';
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

  // Conversion factors to liters
  static const Map<String, double> _toLiter = {
    'Milliliter': 0.001,
    'Centiliter': 0.01,
    'Deciliter': 0.1,
    'Liter': 1.0,
    'Cubic decimeter': 1.0,
    'Cubic meter': 1000.0,
    'Cubic centimeter': 0.001,
    'Cubic millimeter': 0.000001,
    'Cubic inch': 0.016387064,
    'Cubic foot': 28.316846592,
    'Cubic yard': 764.554857984,
    'US gallon': 3.785411784,
    'US quart': 0.946352946,
    'US pint': 0.473176473,
    'US cup': 0.2365882365,
    'US fluid ounce': 0.0295735295625,
    'Imperial gallon': 4.54609,
    'Imperial quart': 1.1365225,
    'Imperial pint': 0.56826125,
    'Imperial cup': 0.284130625,
    'Imperial fluid ounce': 0.0284130625,
  };

  double _convertVolume(double value, String from, String to) {
    if (from == to) return value;
    double valueInLiters = value * (_toLiter[from] ?? 1.0);
    return valueInLiters / (_toLiter[to] ?? 1.0);
  }

  void _updateResult() {
    if (_inputValue == null) {
      setState(() {
        _result = null;
      });
      return;
    }
    final converted = _convertVolume(_inputValue!, _fromUnit, _toUnit);
    setState(() {
      _result =
          "${_inputValue!.toStringAsFixed(4)} ${context.tr(_fromUnit)} = ${converted.toStringAsFixed(4)} ${context.tr(_toUnit)}";
    });
  }

  @override
  Widget build(BuildContext context) {
    String resultText;
    if (_result == null) {
      resultText = context.tr("volumeUnitConvertPromptLabel");
    } else {
      resultText = _result!;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('volumeUnitConvertLongName')),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => const SettingsWidget(
                    settings: ['fromUnitVolume', 'toUnitVolume'],
                    defaultValues: ['Liter', 'Cubic meter'],
                    pageName: 'volumeUnitConvert',
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
                      name: context.tr('volumeUnitConvertLongName'),
                      description:
                          context.tr('volumeUnitConvertLongDescription'),
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
                    labelText: context.tr("volumeUnitConvertInputLabel"),
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
                    labelText: context.tr("volumeUnitConvertFromLabel"),
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
                    labelText: context.tr("volumeUnitConvertToLabel"),
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
