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

class IsPhysicalDeviceWidget extends StatefulWidget {
  const IsPhysicalDeviceWidget({super.key});

  @override
  _IsPhysicalDeviceWidgetState createState() => _IsPhysicalDeviceWidgetState();
}

class _IsPhysicalDeviceWidgetState extends State<IsPhysicalDeviceWidget> {
  String _isPhysicalDevice = "";

  Future<void> checkIfPhysicalDevice() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setState(() {
        _isPhysicalDevice =
            androidInfo.isPhysicalDevice ? context.tr('yes') : context.tr('no');
      });
    } catch (e) {
      setState(() {
        _isPhysicalDevice = context.tr('unknownOrNotAndroidNotice');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isPhysicalDevice == "") checkIfPhysicalDevice();
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('isPhysicalDeviceLongName')),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => InfoModalBottomSheet(
                      name: context.tr('isPhysicalDeviceLongName'),
                      description:
                          context.tr('isPhysicalDeviceLongDescription'),
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
            Text(_isPhysicalDevice, style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
