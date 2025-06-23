/*
 * SPDX-FileCopyrightText: 2024 Wiktor Perskawiec <wiktor@perskawiec.cc>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
/*
* Copyright (C) 2024 Wiktor Perskawiec <wiktor@perskawiec.cc>
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/
/* 
* To contribute, please read the CONTRIBUTING.md file in the root of the project.
* It contains important information about the project structure, code style, suggested VSCode extensions, and more.
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

enum EpicCollection { natural, enhanced, aerosol, cloud }

class EpicWidget extends StatefulWidget {
  const EpicWidget({super.key});

  @override
  State<EpicWidget> createState() => _EpicWidgetState();
}

class _EpicWidgetState extends State<EpicWidget> {
  DateTime _selectedDate = DateTime.now().subtract(const Duration(
      days:
          1)); // Defaults to yesterday as sometimes today's data is not available
  EpicCollection _collection = EpicCollection.natural;
  List<dynamic>? _epicData;
  bool _loading = false;
  String? _error;
  bool _showDescription = true;

  Future<void> _download(int index) async {
    if (_epicData == null || _epicData!.isEmpty) return;

    final item = _epicData![index];
    final String imageName = item['image'];
    final String year = DateFormat('yyyy').format(_selectedDate);
    final String month = DateFormat('MM').format(_selectedDate);
    final String day = DateFormat('dd').format(_selectedDate);
    final String collectionStr = _collection.name;
    final String url =
        'https://epic.gsfc.nasa.gov/archive/$collectionStr/$year/$month/$day/png/$imageName.png';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final result = await FilePicker.platform.saveFile(
          dialogTitle: context.tr('epicDownloadDialogTitle'),
          fileName: '$imageName.png',
          initialDirectory: '/',
          bytes: response.bodyBytes,
        );

        if (result != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(context
                    .tr('epicDownloadSuccess', namedArgs: {'file': result}))),
          );
        }
      } else {
        setState(() {
          _error =
              '${context.tr('epicDownloadFailed')}: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _error = '${context.tr('error')}: $e';
      });
    }
  }

  Future<void> _fetchEpic() async {
    setState(() {
      _loading = true;
      _error = null;
      _epicData = null;
    });

    final String dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    final String collectionStr = _collection.name;
    final String url =
        'https://epic.gsfc.nasa.gov/api/$collectionStr/date/$dateStr';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          _epicData = json.decode(response.body);
        });
      } else {
        setState(() {
          _error = '${context.tr('epicFailedToLoad')}: ${response.statusCode}';
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
    _fetchEpic();
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015, 6, 13),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _fetchEpic();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('epicLongName')),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => InfoModalBottomSheet(
                  name: context.tr('epicLongName'),
                  description: context.tr('epicLongDescription'),
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
                const SizedBox(width: 16),
                DropdownButton<EpicCollection>(
                  value: _collection,
                  onChanged: (EpicCollection? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _collection = newValue;
                      });
                      _fetchEpic();
                    }
                  },
                  items: EpicCollection.values
                      .map<DropdownMenuItem<EpicCollection>>(
                          (EpicCollection value) {
                    return DropdownMenuItem<EpicCollection>(
                      value: value,
                      child: Text(value.name),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_loading) const Center(child: CircularProgressIndicator()),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            if (_epicData != null && !_loading)
              Expanded(
                child: _epicData!.isEmpty
                    ? Center(child: Text(context.tr('epicNoImages')))
                    : ListView.builder(
                        itemCount: _epicData!.length,
                        itemBuilder: (context, index) {
                          final item = _epicData![index];
                          final String imageName = item['image'];
                          final String year =
                              DateFormat('yyyy').format(_selectedDate);
                          final String month =
                              DateFormat('MM').format(_selectedDate);
                          final String day =
                              DateFormat('dd').format(_selectedDate);
                          final String collectionStr = _collection.name;
                          final String thumbUrl =
                              'https://epic.gsfc.nasa.gov/archive/$collectionStr/$year/$month/$day/thumbs/$imageName.jpg';
                          final String fullUrl =
                              'https://epic.gsfc.nasa.gov/archive/$collectionStr/$year/$month/$day/png/$imageName.png';

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: Image.network(
                                thumbUrl,
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image),
                              ),
                              title: Text(item['caption'] ?? imageName),
                              subtitle: _showDescription
                                  ? Text(
                                      '${context.tr('epicImageDate')}: ${item['date']}\n${context.tr('epicCentroid')}: ${item['centroid_coordinates']?['lat']}, ${item['centroid_coordinates']?['lon']}',
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : null,
                              trailing: IconButton(
                                icon: const Icon(Icons.download_rounded),
                                onPressed: () => _download(index),
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(item['caption'] ?? imageName),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (_) => Dialog(
                                                    child: InteractiveViewer(
                                                      child: Image.network(
                                                        fullUrl,
                                                        fit: BoxFit.contain,
                                                        errorBuilder: (context,
                                                                error,
                                                                stackTrace) =>
                                                            const Icon(
                                                                Icons
                                                                    .broken_image,
                                                                size: 100),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Image.network(
                                                fullUrl,
                                                width: 400,
                                                height: 400,
                                                fit: BoxFit.contain,
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null)
                                                    return child;
                                                  return SizedBox(
                                                    width: 400,
                                                    height: 400,
                                                    child: Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        value: loadingProgress
                                                                    .expectedTotalBytes !=
                                                                null
                                                            ? loadingProgress
                                                                    .cumulativeBytesLoaded /
                                                                (loadingProgress
                                                                        .expectedTotalBytes ??
                                                                    1)
                                                            : null,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    const Icon(
                                                        Icons.broken_image,
                                                        size: 100),
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                                '${context.tr('epicImageDate')}: ${item['date']}'),
                                            const SizedBox(height: 8),
                                            Text(
                                                '${context.tr('epicCentroid')}: ${item['centroid_coordinates']?['lat']}, ${item['centroid_coordinates']?['lon']}'),
                                            const SizedBox(height: 8),
                                            if (item['dscovr_j2000_position'] !=
                                                null)
                                              Text(
                                                  '${context.tr('epicDSCOVR')}: ${item['dscovr_j2000_position']}'),
                                            const SizedBox(height: 8),
                                            if (item['lunar_j2000_position'] !=
                                                null)
                                              Text(
                                                  '${context.tr('epicLunar')}: ${item['lunar_j2000_position']}'),
                                            const SizedBox(height: 8),
                                            if (item['sun_j2000_position'] !=
                                                null)
                                              Text(
                                                  '${context.tr('epicSun')}: ${item['sun_j2000_position']}'),
                                            const SizedBox(height: 8),
                                            if (item['attitude_quaternions'] !=
                                                null)
                                              Text(
                                                  '${context.tr('epicAttitude')}: ${item['attitude_quaternions']}'),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: Text(
                                              MaterialLocalizations.of(context)
                                                  .closeButtonLabel),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            final uri = Uri.parse(fullUrl);
                                            await launchUrl(
                                              uri,
                                              mode: LaunchMode
                                                  .externalApplication,
                                            );
                                          },
                                          child:
                                              Text(context.tr('openInBrowser')),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
