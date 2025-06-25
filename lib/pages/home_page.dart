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
! To contribute, please read the CONTRIBUTING.md file in the root of the project.
? It contains important information about the project structure, code style, suggested VSCode extensions, and more.
*/
import 'package:flutter/material.dart';
import '../function_list.dart';
import '../default_home_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _editMode = false;

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
      /*List<String> defaultHomeListNamesLocalized = [];
      for (var name in defaultHomeListNames) {
        name = context.tr(name);
        defaultHomeListNamesLocalized.add(name);
      }*/
      homePageListNamesString = jsonEncode(defaultHomeListNames); // Localized);
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

  Future<void> addCategory(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    defaultHomeList.add([]);
    defaultHomeListNames.add(name);
    await prefs.setString('homePageList', jsonEncode(defaultHomeList));
    await prefs.setString(
        'homePageListNames', jsonEncode(defaultHomeListNames));
    loadHomePageList();
  }

  Future<void> deleteCategory(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    defaultHomeList.removeAt(index);
    defaultHomeListNames.removeAt(index);
    await prefs.setString('homePageList', jsonEncode(defaultHomeList));
    await prefs.setString(
        'homePageListNames', jsonEncode(defaultHomeListNames));
    loadHomePageList();
  }

  Future<void> deleteFunction(int index, int itemIndex) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    defaultHomeList[index].removeAt(itemIndex);
    await prefs.setString('homePageList', jsonEncode(defaultHomeList));
    await prefs.setString(
        'homePageListNames', jsonEncode(defaultHomeListNames));
    loadHomePageList();
  }

  Future<void> saveNewOrder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('homePageList', jsonEncode(defaultHomeList));
    await prefs.setString(
        'homePageListNames', jsonEncode(defaultHomeListNames));
  }

  @override
  void initState() {
    super.initState();
    loadHomePageList();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount;
    if (screenWidth < 600) {
      crossAxisCount = 2;
    } else if (screenWidth < 1200) {
      crossAxisCount = 4;
    } else {
      crossAxisCount = 6;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr("homePageTitle")),
      ),
      body: Center(
        child: ListView.builder(
            itemCount: defaultHomeList.length + (_editMode ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == defaultHomeList.length) {
                TextEditingController newCategoryController =
                    TextEditingController();
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        controller: newCategoryController,
                        decoration: InputDecoration(
                          hintText: context.tr("newCategoryHint"),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          addCategory(newCategoryController.text);
                        },
                        child: Text(context.tr("newCategoryButton"))),
                  ],
                );
              }
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(context.tr(defaultHomeListNames[index]),
                          style: const TextStyle(fontSize: 20)),
                      if (_editMode)
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                          ),
                          onPressed: () {
                            deleteCategory(index);
                          },
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (!_editMode)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 1,
                      ),
                      itemCount: defaultHomeList[index].length,
                      itemBuilder: (BuildContext context, int itemIndex) {
                        return Tooltip(
                          message: context.tr(
                              '${functionList[defaultHomeList[index][itemIndex]].name}ShortDescription'),
                          child: Card(
                            child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) => functionList[
                                            defaultHomeList[index][itemIndex]]
                                        .widget,
                                    transitionDuration:
                                        const Duration(milliseconds: 200),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      const begin = Offset(
                                          0.0, 1.0); // Start from the bottom
                                      const end = Offset
                                          .zero; // End at the original position
                                      const curve = Curves.easeInOut;

                                      var tween = Tween(begin: begin, end: end)
                                          .chain(CurveTween(curve: curve));
                                      var offsetAnimation =
                                          animation.drive(tween);

                                      return SlideTransition(
                                        position: offsetAnimation,
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      functionList[defaultHomeList[index]
                                              [itemIndex]]
                                          .icon,
                                      size: 50,
                                    ),
                                    Text(
                                      context.tr(
                                          '${functionList[defaultHomeList[index][itemIndex]].name}ShortName'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  if (_editMode)
                    ReorderableListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      onReorder: (int oldIndex, int newIndex) {
                        setState(() {
                          if (newIndex > oldIndex) {
                            newIndex -= 1;
                          }
                          final item =
                              defaultHomeList[index].removeAt(oldIndex);
                          defaultHomeList[index].insert(newIndex, item);

                          saveNewOrder();
                        });
                      },
                      children: List.generate(defaultHomeList[index].length,
                          (itemIndex) {
                        return ListTile(
                          leading: IconButton(
                              onPressed: () {
                                deleteFunction(index, itemIndex);
                              },
                              icon: const Icon(Icons.delete)),
                          key: ValueKey(defaultHomeList[index][itemIndex]),
                          title: Text(context.tr(
                              '${functionList[defaultHomeList[index][itemIndex]].name}ShortName')),
                          trailing: ReorderableDragStartListener(
                            index: itemIndex,
                            child: const Icon(Icons.drag_handle),
                          ),
                        );
                      }),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _editMode = !_editMode;
          });
        },
        backgroundColor: Colors.blue[800],
        child: Icon(_editMode ? Icons.save : Icons.edit),
      ),
    );
  }
}
