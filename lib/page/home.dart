import 'package:flutter/material.dart';
import 'package:pltu/page/sidebar.dart';
import 'area/BrowseArea.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _sidebarIndex = 0;
  int _bottomBarIndex = 0; // Add a separate index for the bottom navigation bar

  static const List<Widget> _pages = <Widget>[
    Center(child: Text('Dashboard')),
    const BrowseArea(),
    Center(child: Text('Divisi')),
    Center(child: Text('Equipment')),
  ];

  void _onSidebarItemTapped(int index) {
    setState(() {
      _sidebarIndex = index;
    });
  }

  void _onBottomBarItemTapped(int index) {
    setState(() {
      _bottomBarIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: _pages[_sidebarIndex],
      drawer: SidebarMenu(
        selectedIndex: _sidebarIndex,
        onSidebarItemTapped: _onSidebarItemTapped,
      ),
      bottomNavigationBar: BottomNavigationBar(
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
        currentIndex:
            _bottomBarIndex, // Use the separate index for the bottom navigation bar
        selectedItemColor: Colors.blue,
        onTap:
            _onBottomBarItemTapped, // Use a separate handler for the bottom navigation bar
      ),
    );
  }
}
