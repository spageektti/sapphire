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
import 'package:sapphire/pages/backups_page.dart';
import 'package:sapphire/pages/language_select_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr("settingsPageTitle")),
        actions: [
          IconButton(icon: const Icon(Icons.info_outline), onPressed: () {}),
        ],
      ),
      body: Center(
          child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(context.tr("settingsPageLanguageLabel")),
            subtitle: Text(context.tr(context.locale.toString())),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const LanguageSelectPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: Text(context.tr("settingsPageThemeLabel")),
            onTap: () {
              // Handle theme change
            },
          ),
          ListTile(
            leading: const Icon(Icons.backup_outlined),
            title: Text(context.tr("settingsPageBackupsLabel")),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const BackupsPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(context.tr("settingsPageAboutLabel")),
            onTap: () {
              // Handle about dialog
            },
          ),
        ],
      )),
    );
  }
}
