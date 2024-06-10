// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dummy/majorScreen/HomeScreen.dart';
// import 'package:dummy/majorScreen/userHomescreenBottomNavBar.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import '../events and cells/eventAndCellAdmin.dart';
// import '../foodStores/food Store owners pages/foodStoreOwnerNavBar.dart';
// import 'login.dart';
// import 'login_or_register.dart';
//
// class UserManagement{
//   Widget handleAuth(BuildContext context){
//     return StreamBuilder(stream:FirebaseAuth.instance.authStateChanges(),
//     builder: (context,snapshot){
//       if (snapshot.hasData){
//
//         User? user=FirebaseAuth.instance.currentUser;
//         if( user != null){
//           FirebaseFirestore.instance.collection('users').where('email',isEqualTo: user.email).get().then((docs) {
//             if (docs.docs[0].exists && docs.docs[0].data()['role']=='cellAdmin') {
//               Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CellAdmin()));
//             }
//             else if(docs.docs[0].exists && docs.docs[0].data()['role']=='foodStoreOwner') {
//               Navigator.of(context).push(MaterialPageRoute(builder: (context)=>FoodStoreOwner()));
//             }
//
//             else if(docs.docs[0].exists && docs.docs[0].data()['role']=='user') {
//               Navigator.of(context).push(MaterialPageRoute(builder: (context)=>userHomescreen()));
//             }
//           });
//         }
//
//       }
//
//       return const LoginOrRegister();
//     });
//   }
//   authorizeAccess(BuildContext context){
//     User? user=FirebaseAuth.instance.currentUser;
//     if( user != null){
//       FirebaseFirestore.instance.collection('users').where('email',isEqualTo: user.email).get().then((docs) {
//         if (docs.docs[0].exists && docs.docs[0].data()['role']=='cellAdmin') {
//           Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CellAdmin()));
//         }
//         else if(docs.docs[0].exists && docs.docs[0].data()['role']=='foodStoreOwner') {
//           Navigator.of(context).push(MaterialPageRoute(builder: (context)=>FoodStoreOwner()));
//         }
//
//         else if(docs.docs[0].exists && docs.docs[0].data()['role']=='user') {
//           Navigator.of(context).push(MaterialPageRoute(builder: (context)=>userHomescreen()));
//         }
//       });
//     }
//   }
// }