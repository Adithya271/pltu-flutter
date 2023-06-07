import 'package:flutter/material.dart';
import 'package:pltu/page/divisi/BrowseDivisi.dart';
import 'package:pltu/page/equipment/BrowseEquipment.dart';
import 'package:pltu/page/groupEquipment/BrowseGroupEquipment.dart';
import 'package:pltu/page/profil.dart';
import 'package:pltu/page/sidebar.dart';
import 'package:pltu/page/type/BrowseType.dart';
import 'area/BrowseArea.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _sidebarIndex = 0;
  int _bottomBarIndex = 0;

  static const List<Widget> _pages = <Widget>[
    Center(child: Text('Dashboard')),
    ProfilPage(),
    BrowseDivisi(),
    BrowseArea(),
    BrowseGroupEquipment(),
    BrowseEquipment(),
    BrowseType(),
  ];

  void _onSidebarItemTapped(int index) {
    setState(() {
      _sidebarIndex = index;
    });
    Navigator.pop(context); // Close the sidebar after selecting an item
  }

  void _onBottomBarItemTapped(int index) {
    setState(() {
      _bottomBarIndex = index;
      _sidebarIndex = index; // Update the sidebar index as well
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PLTU'),
      ),
      body: _pages[_sidebarIndex],
      drawer: SidebarMenu(
        selectedIndex: _sidebarIndex,
        onSidebarItemTapped: _onSidebarItemTapped,
      ),
      bottomNavigationBar: BottomBar(
        currentIndex: _bottomBarIndex,
        onBottomBarItemTapped: _onBottomBarItemTapped,
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar({
    Key? key,
    required this.currentIndex,
    required this.onBottomBarItemTapped,
  }) : super(key: key);

  final int currentIndex;
  final Function(int) onBottomBarItemTapped;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: Colors.blue,
      onTap: onBottomBarItemTapped,
    );
  }
}
