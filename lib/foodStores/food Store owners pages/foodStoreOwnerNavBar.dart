import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy/foodStores/food%20Store%20owners%20pages/upload.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../majorScreen/foodOrder.dart';
import '../../majorScreen/profile.dart';
import 'manageStore.dart';
import 'myStore.dart';
import 'orders.dart';
import 'ownerProfile.dart';

class FoodStoreOwner extends StatefulWidget {
  final String fsname;
  const FoodStoreOwner( {required this.fsname,super.key, });

  @override
  State<FoodStoreOwner> createState() => _FoodStoreOwnerState();
}
int _selectedIndex = 0;
List<Widget> _tabs = [
  MyStore(),
  Orders(),
  ManageStore(),
  UploadNewItems(),
  OwnerProfileScreen()
];
class _FoodStoreOwnerState extends State<FoodStoreOwner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe6ebec),
      // appBar: AppBar(title:Text(widget.fsname),centerTitle: true,),
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

                label: 'My Store'),
            BottomNavigationBarItem(
                icon: Icon(Icons.emoji_events_outlined,),
                label: 'Orders'),
            BottomNavigationBarItem(
                icon: Icon(Icons.map), label: 'Manage Store'),
            BottomNavigationBarItem(
                icon: Icon(Icons.new_label_outlined),
                label: 'New item'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
        body: _tabs[_selectedIndex],
    );
  }
}
