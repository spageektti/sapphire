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
import 'package:flutter_test/flutter_test.dart';
import 'package:sapphire/functions/math/gcd.dart';

void main() {
  testWidgets('GcdWidget calculates GCD correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: GcdWidget()));

    final firstNumberField = find.byWidgetPredicate(
      (widget) =>
          widget is TextField &&
          widget.decoration?.labelText == 'Enter first number',
    );
    final secondNumberField = find.byWidgetPredicate(
      (widget) =>
          widget is TextField &&
          widget.decoration?.labelText == 'Enter second number',
    );

    await tester.enterText(firstNumberField, '48');
    await tester.enterText(secondNumberField, '18');
    await tester.pump();

    final gcdText = find.text('GCD: 6');
    expect(gcdText, findsOneWidget);
  });

  testWidgets('GcdWidget handles zero input correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: GcdWidget()));

    final firstNumberField = find.byWidgetPredicate(
      (widget) =>
          widget is TextField &&
          widget.decoration?.labelText == 'Enter first number',
    );
    final secondNumberField = find.byWidgetPredicate(
      (widget) =>
          widget is TextField &&
          widget.decoration?.labelText == 'Enter second number',
    );

    await tester.enterText(firstNumberField, '0');
    await tester.enterText(secondNumberField, '18');
    await tester.pump();

    final gcdText = find.text('GCD: 18');
    expect(gcdText, findsOneWidget);
  });
}
