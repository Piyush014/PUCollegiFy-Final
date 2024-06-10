import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fbs;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';

class EditOwnerProfile extends StatefulWidget {
  @override
  _EditOwnerProfileState createState() => _EditOwnerProfileState();
}

class _EditOwnerProfileState extends State<EditOwnerProfile> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController? nameController;
  TextEditingController? emailController;
  TextEditingController? phoneController;
  TextEditingController? locationController;
  String? pickedProfileImage;
  bool processing = false;

  XFile? imageFile;
  dynamic pickedImageError;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    locationController = TextEditingController();
    loadProfileData();
  }

  void loadProfileData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;

          if (data['name'] != null) {
            nameController!.text = data['name'];
          }
          if (data['email'] != null) {
            emailController!.text = data['email'];
          }
          if (data['phone'] != null) {
            phoneController!.text = data['phone'];
          }
          if (data['location'] != null) {
            locationController!.text = data['location'];
          }

          pickedProfileImage = data['profile_image'];
        }
      }
    } catch (e) {
      print('Error loading profile data: $e');
    }
  }


  void imagePicker() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 720,
        maxWidth: 720,
      );
      if (pickedImage != null) {
        setState(() {
          imageFile = pickedImage;
          pickedProfileImage = null; // Clear the previous image URL
        });
      }
    } catch (e) {
      setState(() {
        pickedImageError = e;
      });
    }
  }



  @override
  void dispose() {
    nameController!.dispose();
    emailController!.dispose();
    phoneController!.dispose();
    locationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff252525),
        centerTitle: true,
        title: const Text('Edit Profile'),
        elevation: 0,
      ),
      backgroundColor: Color(0xffe6ebec),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          reverse: true,
          scrollDirection: Axis.vertical,
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        imagePicker();
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 2,
                              ),
                            ),
                            child: imageFile != null
                                ? ClipOval(
                              child: Image.file(
                                File(imageFile!.path),
                                width: 140,
                                height: 140,
                                fit: BoxFit.cover,
                              ),
                            )
                                : (pickedProfileImage != null
                                ? ClipOval(
                              child: Image.network(
                                pickedProfileImage!,
                                width: 140,
                                height: 140,
                                fit: BoxFit.cover,
                              ),
                            )
                                : Icon(
                              Icons.camera_alt,
                              size: 70,
                              color: Colors.grey[300],
                            )),
                          ),
                          if (pickedImageError != null)
                            Text(
                              "Error loading image",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            hintText: 'Enter your name',
                            hintStyle: TextStyle(
                              color: Colors.grey[300],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            hintText: 'Enter your email',
                            hintStyle: TextStyle(
                              color: Colors.grey[300],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Phone',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            hintText: 'Enter your phone number',
                            hintStyle: TextStyle(
                              color: Colors.grey[300],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextFormField(
                          controller: locationController,
                          decoration: InputDecoration(
                            labelText: 'Location',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            hintText: 'Enter your location',
                            hintStyle: TextStyle(
                              color: Colors.grey[300],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF0E1A1A),
                                Color(0xFF03130E),
                              ],
                            ),
                          ),
                          child: TextButton(
                            onPressed: () {
                              editOwnerProfile();
                            },
                            child: Text(
                              'Save Changes',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
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
          ),
        ),
      ),
    );
  }

  void editOwnerProfile() async {
    // Check if any input is missing
    if (nameController!.text.isEmpty ||
        emailController!.text.isEmpty ||
        phoneController!.text.isEmpty ||
        locationController!.text.isEmpty) {
      // Show a snackbar if any input is missing
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      processing = true;
    });

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      final userDocRef =
      FirebaseFirestore.instance.collection('users').doc(currentUser!.uid);

      if (imageFile != null) {
        // Use "profile_image.jpg" as the file name
        final fileName = 'profile_image.jpg';

        final storageRef = fbs.FirebaseStorage.instance
            .ref()
            .child('foodStores/${currentUser.email}/$fileName');

        // Upload a new image with the filename "profile_image.jpg"
        await storageRef.putFile(File(imageFile!.path));
        final imageUrl = await storageRef.getDownloadURL();

        // Delete the previous image if it exists
        if (pickedProfileImage != null) {
          final previousImageRef = fbs.FirebaseStorage.instance
              .refFromURL(pickedProfileImage!);

          // Delete the previous image
          await previousImageRef.delete();
        }

        await userDocRef.update({
          'name': nameController!.text,
          'email': emailController!.text,
          'phone': phoneController!.text,
          'location': locationController!.text,
          'profile_image': imageUrl, // Update with the new image URL
        });
      } else {
        // If no new image is selected, update other fields without changing the profile image
        await userDocRef.update({
          'name': nameController!.text,
          'email': emailController!.text,
          'phone': phoneController!.text,
          'location': locationController!.text,
        });
      }

      setState(() {
        processing = false;
        imageFile = null;
      });

      // Show a snackbar when the profile is edited successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile edited successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      setState(() {
        processing = false;
      });
      print('Error editing profile: $e');
      // Show a snackbar for error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error editing profile. Please try again later.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

}