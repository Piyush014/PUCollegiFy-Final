import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart' as fbs;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy/Login/login_or_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../main.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isVisible = false;
  late String profileImage;
  late String email;
  late String name;
  late String password;
  late String phone='';
  late String address='';
  late String role = 'user';


  void signUserUp() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    showDialog(
        context: GlobalContextService.navigatorKey.currentContext!,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email, password: password);
    fbs.Reference ref =
        fbs.FirebaseStorage.instance.ref('users_profile_images/$email.jpg');
    await ref.putFile(File(imageFile!.path));
    profileImage = await ref.getDownloadURL();
    final String userID=FirebaseAuth.instance.currentUser!.uid;
    final String? fcmToken = await _firebaseMessaging.getToken();
    await users.doc(userID).set({
      'name': name,
      'email': email,
      'profile_image': profileImage,
      'phone': phone,
      'address': address,
      'user_id': FirebaseAuth.instance.currentUser!.uid,
      'role':role,
      'userToken':fcmToken
    });
    // Future addUserDetails(String name, String email) async {
    //   final docUser = FirebaseFirestore.instance.collection('users').doc(email);
    //   final user = User(id: email, name: name, email: email, role: 'guest');
    //   final json = user.toJson();
    //   await docUser.set(json);
    // }


    // addUserDetails(
    //   nameController.text.trim(),
    //   emailController.text.trim(),
    // );

    Navigator.pop(GlobalContextService.navigatorKey.currentContext!);

    Navigator.pushReplacement(GlobalContextService.navigatorKey.currentContext!,
        MaterialPageRoute(builder: (context) => const LoginOrRegister()));
  }

  XFile? imageFile;
  dynamic pickedImageError;
  void imagePicker() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        imageFile = pickedImage!;
      });
    } catch (e) {
      setState(() {
        pickedImageError = e;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final widthof = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: const Text(
                        "New Account",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Color.fromRGBO(49, 39, 79, 1)),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                        child: GestureDetector(
                      onTap: () {
                        imagePicker();
                      },
                      child: CircleAvatar(
                        backgroundImage: imageFile != null
                            ? FileImage(File(imageFile!.path))
                            : FileImage(File('assets/images/click_here.jpg')),
                        //,
                        radius: 70,
                      ),
                    )),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        TextFormField(
                          onChanged: (value){
                            name=value;
                          },

                          decoration: InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              hintText: 'Enter your name',
                              hintStyle: TextStyle(
                                  color: Colors.grey[300],
                                  fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          onChanged: (value){
                            email=value;
                          },

                          decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              hintText: 'Enter your email',
                              hintStyle: TextStyle(
                                  color: Colors.grey[300],
                                  fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          onChanged: (value){
                            password=value;
                          },
                          obscureText: isVisible,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(isVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    isVisible = !isVisible;
                                  });
                                },
                              ),
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              hintText: 'Enter password',
                              hintStyle: TextStyle(
                                  color: Colors.grey[300],
                                  fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          height: 5,
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
                                  signUserUp();
                                },
                                child: const Text(
                                  'Sign-up',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                )))),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            'Login Now',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
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
      ),
    );
  }
}

