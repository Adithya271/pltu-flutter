import 'package:flutter/material.dart';
import 'package:pltu/User/page/settings_user.dart';
import 'dashboard_user.dart';

class HomePageUser extends StatefulWidget {
  const HomePageUser({Key? key}) : super(key: key);

  @override
  _HomePageUserState createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
  int _bottomBarIndex = 0;

  static const List<Widget> _pages = <Widget>[
    DashboardUser(),
    SettingsUser()
    
  ];

  void _onBottomBarItemTapped(int index) {
    setState(() {
      _bottomBarIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_bottomBarIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _bottomBarIndex,
        selectedItemColor: Colors.blue,
        onTap: _onBottomBarItemTapped,
      ),
    );
  }
}
