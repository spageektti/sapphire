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
import 'package:easy_localization/easy_localization.dart';
import 'package:sapphire/function_list.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(context.tr("searchPageTitle")),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                decoration: InputDecoration(
                  labelText: context.tr("searchPageSearchBar"),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: functionList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        context.tr("${functionList[index].name}ShortName")),
                    subtitle: Text(context
                        .tr("${functionList[index].name}ShortDescription")),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => functionList[index].widget));
                    },
                    trailing: IconButton(
                        onPressed: () {}, icon: const Icon(Icons.add)),
                    leading: Icon(functionList[index].icon),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
