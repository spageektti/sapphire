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
import 'package:device_info_plus/device_info_plus.dart';
import 'package:sapphire/widgets/info_modal_bottom_sheet.dart';

class MacOSKernelVersionWidget extends StatefulWidget {
  const MacOSKernelVersionWidget({super.key});

  @override
  _MacOSKernelVersionWidgetState createState() =>
      _MacOSKernelVersionWidgetState();
}

class _MacOSKernelVersionWidgetState extends State<MacOSKernelVersionWidget> {
  String _kernelVersion = "";

  Future<void> getMacOSKernelVersion() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      MacOsDeviceInfo macInfo = await deviceInfo.macOsInfo;
      setState(() {
        _kernelVersion = macInfo.kernelVersion;
      });
    } catch (e) {
      setState(() {
        _kernelVersion = context.tr('unknownOrNotMacOSNotice');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_kernelVersion == "") getMacOSKernelVersion();
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('macOSKernelVersionLongName')),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => InfoModalBottomSheet(
                      name: context.tr('macOSKernelVersionLongName'),
                      description:
                          context.tr('macOSKernelVersionLongDescription'),
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
            Text(_kernelVersion, style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
