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

class WebMaxTouchPointsWidget extends StatefulWidget {
  const WebMaxTouchPointsWidget({super.key});

  @override
  _WebMaxTouchPointsWidgetState createState() =>
      _WebMaxTouchPointsWidgetState();
}

class _WebMaxTouchPointsWidgetState extends State<WebMaxTouchPointsWidget> {
  int _maxTouchPoints = 0;

  Future<void> getMaxTouchPoints() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
      setState(() {
        _maxTouchPoints = webBrowserInfo.maxTouchPoints ?? 0;
      });
    } catch (e) {
      setState(() {
        _maxTouchPoints = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_maxTouchPoints == 0) getMaxTouchPoints();
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('webMaxTouchPointsLongName')),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => InfoModalBottomSheet(
                      name: context.tr('webMaxTouchPointsLongName'),
                      description:
                          context.tr('webMaxTouchPointsLongDescription'),
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
            Text(_maxTouchPoints.toString(),
                style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
