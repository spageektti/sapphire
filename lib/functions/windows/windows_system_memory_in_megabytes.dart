/*
 * SPDX-FileCopyrightText: 2024 Wiktor Perskawiec <contact@spageektti.cc>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
/*
* Copyright (C) 2024 Wiktor Perskawiec <contact@spageektti.cc>

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
import 'package:sapphire/widgets/info_modal_bottom_sheet.dart';
import 'package:device_info_plus/device_info_plus.dart';

class WindowsSystemMemoryWidget extends StatefulWidget {
  const WindowsSystemMemoryWidget({super.key});

  @override
  _WindowsSystemMemoryWidgetState createState() =>
      _WindowsSystemMemoryWidgetState();
}

class _WindowsSystemMemoryWidgetState extends State<WindowsSystemMemoryWidget> {
  String _systemMemory = '';

  Future<void> getWindowsSystemMemory() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
      setState(() {
        _systemMemory =
            '${(windowsInfo.systemMemoryInMegabytes / 1024).toStringAsFixed(2)} GB';
      });
    } catch (e) {
      setState(() {
        _systemMemory = 'Unknown'; // Indicate an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_systemMemory.isEmpty) getWindowsSystemMemory();
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('windowsSystemMemoryLongName')),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => InfoModalBottomSheet(
                      name: context.tr('windowsSystemMemoryLongName'),
                      description:
                          context.tr('windowsSystemMemoryLongDescription'),
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
            Text(
              _systemMemory.isEmpty
                  ? context.tr('unknownOrNotWindowsNotice')
                  : _systemMemory,
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
