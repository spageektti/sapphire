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
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:sapphire/widgets/info_modal_bottom_sheet.dart';

class PowerWidget extends StatefulWidget {
  const PowerWidget({super.key});

  @override
  _PowerWidgetState createState() => _PowerWidgetState();
}

class _PowerWidgetState extends State<PowerWidget> {
  BigInt power(BigInt a, BigInt b) {
    if (a == BigInt.zero && b == BigInt.zero) {
      return BigInt.zero;
    }

    BigInt result = BigInt.one;

    while (b > BigInt.zero) {
      if (b.isOdd) {
        result *= a;
      }
      a *= a;
      b >>= 1;
    }

    return result;
  }

  BigInt _a = BigInt.zero;
  BigInt _b = BigInt.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('powerLongName')),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => InfoModalBottomSheet(
                      name: context.tr('powerLongName'),
                      description: context.tr('powerLongDescription'),
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
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
                child: Column(
                  children: [
                    Math.tex('${_a.toString()}^{${_b.toString()}}',
                        mathStyle: MathStyle.display,
                        textStyle: const TextStyle(fontSize: 24)),
                    Text("= ${power(_a, _b)}",
                        style: const TextStyle(fontSize: 24)),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 64, vertical: 16),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: context.tr('powerFirstButtonLabel'),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(
                        30), // TODO: Add ability to change this in the settings
                  ],
                  onChanged: (value) {
                    setState(() {
                      _a = BigInt.tryParse(value) ?? BigInt.zero;
                    });
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 64, vertical: 16),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: context.tr('powerSecondButtonLabel'),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(
                        3), // TODO: Add ability to change this in the settings
                  ],
                  onChanged: (value) {
                    setState(() {
                      _b = BigInt.tryParse(value) ?? BigInt.zero;
                    });
                  },
                ),
              ),
              const SizedBox(height: 64),
            ],
          ),
        ),
      ),
    );
  }
}
