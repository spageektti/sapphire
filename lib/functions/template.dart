/*
 * SPDX-FileCopyrightText: 2024 Wiktor Perskawiec <contact@spageektti.cc>
 * SPDX-FileCopyrightText: Year Author <email>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
/*
* Copyright (C) 2024 Wiktor Perskawiec <contact@spageektti.cc>
* Copyright (C) Year Author <email>

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
import 'package:easy_localization/easy_localization.dart';
import 'package:sapphire/widgets/info_modal_bottom_sheet.dart';

// ? This is a template for creating new functions.
// ? replace all instances of `Template` and `template` with the name of the function.
// ! do not forget to update the `function_list.dart` and `default_home_list.dart` files in the `lib` directory.
// ! do not forget to add translations to the `assets/translations/en.json` file. You can also add translations to other languages you know.

class TemplateWidget extends StatefulWidget {
  const TemplateWidget({super.key});

  @override
  _TemplateWidgetState createState() => _TemplateWidgetState();
}

class _TemplateWidgetState extends State<TemplateWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('templateLongName')),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => InfoModalBottomSheet(
                      name: context.tr('templateLongName'),
                      description: context.tr('templateLongDescription'),
                      author: 'Your Name (nickname)',
                      authorUrl: 'https://your-website-or-github.com'));
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // This is where the content of the function goes
          ],
        ),
      ),
    );
  }
}
