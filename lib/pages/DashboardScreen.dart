import 'package:flutter/material.dart';
import 'package:hidayath/customicons_icons.dart';
import 'package:hidayath/pages/AccountScreen.dart';
import 'package:hidayath/pages/HomeScreen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  var _currentIndex = 0;

  final _navBarItems = [
    const BottomNavigationBarItem(icon: Icon(Customicons.ion_home), label: "Home"),
    // const BottomNavigationBarItem(icon: Icon(Icons.folder_copy_rounded), label: "Documents"),
    const BottomNavigationBarItem(icon: Icon(Customicons.mdi_about), label: "About")
  ];

  final _pages = [
    const HomeScreen(),
    // const DocumnetScreen(),
    const AccountScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 14,
        currentIndex: _currentIndex,
        items: _navBarItems,
        selectedItemColor: const Color(0xFFDE6151),
        unselectedItemColor: const Color(0xFF1A737E),
        onTap: (index) {
          _currentIndex = index;
          setState(() {});
        },
      ),
    );
  }
}
