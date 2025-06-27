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

class WindowsCsdVersionWidget extends StatefulWidget {
  const WindowsCsdVersionWidget({super.key});

  @override
  _WindowsCsdVersionWidgetState createState() =>
      _WindowsCsdVersionWidgetState();
}

class _WindowsCsdVersionWidgetState extends State<WindowsCsdVersionWidget> {
  String _csdVersion = '';

  Future<void> getWindowsCsdVersion() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
      setState(() {
        _csdVersion = windowsInfo.csdVersion;
      });
    } catch (e) {
      setState(() {
        _csdVersion =
            context.tr('unknownOrNotWindowsNotice'); // Indicate an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_csdVersion.isEmpty) getWindowsCsdVersion();
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('windowsCsdVersionLongName')),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => InfoModalBottomSheet(
                      name: context.tr('windowsCsdVersionLongName'),
                      description:
                          context.tr('windowsCsdVersionLongDescription'),
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
              _csdVersion.isEmpty
                  ? context.tr('unknownOrNotWindowsNotice')
                  : _csdVersion,
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
