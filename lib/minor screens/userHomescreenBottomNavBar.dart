import 'package:flutter/material.dart';
import '../majorScreen/HomeScreen.dart';
import '../majorScreen/eventsAndCells.dart';
import '../majorScreen/foodOrder.dart';
import '../majorScreen/navigate.dart';
import '../majorScreen/profile.dart';

class userHomescreen extends StatefulWidget {
  const userHomescreen({super.key});

  @override
  State<userHomescreen> createState() => _userHomescreenState();
}

class _userHomescreenState extends State<userHomescreen> {
  int _selectedIndex = 0;
  List<Widget> _tabs = [
    HomeScreen(),
    EventAndCells(),
    Navigate(),
    FoodOrder(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ClipRRect(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight:Radius.circular(20)),

        child: BottomNavigationBar(backgroundColor: Color(0xFF252525),
          selectedItemColor: Colors.blueAccent,
          selectedIconTheme: IconThemeData(color: Colors.blueAccent),
          unselectedItemColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  // color: Colors.white,
                ),

                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.emoji_events_outlined,),
                label: 'Events & Cells'),
            BottomNavigationBarItem(
                icon: Icon(Icons.map), label: 'Navigate'),
            BottomNavigationBarItem(
                icon: Icon(Icons.food_bank_outlined),
                label: 'Food'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
      body: _tabs[_selectedIndex],
    );
  }
}
