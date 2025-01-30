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
import 'package:sapphire/functions/math/gcd.dart';
import 'package:sapphire/functions/math/lcm.dart';
import 'package:sapphire/functions/math/power.dart';
import 'package:sapphire/functions/math/root.dart' as math_root;

class FunctionItem {
  final Widget widget;
  final String name;
  final String author;
  final IconData icon;
  final List<String> tags;
  final int index;

  FunctionItem({
    required this.widget,
    required this.name,
    required this.author,
    required this.icon,
    required this.tags,
    required this.index,
  });
}

List<FunctionItem> functionList = [
  FunctionItem(
    widget: const GcdWidget(),
    name: 'gcd',
    author: 'spageektti',
    icon: Icons.calculate,
    tags: ['math', 'gcd', 'lcm'],
    index: 0,
  ),
  FunctionItem(
      widget: const LcmWidget(),
      name: 'lcm',
      author: 'spageektti',
      icon: Icons.calculate,
      tags: ['math', 'lcm', 'gcd'],
      index: 1),
  FunctionItem(
      widget: const math_root.RootWidget(),
      name: 'root',
      author: 'spageektti',
      icon: Icons.square_foot,
      tags: ['math', 'root', 'power'],
      index: 2),
  FunctionItem(
      widget: const PowerWidget(),
      name: 'power',
      author: 'spageektti',
      icon: Icons.bolt,
      tags: ['math', 'power', 'root'],
      index: 3),
];
