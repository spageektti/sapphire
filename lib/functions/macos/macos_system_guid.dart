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
! To contribute, please read the README.md file in the root of the project.
? It contains important information about the project structure, code style, suggested VSCode extensions, and more.
*/
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sapphire/widgets/info_modal_bottom_sheet.dart';
import 'package:device_info_plus/device_info_plus.dart';

class MacOSSystemGuidWidget extends StatefulWidget {
  const MacOSSystemGuidWidget({super.key});

  @override
  _MacOSSystemGuidWidgetState createState() => _MacOSSystemGuidWidgetState();
}

class _MacOSSystemGuidWidgetState extends State<MacOSSystemGuidWidget> {
  String _systemGuid = "";

  Future<void> getMacOSSystemGuid() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      MacOsDeviceInfo macInfo = await deviceInfo.macOsInfo;
      setState(() {
        _systemGuid = macInfo.systemGUID.toString();
      });
    } catch (e) {
      setState(() {
        _systemGuid = context.tr('unknownOrNotMacOSNotice');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_systemGuid == "") getMacOSSystemGuid();
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('macOSSystemGuidLongName')),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => InfoModalBottomSheet(
                      name: context.tr('macOSSystemGuidLongName'),
                      description: context.tr('macOSSystemGuidLongDescription'),
                      author: 'Wiktor Perskawiec (spageektti)',
                      authorUrl: 'https://spageektti.cc'));
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_systemGuid, style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
