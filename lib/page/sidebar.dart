import 'package:flutter/material.dart';

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
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              onSidebarItemTapped(0);
            },
            selected: selectedIndex == 0,
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profil'),
            onTap: () {
              onSidebarItemTapped(1);
            },
            selected: selectedIndex == 1,
          ),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text('Divisi'),
            onTap: () {
              onSidebarItemTapped(2);
            },
            selected: selectedIndex == 2,
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Area'),
            onTap: () {
              onSidebarItemTapped(3);
            },
            selected: selectedIndex == 3,
          ),
          ListTile(
            leading: const Icon(Icons.settings_overscan),
            title: const Text('GroupEquipment'),
            onTap: () {
              onSidebarItemTapped(4);
            },
            selected: selectedIndex == 4,
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Equipment'),
            onTap: () {
              onSidebarItemTapped(5);
            },
            selected: selectedIndex == 5,
          ),
          ListTile(
            leading: const Icon(Icons.type_specimen),
            title: const Text('Type'),
            onTap: () {
              onSidebarItemTapped(6);
            },
            selected: selectedIndex == 6,
          ),
          
        ],
      ),
    );
  }
}
