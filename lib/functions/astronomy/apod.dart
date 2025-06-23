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
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sapphire/widgets/settings_widget.dart';
import 'package:sapphire/widgets/info_modal_bottom_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';

class ApodWidget extends StatefulWidget {
  const ApodWidget({super.key});

  @override
  State<ApodWidget> createState() => _ApodWidgetState();
}

class _ApodWidgetState extends State<ApodWidget> {
  DateTime _selectedDate = DateTime.now();
  Map<String, dynamic>? _apodData;
  bool _loading = false;
  String? _error;
  String _apiKey = 'DEMO_KEY';
  bool _showDescription = true;

  Future<void> _download() async {
    if (_apodData == null) return;

    final String? url = _apodData!['url'];
    if (url == null) {
      setState(() {
        _error = context.tr('apodNoUrlError');
      });
      return;
    }

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final result = await FilePicker.platform.saveFile(
          dialogTitle: context.tr('apodDownloadDialogTitle'),
          fileName: '${_apodData!['title'] ?? 'apod'}.jpg',
          initialDirectory: '/',
          bytes: response.bodyBytes,
        );

        if (result != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(context
                    .tr('apodDownloadSuccess', namedArgs: {'file': result}))),
          );
        }
      } else {
        setState(() {
          _error =
              '${context.tr('apodDownloadFailed')}: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _error = '${context.tr('error')}: $e';
      });
    }
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'apodSettings';
    final values = prefs.getStringList(key);
    setState(() {
      if (values != null && values.isNotEmpty) {
        _apiKey = values[0].isNotEmpty ? values[0] : 'DEMO_KEY';
        _showDescription = values.length > 1 ? (values[1] == 'true') : true;
      }
    });
  }

  Future<void> _fetchApod() async {
    setState(() {
      _loading = true;
      _error = null;
      _apodData = null;
    });

    final String dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final String url =
        'https://api.nasa.gov/planetary/apod?date=$dateStr&api_key=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          _apodData = json.decode(response.body);
        });
      } else {
        setState(() {
          _error = '${context.tr('apodFailedToLoad')}: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _error = '${context.tr('error')}: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSettings().then((_) => _fetchApod());
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1995, 6, 16),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _fetchApod();
    }
  }

  void _openSettings() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsWidget(
          settings: ['api_key', 'show_description'],
          defaultValues: ['DEMO_KEY', 'true'],
          pageName: 'apod',
        ),
      ),
    );
    await _loadSettings();
    _fetchApod();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('apodLongName')),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: _openSettings,
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => InfoModalBottomSheet(
                  name: context.tr('apodLongName'),
                  description: context.tr('apodLongDescription'),
                  author: 'Wiktor Perskawiec (spageektti)',
                  authorUrl: 'https://spageektti.cc',
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  '${context.tr('date')}: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _pickDate(context),
                  child: Text(context.tr('selectDate')),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_loading) const Center(child: CircularProgressIndicator()),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            if (_apodData != null && !_loading)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (_apodData!['media_type'] == 'image')
                        Image.network(_apodData!['url']),
                      if (_apodData!['media_type'] == 'video')
                        Column(
                          children: [
                            const Icon(Icons.videocam, size: 48),
                            Text(context.tr('apodVideoNotice')),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () async {
                                final url = _apodData!['url'];
                                if (url != null) {
                                  if (await canLaunchUrl(Uri.parse(url))) {
                                    await launchUrl(Uri.parse(url),
                                        mode: LaunchMode.externalApplication);
                                  }
                                }
                              },
                              child: Text(context.tr('openVideo')),
                            )
                          ],
                        ),
                      const SizedBox(height: 16),
                      Text(
                        _apodData!['title'] ?? '',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      if (_showDescription)
                        Text(
                          _apodData!['explanation'] ?? '',
                          textAlign: TextAlign.justify,
                        ),
                      if (_apodData!['copyright'] != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            '© ${_apodData!['copyright']}',
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _download,
        child: const Icon(Icons.download_rounded),
      ),
    );
  }
}
