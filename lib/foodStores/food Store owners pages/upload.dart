import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as fbs;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

import '../cart.dart';

class UploadNewItems extends StatefulWidget {
  const UploadNewItems({Key? key}) : super(key: key);

  @override
  _UploadNewItemsState createState() => _UploadNewItemsState();
}

class _UploadNewItemsState extends State<UploadNewItems> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String? foodName;
  late double? foodPrice;
  late String itemId;
  late String pickedFoodImage;
  bool processing = false;

  XFile? imageFile;
  dynamic pickedImageError;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void imagePicker() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 300,
        maxWidth: 300,
        imageQuality: 95,
      );
      if (pickedImage != null) {
        setState(() {
          imageFile = pickedImage;
        });
      }
    } catch (e) {
      setState(() {
        pickedImageError = e;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff252525),
        centerTitle: true,
        // automaticallyImplyLeading: false,
        title: const AppBarTitle(title: 'Add New Item'),
        elevation: 0,
      ),
      key: _scaffoldKey,
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
                                : Icon(
                              Icons.camera_alt,
                              size: 70,
                              color: Colors.grey[300],
                            ),
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
                            borderRadius: BorderRadius.circular(20)),
                        child: TextFormField(
                          onChanged: (value) {
                            foodName = value;
                          },
                          decoration: InputDecoration(
                            labelText: 'Food name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            hintText: 'Enter food item name',
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
                            borderRadius: BorderRadius.circular(20)),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            foodPrice = double.tryParse(value);
                          },
                          decoration: InputDecoration(
                            labelText: 'Price',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            hintText: 'Enter food price',
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
                              uploadFoodItem();
                            },
                            child: Text(
                              'Upload Item',
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

  void uploadFoodItem() async {
    // Check if any input is missing
    if (foodName == null ||
        foodName!.isEmpty ||
        foodPrice == null ||
        imageFile == null) {
      // Show a snackbar if any input is missing
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields and select an image.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      processing = true;
    });
    fbs.Reference ref = fbs.FirebaseStorage.instance.ref(
        'foodItems/${FirebaseAuth.instance.currentUser!.email}/${path.basename(imageFile!.path)}');

    try {
      await ref.putFile(File(imageFile!.path));
      pickedFoodImage = await ref.getDownloadURL();

      CollectionReference foodItem =
      FirebaseFirestore.instance.collection('foodItems');
      itemId = Uuid().v4();
      await foodItem.doc(itemId).set({
        'item_id': itemId,
        'item_name': foodName,
        'item_price': foodPrice,
        'item_image': pickedFoodImage,
        'store_id': FirebaseAuth.instance.currentUser!.uid
      });

      setState(() {
        processing = false;
        imageFile = null;
        formKey.currentState?.reset();
      });

      // Show a snackbar when the item is uploaded successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item uploaded successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      setState(() {
        processing = false;
      });
      print('Error uploading item: $e');
      // Show a snackbar for error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading item. Please try again later.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
