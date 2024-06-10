import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as fbs;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class EditItem extends StatefulWidget {
  final String? itemId;

  const EditItem({Key? key, this.itemId}) : super(key: key);

  @override
  _EditItemState createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController? foodNameController;
  TextEditingController? foodPriceController;
  String? pickedFoodImage;
  bool processing = false;

  XFile? imageFile;
  dynamic pickedImageError;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    foodNameController = TextEditingController();
    foodPriceController = TextEditingController();
    loadItemData();
  }

  void loadItemData() async {
    try {
      if (widget.itemId != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('foodItems')
            .doc(widget.itemId)
            .get();

        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;
          foodNameController!.text = data['item_name'];
          foodPriceController!.text = data['item_price'].toString();
          pickedFoodImage = data['item_image'];
        }
      }
    } catch (e) {
      print('Error loading item data: $e');
    }
  }

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
  void dispose() {
    foodNameController!.dispose();
    foodPriceController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff252525),
        centerTitle: true,
        title: const Text('Edit Item'),
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
                                : (pickedFoodImage != null
                                ? ClipOval(
                              child: Image.network(
                                pickedFoodImage!,
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
                          controller: foodNameController,
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
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextFormField(
                          controller: foodPriceController,
                          keyboardType: TextInputType.number,
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
                              editFoodItem();
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

  void editFoodItem() async {
    // Check if any input is missing
    if (foodNameController!.text.isEmpty ||
        foodPriceController!.text.isEmpty) {
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
      if (imageFile != null) {
        // Upload a new image if a new one is selected
        fbs.Reference ref = fbs.FirebaseStorage.instance.ref(
          'foodItems/${FirebaseAuth.instance.currentUser!.email}/${path.basename(imageFile!.path)}',
        );

        await ref.putFile(File(imageFile!.path));
        pickedFoodImage = await ref.getDownloadURL();
      }

      CollectionReference foodItem =
      FirebaseFirestore.instance.collection('foodItems');

      await foodItem.doc(widget.itemId).update({
        'item_name': foodNameController!.text,
        'item_price': double.parse(foodPriceController!.text),
        if (pickedFoodImage != null) 'item_image': pickedFoodImage,
      });

      setState(() {
        processing = false;
        imageFile = null;
      });

      // Show a snackbar when the item is edited successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item edited successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      setState(() {
        processing = false;
      });
      print('Error editing item: $e');
      // Show a snackbar for error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error editing item. Please try again later.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
