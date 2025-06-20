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
import 'package:easy_localization/easy_localization.dart';
import 'package:sapphire/pages/home_page.dart';
import 'package:sapphire/pages/search_page.dart';
import 'package:sapphire/pages/settings_page.dart';

class NavigationWidget extends StatefulWidget {
  final int selectedIndex;

  const NavigationWidget({
    super.key,
    this.selectedIndex = 0,
  });

  @override
  _NavigationWidgetState createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  late PageController _pageController;
  late List<Widget> _pages;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    _pageController = PageController(initialPage: _selectedIndex);
    _pages = <Widget>[
      const HomePage(),
      const SearchPage(),
      const SettingsPage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: context.tr("homePageTitle"),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: context.tr("searchPageTitle"),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: context.tr("settingsPageTitle"),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
      ),
    );
  }
}
