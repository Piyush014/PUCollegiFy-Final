
import 'package:dummy/Unused%20Files/next_page.dart';
import 'package:dummy/minor%20screens/userHomescreenBottomNavBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_or_register.dart';
class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.hasData)
            {
              return userHomescreen();
            }
          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
