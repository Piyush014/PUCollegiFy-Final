import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy/Login/Authpage.dart';
import 'package:dummy/Login/userManagement.dart';
import 'package:dummy/events%20and%20cells/showCell.dart';
import 'package:dummy/Unused%20Files/next_page.dart';
import 'package:dummy/minor%20screens/userHomescreenBottomNavBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../events and cells/Cell_Admin.dart';
import '../events and cells/eventAndCellAdmin.dart';
import '../foodStores/food Store owners pages/foodStoreOwnerNavBar.dart';
import 'authorize.dart';
import '../main.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback? onTap;
  const LoginPage({super.key,required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

final emailController = TextEditingController();
final passwordController = TextEditingController();


class _LoginPageState extends State<LoginPage> {
  @override
  String? email;
  String? password ;
  void signUserIn(BuildContext context) async {
    showDialog(
        context: GlobalContextService.navigatorKey.currentContext!,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.toString(), password: password.toString());
      Navigator.pop(GlobalContextService.navigatorKey.currentContext!);
      User? user=FirebaseAuth.instance.currentUser;
      if( user != null){
        FirebaseFirestore.instance.collection('users').where('email',isEqualTo: user.email).get().then((docs) async {
          if (docs.docs[0].exists && docs.docs[0].data()['role']=='eventAdmin') {
            var fsname=docs.docs[0].data()['name'];
            // final SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
            // sharedPreferences.setString('role', docs.docs[0].data()['role']);
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Admin()));
          }
          else if(docs.docs[0].exists && docs.docs[0].data()['role']=='foodStoreOwner') {
            var fsname=docs.docs[0].data()['name'];
            // final SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
            // sharedPreferences.setString('role', docs.docs[0].data()['role']);
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>FoodStoreOwner(fsname: fsname,)));
          }
          else if(docs.docs[0].exists && docs.docs[0].data()['role']=='cellAdmin') {
            var fsname=docs.docs[0].data()['name'];
            // final SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
            // sharedPreferences.setString('role', docs.docs[0].data()['role']);
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>sell()));
          }

          else if(docs.docs[0].exists && docs.docs[0].data()['role']=='user') {
            var fsname=docs.docs[0].data()['name'];
            // final SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
            // sharedPreferences.setString('role', docs.docs[0].data()['role']);
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>userHomescreen()));
          }
        });
      }

    } on FirebaseAuthException catch (e) {
      Navigator.pop(GlobalContextService.navigatorKey.currentContext!);
      if (e.code == 'user-not-found') {
        showDialog(
            context: GlobalContextService.navigatorKey.currentContext!,
            builder: (context) {
              return const AlertDialog(
                title: Text('User not Found'),
              );
            });
      } else if (e.code == 'wrong-password') {
        showDialog(
            context: GlobalContextService.navigatorKey.currentContext!,
            builder: (context) {
              return const AlertDialog(
                title: Text('Wrong Password'),
              );
            });
      }
    }
  }




  Widget build(BuildContext context) {
    final widthof = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 300,
              child: Stack(
                children: [
                  Positioned(
                    top: -50,
                    height: 300,
                    width: widthof,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage("assets/images/background.png"),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    child: Container(
                      height: 300,
                      width: widthof + 20,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage("assets/images/background-2.png"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Color.fromRGBO(49, 39, 79, 1)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      TextFormField(
                        onChanged: (value){
                          email=value;
                        },

                        decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                            hintText: 'Enter email',
                            labelText: 'Email',
                            hintStyle: TextStyle(color: Colors.grey[300])),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        obscureText: true,
                        onChanged: (value){
                          password=value;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                            labelText: 'Password',
                            hintText: 'Enter password',
                            hintStyle: TextStyle(color: Colors.grey[300])),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                      child: Container(
                          height: 40,
                          width: 250,
                          margin: const EdgeInsets.symmetric(horizontal: 60),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: const Color.fromRGBO(49, 39, 79, 1)),
                          child: TextButton(
                              onPressed: () async {
                                signUserIn(context);
                              },
                              child: const Text(
                                'Sign-in',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              )))),
                  SizedBox(
                    height: 30,
                  ),

                  // SizedBox(
                  //   height: 30,
                  // ),
                  // Center(
                  //     child: Container(
                  //         height: 40,
                  //         width: 250,
                  //         margin: const EdgeInsets.symmetric(horizontal: 60),
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(50),
                  //             color: const Color.fromRGBO(49, 39, 79, 1)),
                  //         child: TextButton(
                  //             onPressed: () async {
                  //               WidgetsFlutterBinding.ensureInitialized();
                  //               await Firebase.initializeApp();
                  //              Authorize().signInWithGoogle();
                  //
                  //
                  //             },
                  //             child: const Text(
                  //               'Sign in with Google',
                  //               style: TextStyle(
                  //                 color: Colors.white,
                  //                 fontSize: 15,
                  //               ),
                  //             )))),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account? ',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Create a Guest Account',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
