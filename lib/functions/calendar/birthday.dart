/*
 * SPDX-FileCopyrightText: 2024 Wiktor Perskawiec <wiktor@perskawiec.cc>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sapphire/widgets/info_modal_bottom_sheet.dart';

class BirthdayCalculatorWidget extends StatefulWidget {
  const BirthdayCalculatorWidget({super.key});

  @override
  State<BirthdayCalculatorWidget> createState() =>
      _BirthdayCalculatorWidgetState();
}

class _BirthdayCalculatorWidgetState extends State<BirthdayCalculatorWidget> {
  DateTime? _birthDate;
  String? _result;
  final TextEditingController _birthDateController = TextEditingController();

  @override
  void dispose() {
    _birthDateController.dispose();
    super.dispose();
  }

  void _calculateBirthday() {
    if (_birthDate == null) {
      setState(() {
        _result = null;
      });
      return;
    }
    final now = DateTime.now();
    int years = now.year - _birthDate!.year;
    DateTime thisYearBirthday =
        DateTime(now.year, _birthDate!.month, _birthDate!.day);
    if (now.isBefore(thisYearBirthday)) {
      years -= 1;
      thisYearBirthday = DateTime(now.year, _birthDate!.month, _birthDate!.day);
    }
    DateTime nextBirthday =
        DateTime(now.year, _birthDate!.month, _birthDate!.day);
    if (!now.isBefore(thisYearBirthday)) {
      nextBirthday = DateTime(now.year + 1, _birthDate!.month, _birthDate!.day);
    }
    final daysRemaining =
        nextBirthday.difference(now).inDays + 1; // +1 to include today

    setState(() {
      _result = context.tr(
        'birthdayResult',
        namedArgs: {
          'years': years.toString(),
          'days': daysRemaining.toString(),
          'nextAge': (years + 1).toString(),
        },
      );
      if (daysRemaining == 0 || daysRemaining == 365) {
        _result = context.tr('birthdayToday', namedArgs: {
          'years': years.toString(),
        });
      }
    });
  }

  Future<void> _pickBirthDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(now.year - 20),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      _birthDate = picked;
      _birthDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      _calculateBirthday();
    }
  }

  @override
  Widget build(BuildContext context) {
    String resultText = _result ?? context.tr("birthdaySelectPrompt");

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('birthdayLongName')),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => InfoModalBottomSheet(
                  name: context.tr('birthdayLongName'),
                  description: context.tr('birthdayLongDescription'),
                  author: 'Wiktor Perskawiec (spageektti)',
                  authorUrl: 'https://spageektti.cc',
                ),
              );
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
                  controller: _birthDateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: context.tr('birthdayBirthDateLabel'),
                  ),
                  onTap: () => _pickBirthDate(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
