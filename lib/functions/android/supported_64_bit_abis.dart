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

class Supported64BitAbisWidget extends StatefulWidget {
  const Supported64BitAbisWidget({super.key});

  @override
  _Supported64BitAbisWidgetState createState() =>
      _Supported64BitAbisWidgetState();
}

class _Supported64BitAbisWidgetState extends State<Supported64BitAbisWidget> {
  List<String> _supported64BitAbis = [];

  Future<void> getSupported64BitAbis() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setState(() {
        _supported64BitAbis = androidInfo.supported64BitAbis;
      });
    } catch (e) {
      setState(() {
        _supported64BitAbis = [context.tr('unknownOrNotAndroidNotice')];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_supported64BitAbis.isEmpty) getSupported64BitAbis();
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('supported64BitAbisLongName')),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => InfoModalBottomSheet(
                      name: context.tr('supported64BitAbisLongName'),
                      description:
                          context.tr('supported64BitAbisLongDescription'),
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
            for (var abi in _supported64BitAbis)
              Text(abi, style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
