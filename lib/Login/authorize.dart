// import 'package:dummy/google_next_page.dart';
// import 'package:dummy/Unused%20Files/next_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter/material.dart';
// import '../main.dart';
//
// class Authorize{
//
//   signInWithGoogle () async{
//     final GoogleSignInAccount? guser=await GoogleSignIn().signIn();
//     final GoogleSignInAuthentication? gauth=await guser?.authentication;
//     final credential= GoogleAuthProvider.credential(accessToken: gauth?.accessToken,idToken: gauth?.idToken);
//     UserCredential userCredential=await FirebaseAuth.instance.signInWithCredential(credential);
//     print(userCredential.user?.displayName);
//     if(userCredential.user!=null)
//       {
//         Navigator.pushReplacement(GlobalContextService.navigatorKey.currentContext!, MaterialPageRoute(builder: (context)=>GoogleNextPage()));
//       }
//
//   }
// }