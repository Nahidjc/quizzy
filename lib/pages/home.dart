import 'package:flutter/material.dart';
import 'package:quizzy/components/custom_drawer.dart';
import 'package:quizzy/configs/variables.dart';
import 'package:quizzy/pages/all_quiz_categories.dart';
import 'package:quizzy/pages/home_page.dart';
import 'package:quizzy/pages/leaderboard.dart';
import 'package:quizzy/pages/profile_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const AllQuizCategories(),
    const LeaderboardPage(),
    const ProfilePage(),
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Quiz',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard_rounded),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu), // Menu icon
            label: 'Menu',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Variables.primaryColor,
        onTap: (index) {
          if (index == 3) {
            _openDrawer();
          } else {
            _onItemTapped(index);
          }
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
      drawer: const CustomDrawer(),
    );
  }
}
