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
import 'dart:math';

class AreaOfCircleWidget extends StatefulWidget {
  const AreaOfCircleWidget({super.key});

  @override
  _AreaOfCircleWidgetState createState() => _AreaOfCircleWidgetState();
}

class _AreaOfCircleWidgetState extends State<AreaOfCircleWidget> {
  List<String> _settings = ['18'];
  final TextEditingController _radiusController = TextEditingController();
  BigInt _radius = BigInt.zero;
  String _area = "0";

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'areaOfCircleSettings';
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

  String areaOfCircle(BigInt radius) {
    if (radius == BigInt.zero) return "0";
    final r = radius.toDouble();
    final area = pi * r * r;
    return area.toStringAsFixed(10).replaceFirst(RegExp(r'\.?0+$'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('areaOfCircleLongName')),
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
                        pageName: 'areaOfCircle',
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
                      name: context.tr('areaOfCircleLongName'),
                      description: context.tr('areaOfCircleLongDescription'),
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
                context.tr("areaResultLabel", namedArgs: {"result": _area}),
                style: const TextStyle(fontSize: 24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 16),
              child: TextField(
                controller: _radiusController,
                maxLength: int.parse(_settings[0]),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: context.tr("areaOfCircleRadiusLabel"),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onChanged: (value) {
                  setState(() {
                    _radius = BigInt.tryParse(value) ?? BigInt.zero;
                    _area = areaOfCircle(_radius);
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
