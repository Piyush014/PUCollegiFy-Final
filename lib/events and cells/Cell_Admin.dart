import 'package:dummy/events%20and%20cells/showCell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as fbs;
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../Login/login_or_register.dart';

class Cells_admin extends StatefulWidget {
  const Cells_admin({super.key});

  @override
  State<Cells_admin> createState() => _Cells_adminState();
}

class _Cells_adminState extends State<Cells_admin> {
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final siteController = TextEditingController();
  final contactController = TextEditingController();
  final descriptionController = TextEditingController();
  late String cellImage;

  File? _image;
  final ImagePicker _imagePicker = ImagePicker();
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedImage = await _imagePicker.pickImage(source: source);
      setState(() {
        _image = File(pickedImage!.path);
      });
    } catch (e) {
      print("Image pick error: $e");
    }
  }

  Future<bool> _confirmPostCell(BuildContext context) async {

    bool confirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Cell Post"),
          content: Text("Are you sure you want to post this cell?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("No"),
            ),
          ],
        );
      },
    );
    return confirmed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe6ebec),
      appBar: AppBar(
        backgroundColor: Color(0xff252525),
        automaticallyImplyLeading: false,
        title: Center(
          child: Text('Cell Admin'),
        ),
        actions: [
          IconButton(
            onPressed: () async{
              await GoogleSignIn().signOut();
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginOrRegister(),
                ),
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: Container(
                          height: 184,
                          width: 320,
                          child: _image == null
                              ? Image.asset(
                            'assets/images/click_here.jpg',
                            fit: BoxFit.fill,
                          )
                              : Image.file(_image!),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 165,
                  right: 27,
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: ((builder) => bottomSheet()),
                      );
                    },
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.black38,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Container(
                      height: 48,
                      width: 310,
                      color: Colors.white,
                      child: Column(
                        children: [
                          TextField(
                            controller: nameController,
                            onChanged: (value) {
                              // Do something with the value, if needed
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter Cell Name',
                              hintStyle: TextStyle(
                                fontSize: 20,
                              ),
                              icon: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Icon(Icons.event),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 20,
            ),

            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Container(
                      height: 48,
                      width: 310,
                      color: Colors.white,
                      child: Column(
                        children: [
                          TextField(
                            controller: locationController,
                            decoration: InputDecoration(
                              hintText: 'Enter Location',
                              hintStyle: TextStyle(
                                fontSize: 20,
                              ),
                              icon: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Icon(Icons.location_on_outlined),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 20,
            ),

            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Container(
                      height: 48,
                      width: 310,
                      color: Colors.white,
                      child: Column(
                        children: [
                          TextField(
                            controller: siteController,
                            onChanged: (value) {
                              // Do something with the value, if needed
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter website',
                              hintStyle: TextStyle(
                                fontSize: 20,
                              ),
                              icon: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Icon(Icons.search),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 20,
            ),


            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Container(
                      height: 48,
                      width: 310,
                      color: Colors.white,
                      child: Column(
                        children: [
                          TextField(
                            controller: contactController,
                            onChanged: (value) {
                              // Do something with the value, if needed
                            },
                            keyboardType: TextInputType.phone,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            decoration: InputDecoration(
                              hintText: 'Enter Contact',
                              hintStyle: TextStyle(
                                fontSize: 20,
                              ),
                              icon: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Icon(Icons.contact_page_outlined),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 20,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: Container(
                    height: 230,
                    width: 320,
                    color: Colors.white,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextField(
                          controller: descriptionController,
                          maxLines: null,
                          onChanged: (value) {
                            // Do something with the value, if needed
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Description for cell',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              height: 20,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    bool confirmed = await _confirmPostCell(context);
                    if (confirmed) {
                      fbs.Reference ref =
                      fbs.FirebaseStorage.instance.ref('cellImages/${nameController.text.trim()}');
                      await ref.putFile(File(_image!.path));
                      cellImage = await ref.getDownloadURL();
                      Map<String, dynamic> userCellMap = {
                        'userId': user?.uid,
                        'cellName': nameController.text.trim(),
                        'cellLocation': locationController.text.trim(),
                        'cellWebsite' : siteController.text.trim(),
                        'cellContact' : contactController.text.trim(),
                        'cellImage' : cellImage,
                        'cellDescription' : descriptionController.text.trim(),
                      };

                      await FirebaseFirestore.instance
                          .collection('Cell')
                          .doc()
                          .set(userCellMap).whenComplete(() {
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => sell(),
                        ),);
                      });
                    }
                  },
                  child: Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width * .8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.lightBlueAccent,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Post Cell',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Text(
            'Choose Event Image',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () => _pickImage(ImageSource.camera),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          child: Icon(
                            Icons.camera,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Text(
                            'Camera',
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _pickImage(ImageSource.gallery),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          child: Icon(
                            Icons.image,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Text(
                            'Gallery',
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}