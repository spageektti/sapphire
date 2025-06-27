/*
 * SPDX-FileCopyrightText: 2025 Wiktor Perskawiec <wiktor@perskawiec.cc>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
/*
* Copyright (C) 2025 Wiktor Perskawiec <wiktor@perskawiec.cc>
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
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

class SpeedUnitConvertWidget extends StatefulWidget {
  const SpeedUnitConvertWidget({super.key});

  @override
  State<SpeedUnitConvertWidget> createState() => _SpeedUnitConvertWidgetState();
}

class _SpeedUnitConvertWidgetState extends State<SpeedUnitConvertWidget> {
  List<String> _settings = ['Meter per second', 'Kilometer per hour'];
  final List<String> _units = [
    'Meter per second',
    'Kilometer per hour',
    'Mile per hour',
    'Foot per second',
    'Knot'
  ];
  String _fromUnit = 'Meter per second';
  String _toUnit = 'Kilometer per hour';
  double? _inputValue;
  String? _result;

  final TextEditingController _inputController = TextEditingController();

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'speedUnitConvertSettings';
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

  // Conversion factors to meters per second
  static const Map<String, double> _toMps = {
    'Meter per second': 1.0,
    'Kilometer per hour': 0.277777778,
    'Mile per hour': 0.44704,
    'Foot per second': 0.3048,
    'Knot': 0.514444,
  };

  double _convertSpeed(double value, String from, String to) {
    if (from == to) return value;
    double valueInMps = value * (_toMps[from] ?? 1.0);
    return valueInMps / (_toMps[to] ?? 1.0);
  }

  void _updateResult() {
    if (_inputValue == null) {
      setState(() {
        _result = null;
      });
      return;
    }
    final converted = _convertSpeed(_inputValue!, _fromUnit, _toUnit);
    setState(() {
      _result =
          "${_inputValue!.toStringAsFixed(4)} ${context.tr(_fromUnit)} = ${converted.toStringAsFixed(4)} ${context.tr(_toUnit)}";
    });
  }

  @override
  Widget build(BuildContext context) {
    String resultText;
    if (_result == null) {
      resultText = context.tr("speedUnitConvertPromptLabel");
    } else {
      resultText = _result!;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('speedUnitConvertLongName')),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => const SettingsWidget(
                    settings: ['fromUnitSpeed', 'toUnitSpeed'],
                    defaultValues: ['Meter per second', 'Kilometer per hour'],
                    pageName: 'speedUnitConvert',
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
                      name: context.tr('speedUnitConvertLongName'),
                      description:
                          context.tr('speedUnitConvertLongDescription'),
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
                    labelText: context.tr("speedUnitConvertInputLabel"),
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
                    labelText: context.tr("speedUnitConvertFromLabel"),
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
                    labelText: context.tr("speedUnitConvertToLabel"),
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
