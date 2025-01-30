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
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:sapphire/default_home_list.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _searchQuery = "";
  List<FunctionItem> _searchResults = functionList;

  Future<void> loadHomePageList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? homePageListString = prefs.getString('homePageList');
    String? homePageListNamesString = prefs.getString('homePageListNames');

    if (homePageListString == null || homePageListString.isEmpty) {
      homePageListString = jsonEncode(defaultHomeList);
      await prefs.setString('homePageList', homePageListString);
    }

    if (homePageListNamesString == null ||
        homePageListNamesString.isEmpty ||
        homePageListNamesString == '[]') {
      homePageListNamesString = jsonEncode(defaultHomeListNames);
      await prefs.setString('homePageListNames', homePageListNamesString);
    }

    print(homePageListString);
    print(homePageListNamesString);

    List<List<int>> homePageList = (jsonDecode(homePageListString) as List)
        .map((e) => (e as List).map((e) => e as int).toList())
        .toList();

    List<String> homePageListNames =
        (jsonDecode(homePageListNamesString) as List)
            .map((e) => e as String)
            .toList();

    setState(() {
      defaultHomeList = homePageList;
      defaultHomeListNames = homePageListNames;
    });
  }

  Future<void> addFunction(int categoryIndex, int itemIndex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    defaultHomeList[categoryIndex].add(itemIndex);
    await prefs.setString('homePageList', jsonEncode(defaultHomeList));
    await prefs.setString(
        'homePageListNames', jsonEncode(defaultHomeListNames));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(context.tr("searchPageTitle")),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: TextField(
                decoration: InputDecoration(
                  labelText: context.tr("searchPageSearchBar"),
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                    if (_searchQuery.isEmpty) {
                      _searchResults = functionList;
                    } else {
                      _searchResults = functionList
                          .where((element) =>
                              context
                                  .tr("${element.name}ShortName")
                                  .toLowerCase()
                                  .contains(_searchQuery.toLowerCase()) ||
                              context
                                  .tr("${element.name}LongName")
                                  .toLowerCase()
                                  .contains(_searchQuery.toLowerCase()) ||
                              context
                                  .tr("${element.name}ShortDescription")
                                  .toLowerCase()
                                  .contains(_searchQuery.toLowerCase()) ||
                              context
                                  .tr("${element.name}LongDescription")
                                  .toLowerCase()
                                  .contains(_searchQuery.toLowerCase()) ||
                              element.tags.any((tag) => tag
                                  .toLowerCase()
                                  .contains(_searchQuery.toLowerCase())))
                          .toList();
                    }
                  });
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        context.tr("${_searchResults[index].name}ShortName")),
                    subtitle: Text(context
                        .tr("${_searchResults[index].name}ShortDescription")),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => _searchResults[index].widget));
                    },
                    trailing: IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                      context.tr("searchPageSelectCategory")),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: defaultHomeListNames
                                        .asMap()
                                        .entries
                                        .map((entry) => ListTile(
                                              title: Text(entry.value),
                                              onTap: () {
                                                addFunction(
                                                    entry.key,
                                                    _searchResults[index]
                                                        .index);
                                                Navigator.of(context).pop();
                                              },
                                            ))
                                        .toList(),
                                  ),
                                );
                              });
                        },
                        icon: const Icon(Icons.add)),
                    leading: Icon(_searchResults[index].icon),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
