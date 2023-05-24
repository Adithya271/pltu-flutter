import 'package:flutter/material.dart';

import 'area/BrowseArea.dart';

class SidebarMenu extends StatelessWidget {
  const SidebarMenu({
    Key? key,
    required this.selectedIndex,
    required this.onSidebarItemTapped,
  }) : super(key: key);

  final int selectedIndex;
  final Function(int) onSidebarItemTapped;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Sidebar Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Dashboard'),
            onTap: () {
              onSidebarItemTapped(0);
            },
            selected: selectedIndex == 0,
          ),
          ListTile(
            title: const Text('Area'),
            onTap: () {
              onSidebarItemTapped(1);
            },
            selected: selectedIndex == 1,
          ),
          ListTile(
            title: const Text('Divisi'),
            onTap: () {
              onSidebarItemTapped(2);
            },
            selected: selectedIndex == 2,
          ),
          ListTile(
            title: const Text('GroupEquipment'),
            onTap: () {
              onSidebarItemTapped(3);
            },
            selected: selectedIndex == 3,
          ),
        ],
      ),
    );
  }
}
