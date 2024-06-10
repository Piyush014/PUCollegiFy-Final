import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy/events%20and%20cells/eventAndCellAdmin.dart';
import 'package:dummy/foodStores/food%20Store%20owners%20pages/foodStoreOwnerNavBar.dart';
import 'package:dummy/minor%20screens/userHomescreenBottomNavBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage {
  StatefulWidget UserHome(role) {
    var fsname=FirebaseFirestore.instance.collection('users').where('email',isEqualTo: FirebaseAuth.instance.currentUser?.email).get().then((docs) => docs.docs[0].data()['name'].toString());
    if (role=='cellAdmin'){
      return Admin();
    }
    if (role=='user'){
      return userHomescreen();
    }

    return FoodStoreOwner(fsname: fsname.toString());

  }
}
