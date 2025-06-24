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
import 'package:easy_localization/easy_localization.dart';
import 'package:sapphire/widgets/settings_widget.dart';
import 'package:sapphire/widgets/info_modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

class TimezoneWidget extends StatefulWidget {
  const TimezoneWidget({super.key});

  @override
  State<TimezoneWidget> createState() => _TimezoneWidgetState();
}

class _TimezoneWidgetState extends State<TimezoneWidget> {
  List<String> _settings = ['UTC', 'Europe/Warsaw'];
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  String _fromTz = 'UTC';
  String _toTz = 'Europe/Warsaw';
  tz.TZDateTime? _inputTzDateTime;
  String? _convertedTime;

  late List<String> _timezones;

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'timezoneSettings';
    final values = prefs.getStringList(key);
    setState(() {
      if (values != null && values.length == 2) {
        _settings = values;
      }
      _fromTz = _settings[0];
      _toTz = _settings[1];
    });
  }

  @override
  void initState() {
    super.initState();
    tzdata.initializeTimeZones();
    _dateController = TextEditingController();
    _timeController = TextEditingController();
    _timezones = tz.timeZoneDatabase.locations.keys.toList()..sort();
    _loadSettings();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _convert() {
    if (_inputTzDateTime == null) {
      setState(() {
        _convertedTime = null;
      });
      return;
    }
    try {
      final toLocation = tz.getLocation(_toTz);
      final converted = tz.TZDateTime.from(_inputTzDateTime!, toLocation);
      setState(() {
        _convertedTime =
            DateFormat('yyyy-MM-dd HH:mm:ss').format(converted) + ' ($_toTz)';
      });
    } catch (e) {
      setState(() {
        _convertedTime = 'Invalid timezone';
      });
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _inputTzDateTime?.toLocal() ?? now,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final fromLocation = tz.getLocation(_fromTz);
      final hour = _inputTzDateTime?.hour ?? 0;
      final minute = _inputTzDateTime?.minute ?? 0;
      _inputTzDateTime = tz.TZDateTime(
        fromLocation,
        picked.year,
        picked.month,
        picked.day,
        hour,
        minute,
      );
      _dateController.text = DateFormat('yyyy-MM-dd').format(_inputTzDateTime!);
      _convert();
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _inputTzDateTime != null
          ? TimeOfDay(
              hour: _inputTzDateTime!.hour, minute: _inputTzDateTime!.minute)
          : TimeOfDay.now(),
    );
    if (picked != null) {
      final fromLocation = tz.getLocation(_fromTz);
      final date = _inputTzDateTime ?? tz.TZDateTime.now(fromLocation);
      _inputTzDateTime = tz.TZDateTime(
        fromLocation,
        date.year,
        date.month,
        date.day,
        picked.hour,
        picked.minute,
      );
      _timeController.text = picked.format(context);
      _convert();
    }
  }

  @override
  Widget build(BuildContext context) {
    String resultText;
    if (_convertedTime == null) {
      resultText = context.tr("timezonePromptLabel");
    } else {
      resultText = _convertedTime!;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('timezoneLongName')),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => const SettingsWidget(
                    settings: ['defaultFromTimezone', 'defaultToTimezone'],
                    defaultValues: ['UTC', 'Europe/Warsaw'],
                    pageName: 'timezone',
                  ),
                ),
              )
                  .then((_) async {
                await _loadSettings();
                if (_inputTzDateTime != null) {
                  final fromLocation = tz.getLocation(_fromTz);
                  _inputTzDateTime = tz.TZDateTime(
                    fromLocation,
                    _inputTzDateTime!.year,
                    _inputTzDateTime!.month,
                    _inputTzDateTime!.day,
                    _inputTzDateTime!.hour,
                    _inputTzDateTime!.minute,
                  );
                }
                _convert();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => InfoModalBottomSheet(
                      name: context.tr('timezoneLongName'),
                      description: context.tr('timezoneLongDescription'),
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
                  controller: _dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: context.tr("timezoneDateInputLabel"),
                  ),
                  onTap: () => _pickDate(context),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 64, vertical: 8),
                child: TextField(
                  controller: _timeController,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: context.tr("timezoneTimeInputLabel"),
                  ),
                  onTap: () => _pickTime(context),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 64, vertical: 8),
                child: DropdownButtonFormField<String>(
                  value: _fromTz,
                  items: _timezones
                      .map((tzName) => DropdownMenuItem(
                            value: tzName,
                            child: Text(tzName),
                          ))
                      .toList(),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: context.tr("timezoneFromInputLabel"),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _fromTz = value ?? _fromTz;

                      if (_inputTzDateTime != null) {
                        final fromLocation = tz.getLocation(_fromTz);
                        _inputTzDateTime = tz.TZDateTime(
                          fromLocation,
                          _inputTzDateTime!.year,
                          _inputTzDateTime!.month,
                          _inputTzDateTime!.day,
                          _inputTzDateTime!.hour,
                          _inputTzDateTime!.minute,
                        );
                      }
                      _convert();
                    });
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 64, vertical: 8),
                child: DropdownButtonFormField<String>(
                  value: _toTz,
                  items: _timezones
                      .map((tzName) => DropdownMenuItem(
                            value: tzName,
                            child: Text(tzName),
                          ))
                      .toList(),
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: context.tr("timezoneToInputLabel"),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _toTz = value ?? _toTz;
                      _convert();
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
