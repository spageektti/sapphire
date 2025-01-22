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
import 'package:flutter/services.dart';
import 'package:sapphire/widgets/info_modal_bottom_sheet.dart';

class GcdWidget extends StatefulWidget {
  const GcdWidget({super.key});

  @override
  _GcdWidgetState createState() => _GcdWidgetState();
}

class _GcdWidgetState extends State<GcdWidget> {
  int gcd(int a, int b) {
    if (b == 0) {
      return a;
    } else {
      return gcd(b, a % b);
    }
  }

  int _a = 0;
  int _b = 0;
  int _result = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GCD Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => const InfoModalBottomSheet(
                      name: 'GCD',
                      description:
                          'The greatest common divisor (gcd) of two integers is the largest positive integer that divides both numbers without a remainder.',
                      author: 'Wiktor Perskawiec (spageektti)',
                      authorUrl: 'https://spageektti.cc'));
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child:
                  Text('GCD: $_result', style: const TextStyle(fontSize: 24)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 16),
              child: TextField(
                maxLength: 18,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter first number',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onChanged: (value) {
                  setState(() {
                    _a = int.tryParse(value) ?? 0;
                    _result = gcd(_a, _b);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 16),
              child: TextField(
                maxLength: 18,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter second number',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onChanged: (value) {
                  setState(() {
                    _b = int.tryParse(value) ?? 0;
                    _result = gcd(_a, _b);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
