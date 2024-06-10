import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as fbs;
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'eventAndCellAdmin.dart';


class CellAdmin extends StatefulWidget {
  const CellAdmin({Key? key}) : super(key: key);

  @override
  State<CellAdmin> createState() => _CellAdminState();
}

class _CellAdminState extends State<CellAdmin> {
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  late String cell;
  final descriptionController = TextEditingController();
  final google_link_Controller = TextEditingController();
  late String eventImage;
  File? _image;
  final ImagePicker _imagePicker = ImagePicker();
  User? user = FirebaseAuth.instance.currentUser; //Firebase connection

  DateTime _selectedDate = DateTime.now();
  late TextEditingController dateController;
  late TextEditingController startTimeController = TextEditingController(
    text: _startTime.format(context),
  );
  late TextEditingController endTimeController = TextEditingController(
    text: _endTime.format(context),
  );

  @override
  void initState() {
    super.initState();
    // Initialize dateController in the initState method
    dateController = TextEditingController(
      text: _selectedDate.toLocal().toString().split(' ')[0],
    );
  }
  Future<void> sendNotificationToTopic(String topic, String title, String body) async {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'key=AAAA4kVJVfg:APA91bE_Hsf_ZgOnbNgWy18M7rFxdCiv3PaLld7CH9P3IYjoli-w2WDG5Vcf0UUUIpx1xSXgrTJFUjbiGRARO8Qg-csWue1SfJfJ45y9SNH4K0GCtGCqhhpIN5dScYJVUJRc57o16wwC', // Your FCM server key
    };

    final data = {
      'notification': {
        'title': title,
        'body': body,
      },
      'priority': 'high',
      'to': '/topics/$topic', // Send to the specified topic
    };

    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully to topic: $topic');
    } else {
      print('Failed to send notification. Status code: ${response.statusCode}');
    }
  }

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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        dateController.text = _selectedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
          startTimeController.text = _startTime.format(context);
        } else {
          _endTime = picked;
          endTimeController.text = _endTime.format(context);
        }
      });
    }
  }

  Future<bool> _confirmPostEvent(BuildContext context) async {
    DateTime selectedDate = _selectedDate;
    TimeOfDay startTime = TimeOfDay(
      hour: _startTime.hour,
      minute: _startTime.minute,
    );
    TimeOfDay endTime = TimeOfDay(
      hour: _endTime.hour,
      minute: _endTime.minute,
    );

    bool confirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Post Event"),
          content: Text("Are you sure you want to post this event?"),
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
          child: Text('Event Admin'),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
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
                              hintText: 'Enter Event Name',
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
                            onChanged: (value) {
                              cell = value;
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter cell',
                              hintStyle: TextStyle(
                                fontSize: 20,
                              ),
                              icon: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Icon(Icons.location_city),
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
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Container(
                      height: 48,
                      width: 310,
                      color: Colors.white,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: AbsorbPointer(
                              child: TextField(
                                controller: dateController,
                                decoration: InputDecoration(
                                  hintText: 'Select Event Date',
                                  hintStyle: TextStyle(
                                    fontSize: 20,
                                  ),
                                  icon: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Icon(Icons.calendar_month_outlined),
                                  ),
                                ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 25),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: Container(
                          height: 48,
                          width: 130,
                          color: Colors.white,
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () => _selectTime(context, true), // Pass true for start time
                                child: AbsorbPointer(
                                  child: TextField(
                                    controller: startTimeController,
                                    decoration: InputDecoration(
                                      hintText: 'Event Start Time',
                                      hintStyle: TextStyle(
                                        fontSize: 20,
                                      ),
                                      icon: Padding(
                                        padding: EdgeInsets.all(6),
                                        child: Icon(Icons.access_time),
                                      ),
                                    ),
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
                SizedBox(width: 30),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 25),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: Container(
                          height: 48,
                          width: 130,
                          color: Colors.white,
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () => _selectTime(context, false), // Pass false for end time
                                child: AbsorbPointer(
                                  child: TextField(
                                    controller: endTimeController,
                                    decoration: InputDecoration(
                                      hintText: 'Event End Time',
                                      hintStyle: TextStyle(
                                        fontSize: 20,
                                      ),
                                      icon: Padding(
                                        padding: EdgeInsets.all(6),
                                        child: Icon(Icons.access_time),
                                      ),
                                    ),
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
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 45),
                  child: Column(
                    children: [
                      Text('Enter Start Time'),
                    ],
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Column(
                  children: [
                    Text('Enter End Time'),
                  ],
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
                            hintText: '                   Description for event',
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
                            controller: google_link_Controller,
                            onChanged: (value) {
                              // Do something with the value, if needed
                            },
                            decoration: InputDecoration(
                              hintText: 'Link for google form',
                              hintStyle: TextStyle(
                                fontSize: 20,
                              ),
                              icon: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Icon(Icons.link),
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
                InkWell(
                  onTap: () async {

                    bool confirmed = await _confirmPostEvent(context);
                    if (confirmed) {
                      fbs.Reference ref =
                      fbs.FirebaseStorage.instance.ref('eventImages/${nameController.text.trim()}');
                      await ref.putFile(File(_image!.path));
                      eventImage = await ref.getDownloadURL();
                      Map<String, dynamic> userEventMap = {
                        'userId': user?.uid,
                        'eventName': nameController.text.trim(),
                        'eventLocation': locationController.text.trim(),
                        'eventCell': cell,
                        'eventDate':  _selectedDate,
                        'eventStartTime': startTimeController.text.trim(),
                        'eventEndTime': endTimeController.text.trim(),
                        'eventDescription': descriptionController.text.trim(),
                        'eventFormLink': google_link_Controller.text.trim(),
                        'eventImage' : eventImage,
                      };

                      await FirebaseFirestore.instance
                          .collection('Events')
                          .doc()
                          .set(userEventMap).whenComplete(() {
                        sendNotificationToTopic('events','New Event Uploaded','${nameController.text.trim()} is happening at ${_selectedDate.day}-${_selectedDate.month}-${_selectedDate.year} conducted by ${cell}');
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => Admin(),
                        ),);
                      });
                    }
                  },
                  child: Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width * .8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color(0xff252525),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Post Event',
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
            SizedBox(
              height: 20,
            )
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