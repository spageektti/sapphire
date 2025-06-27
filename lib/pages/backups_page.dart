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
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sapphire/theme_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

class BackupsPage extends StatefulWidget {
  const BackupsPage({super.key});

  @override
  State<BackupsPage> createState() => _BackupsPageState();
}

class _BackupsPageState extends State<BackupsPage> {
  Future<void> _createLocalBackup() async {
    final prefs = await SharedPreferences.getInstance();
    final allPrefs = prefs.getKeys().fold<Map<String, dynamic>>({}, (map, key) {
      final value = prefs.get(key);
      map[key] = value;
      return map;
    });

    final jsonString = const JsonEncoder.withIndent('  ').convert(allPrefs);

    final result = jsonString.isNotEmpty ? jsonString : null;
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr("noDataToBackup"))),
      );
      return;
    }

    final bytes = utf8.encode(result);
    final output = await FilePicker.platform.saveFile(
      dialogTitle: context.tr("saveBackupFile"),
      fileName: "sapphire-backup.json",
      bytes: bytes,
    );

    if (output != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr("backupCreated"))),
      );
    }
  }

  Future<void> _importLocalBackup() async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: context.tr("selectBackupFile"),
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null || result.files.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr("noFileSelected"))),
      );
      return;
    }

    final file = File(result.files.single.path!);
    if (!await file.exists()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr("fileNotFound"))),
      );
      return;
    }

    try {
      final jsonString = await file.readAsString();
      final Map<String, dynamic> data = jsonDecode(jsonString);

      final prefs = await SharedPreferences.getInstance();
      for (var entry in data.entries) {
        final value = entry.value;
        if (value is List) {
          await prefs.setStringList(
              entry.key, List<String>.from(value.map((e) => e.toString())));
        } else {
          await prefs.setString(entry.key, value.toString());
        }
      }
      themeNotifier.refreshTheme();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr("backupImported"))),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.tr("backupImportFailed"))),
      );
      print(e);
    }
  }

  Future<void> _resetSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (var key in keys) {
      await prefs.remove(key);
    }
    themeNotifier.refreshTheme();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.tr("settingsReset"))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr("backupsPageTitle")),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.save_alt),
            title: Text(context.tr("createLocalBackup")),
            subtitle: Text(context.tr("createLocalBackupDesc")),
            onTap: () {
              _createLocalBackup();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: Text(context.tr("importLocalBackup")),
            subtitle: Text(context.tr("importLocalBackupDesc")),
            onTap: () {
              _importLocalBackup();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.restore),
            title: Text(context.tr("resetSettings")),
            subtitle: Text(context.tr("resetSettingsDesc")),
            onTap: () {
              _resetSettings();
            },
          )
        ],
      ),
    );
  }
}
