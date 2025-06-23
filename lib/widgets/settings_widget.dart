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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsWidget extends StatefulWidget {
  final List<String> settings;
  final List<String> defaultValues;
  final String pageName;

  const SettingsWidget(
      {super.key,
      required this.settings,
      required this.defaultValues,
      required this.pageName});

  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  List<String> _currentValues = [];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${widget.pageName}Settings';
    final values = prefs.getStringList(key);
    setState(() {
      _currentValues = values ?? List<String>.from(widget.defaultValues);
    });
    _loaded = true;
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${widget.pageName}Settings';
    await prefs.setStringList(key, _currentValues);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${context.tr("settingsOfFunction")} ${context.tr('${widget.pageName}LongName')}'),
      ),
      body: ListView.builder(
        itemCount: widget.settings.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(context.tr(widget.settings[index])),
            subtitle: Text(widget.defaultValues[index]),
            trailing: _loaded
                ? Text(_currentValues[index],
                    style: const TextStyle(fontSize: 18))
                : const CircularProgressIndicator(),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  final controller =
                      TextEditingController(text: _currentValues[index]);
                  return AlertDialog(
                    title: Text(context.tr('editSetting')),
                    content: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: context.tr(widget.settings[index]),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(context.tr('cancel')),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _currentValues[index] = controller.text;
                          });
                          _saveSettings();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          context.tr('save'),
                        ),
                      )
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
