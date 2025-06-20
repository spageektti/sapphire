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
import 'package:sapphire/widgets/info_modal_bottom_sheet.dart';
import 'package:device_info_plus/device_info_plus.dart';

class Supported32BitAbisWidget extends StatefulWidget {
  const Supported32BitAbisWidget({super.key});

  @override
  _Supported32BitAbisWidgetState createState() =>
      _Supported32BitAbisWidgetState();
}

class _Supported32BitAbisWidgetState extends State<Supported32BitAbisWidget> {
  List<String> _supported32BitAbis = [];

  Future<void> getSupported32BitAbis() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setState(() {
        _supported32BitAbis = androidInfo.supported32BitAbis;
      });
    } catch (e) {
      setState(() {
        _supported32BitAbis = [context.tr('unknownOrNotAndroidNotice')];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_supported32BitAbis.isEmpty) getSupported32BitAbis();
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('supported32BitAbisLongName')),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => InfoModalBottomSheet(
                      name: context.tr('supported32BitAbisLongName'),
                      description:
                          context.tr('supported32BitAbisLongDescription'),
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
            for (var abi in _supported32BitAbis)
              Text(abi, style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
