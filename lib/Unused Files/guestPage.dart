import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy/Login/authorize.dart';

import 'package:dummy/Login/login_or_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';

class NextPage extends StatefulWidget {
  @override
  State<NextPage> createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: const Color(0xFFFC4F4F),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
            padding: EdgeInsets.all(8),
            backgroundColor: Color(0xFFFC4F4F),
            color: Colors.white,
            gap: 8,
            activeColor: Colors.red,
            tabBackgroundColor: Colors.amber,
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.food_bank_outlined,
                text: 'Food Order',
              ),
              GButton(
                icon: Icons.map_outlined,
                text: 'Map',
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await GoogleSignIn().signOut();
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginOrRegister()));
              },
              icon: const Icon(Icons.power_settings_new))
        ],
        title: Container(
          child: FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('guests')
                  .doc(FirebaseAuth.instance.currentUser!.email!)
                  .get(),
              builder: (context, snapshot) {

                return Text('Welcome ' + snapshot.data!['name']);

              }),
        ),
        backgroundColor: const Color(0xFFFC4F4F),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
      ),
      // body: Container(margin: const EdgeInsets.all(50),child: CircleAvatar(radius: 100,backgroundImage: NetworkImage(getImage),)),
    );
  }
}
