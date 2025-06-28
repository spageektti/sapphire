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
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sapphire/widgets/info_modal_bottom_sheet.dart';
import 'package:flutter/services.dart';

class Sha1ChecksumGeneratorWidget extends StatefulWidget {
  const Sha1ChecksumGeneratorWidget({super.key});

  @override
  State<Sha1ChecksumGeneratorWidget> createState() =>
      _Sha1ChecksumGeneratorWidgetState();
}

class _Sha1ChecksumGeneratorWidgetState
    extends State<Sha1ChecksumGeneratorWidget> {
  String? _checksum;
  String? _filePath;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _filePath = result.files.single.path;
      });
      _generateChecksum(_filePath!);
    }
  }

  void _generateChecksum(String filePath) {
    final file = File(filePath);
    if (!file.existsSync()) {
      setState(() {
        _checksum = null;
      });
      return;
    }

    final bytes = file.readAsBytesSync();
    final digest = sha1.convert(bytes);
    setState(() {
      _checksum = digest.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('sha1ChecksumGeneratorLongName')),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => InfoModalBottomSheet(
                      name: context.tr('sha1ChecksumGeneratorLongName'),
                      description:
                          context.tr('sha1ChecksumGeneratorLongDescription'),
                      author: 'Wiktor Perskawiec (spageektti)',
                      authorUrl: 'https://spageektti.cc'));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: _pickFile,
              child: Text(context.tr('pickFileButtonLabel')),
            ),
            const SizedBox(height: 24),
            if (_filePath != null)
              Text(context.tr('selectedFileLabel',
                  namedArgs: {'filePath': _filePath!})),
            const SizedBox(height: 16),
            if (_checksum != null)
              Row(
                children: [
                  SelectableText(
                    context.tr('sha1ChecksumLabel',
                        namedArgs: {'checksum': _checksum!}),
                    style: const TextStyle(fontSize: 24),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _checksum!));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(context.tr('copiedToClipboard'))),
                      );
                    },
                  )
                ],
              ),
            if (_checksum == null && _filePath != null)
              Text(
                context.tr('checksumErrorMessage'),
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
