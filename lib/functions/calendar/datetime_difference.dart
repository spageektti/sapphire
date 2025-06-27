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

class DatetimeDifferenceWidget extends StatefulWidget {
  const DatetimeDifferenceWidget({super.key});

  @override
  State<DatetimeDifferenceWidget> createState() =>
      _DatetimeDifferenceWidgetState();
}

class _DatetimeDifferenceWidgetState extends State<DatetimeDifferenceWidget> {
  DateTime? _firstDateTime;
  DateTime? _secondDateTime;
  String? _result;

  final TextEditingController _firstDateController = TextEditingController();
  final TextEditingController _firstTimeController = TextEditingController();
  final TextEditingController _secondDateController = TextEditingController();
  final TextEditingController _secondTimeController = TextEditingController();

  @override
  void dispose() {
    _firstDateController.dispose();
    _firstTimeController.dispose();
    _secondDateController.dispose();
    _secondTimeController.dispose();
    super.dispose();
  }

  void _calculateDifference() {
    if (_firstDateTime == null || _secondDateTime == null) {
      setState(() {
        _result = null;
      });
      return;
    }
    final diff = _secondDateTime!.difference(_firstDateTime!);
    final absDiff = diff.isNegative ? -diff : diff;

    int days = absDiff.inDays;
    int hours = absDiff.inHours;
    int minutes = absDiff.inMinutes;

    setState(() {
      _result =
          '${plural('day', days)} = ${plural('hour', hours)} = ${plural('minute', minutes)}';
    });
  }

  Future<void> _pickDate(BuildContext context, bool isFirst) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isFirst ? (_firstDateTime ?? now) : (_secondDateTime ?? now),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      if (isFirst) {
        _firstDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _firstDateTime?.hour ?? 0,
          _firstDateTime?.minute ?? 0,
        );
        _firstDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      } else {
        _secondDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _secondDateTime?.hour ?? 0,
          _secondDateTime?.minute ?? 0,
        );
        _secondDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      }
      _calculateDifference();
    }
  }

  Future<void> _pickTime(BuildContext context, bool isFirst) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isFirst
          ? (_firstDateTime != null
              ? TimeOfDay(
                  hour: _firstDateTime!.hour, minute: _firstDateTime!.minute)
              : TimeOfDay.now())
          : (_secondDateTime != null
              ? TimeOfDay(
                  hour: _secondDateTime!.hour, minute: _secondDateTime!.minute)
              : TimeOfDay.now()),
    );
    if (picked != null) {
      if (isFirst) {
        final date = _firstDateTime ?? DateTime.now();
        _firstDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          picked.hour,
          picked.minute,
        );
        _firstTimeController.text = picked.format(context);
      } else {
        final date = _secondDateTime ?? DateTime.now();
        _secondDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          picked.hour,
          picked.minute,
        );
        _secondTimeController.text = picked.format(context);
      }
      _calculateDifference();
    }
  }

  @override
  Widget build(BuildContext context) {
    String resultText;
    if (_result == null) {
      resultText = context.tr("datetimeDifferencePromptLabel");
    } else {
      resultText = _result!;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('datetimeDifferenceLongName')),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => InfoModalBottomSheet(
                      name: context.tr('datetimeDifferenceLongName'),
                      description:
                          context.tr('datetimeDifferenceLongDescription'),
                      author: 'Wiktor Perskawiec (spageektti)',
                      authorUrl: 'https://spageektti.cc'));
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Text(
                  resultText,
                  style: const TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 64, vertical: 8),
                child: TextField(
                  controller: _firstDateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: context.tr("datetimeDifferenceFirstDateLabel"),
                  ),
                  onTap: () => _pickDate(context, true),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 64, vertical: 8),
                child: TextField(
                  controller: _firstTimeController,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: context.tr("datetimeDifferenceFirstTimeLabel"),
                  ),
                  onTap: () => _pickTime(context, true),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 64, vertical: 8),
                child: TextField(
                  controller: _secondDateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: context.tr("datetimeDifferenceSecondDateLabel"),
                  ),
                  onTap: () => _pickDate(context, false),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 64, vertical: 8),
                child: TextField(
                  controller: _secondTimeController,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: context.tr("datetimeDifferenceSecondTimeLabel"),
                  ),
                  onTap: () => _pickTime(context, false),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
