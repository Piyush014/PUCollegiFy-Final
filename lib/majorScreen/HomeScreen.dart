import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy/majorScreen/Carousel.dart';
import 'package:dummy/majorScreen/Info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class Event {
  final String imageUrl;
  final String eventName;
  final String location;

  Event(this.imageUrl, this.eventName, this.location);
}

class FoodStore {
  final String imageUrl;
  final String storeName;
  final String location;

  FoodStore(this.imageUrl, this.storeName, this.location);
}

class _HomeScreenState extends State<HomeScreen> {
  late User? user;
  String? profileImageUrl;
  String? profileName;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get()
          .then((DocumentSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.exists) {
          final userData = snapshot.data();
          setState(() {
            profileImageUrl = userData?['profile_image'];
            profileName = userData?['name'];
          });
        }
      });
    }
  }

  final List<Event> events = [
    Event(
      'assets/edm.jpg',
      "New Year's Eve",
      'Dhoom Ground',
    ),
    Event(
      'assets/d.jpg',
      "Dhoom Festival",
      'Dhoom Ground',
    ),
    Event(
      'assets/projection.jpg',
      "Projections 2024",
      'Dhoom Ground',
    ),
    Event(
      'assets/sem.jpg',
      "EDC Seminar",
      'Central Seminar Hall',
    ),
  ];

  final Stream<QuerySnapshot> foodStoresStream =
  FirebaseFirestore.instance.collection('foodStores').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFE6EBEC),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 60.0, left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 30,
                          backgroundImage:
                          CachedNetworkImageProvider(profileImageUrl ?? ''),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Welcome Back! 👋',
                              style: TextStyle(
                                fontFamily: 'Amethysta',
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF7D7979),
                              ),
                            ),
                            Text(
                              profileName ?? '',
                              style: TextStyle(
                                fontFamily: 'Amethysta',
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor:
                        Color.fromRGBO(255, 255, 255, 0.60),
                        backgroundImage: AssetImage('assets/img_1.png'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Trending this month',
                        style: TextStyle(
                          fontFamily: 'Amethysta',
                          fontSize: 18,
                          color: Color(0xFF625D5D),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 0.0, right: 0),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 175,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 1.0,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      autoPlayInterval: Duration(seconds: 5),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                    ),
                    items: [
                      GestureDetector(
                        child: Container(
                          child: Image.asset(
                            'assets/ganesha.png',
                            width: 400,
                            height: 200,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => Carousel()));
                        },
                      ),
                      Container(
                        child: Image.asset(
                          'assets/img_7.png',
                          width: 400,
                          height: 200,
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          child: Image.asset(
                            'assets/img_6.png',
                            width: 400,
                            height: 200,
                          ),
                        ),
                        // onTap: () {
                        //   Navigator.of(context).push(MaterialPageRoute(
                        //       builder: (context) => Carousel2()));
                        // },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Upcoming Events',
                        style: TextStyle(
                          fontFamily: 'Amethysta',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF625D5D),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Text(
                          'View More',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  height: 210,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: events.map((event) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 40.0),
                        child: EventCard(
                          imageUrl: event.imageUrl,
                          eventName: event.eventName,
                          location: event.location,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Popular Food Stores Nearby',
                        style: TextStyle(
                          fontFamily: 'Amethysta',
                          color: Color(0xFF625D5D),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Text(
                          'View More',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),


                StreamBuilder<QuerySnapshot>(
                  stream: foodStoresStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    final foodStoresData = snapshot.data!.docs;

                    return Container(
                      height: 210,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: foodStoresData.length,
                        itemBuilder: (context, index) {
                          final foodStore =
                          foodStoresData[index].data() as Map<String, dynamic>;
                          return GestureDetector(
                            onTap: () {
                              // Navigate to InfoScreen and pass necessary data
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => InfoScreen(
                                    storeId: foodStore['storeId'] ?? 'DefaultStoreId',
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 40.0),
                              child: FoodStoreCard(
                                storeName: foodStore['name'] ?? 'Store Name',
                                index: index,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Info Section',
                        style: TextStyle(
                          fontFamily: 'Amethysta',
                          fontSize: 18,
                          color: Color(0xFF625D5D),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                InfoSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String imageUrl;
  final String eventName;
  final String location;

  EventCard({
    required this.imageUrl,
    required this.eventName,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 251,
      height: 203,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 251,
                height: 143,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  image: DecorationImage(
                    image: AssetImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eventName,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Amethysta',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(location),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 18,
            child: Image.asset(
              'assets/images/home/img.png',
              width: 35,
              height: 35,
            ),
          ),
        ],
      ),
    );
  }
}

class FoodStoreCard extends StatelessWidget {
  final String storeName;
  final int index;

  FoodStoreCard({
    required this.storeName,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 251,
      height: 203,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 251,
                height: 143,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  image: DecorationImage(
                    image: AssetImage(_getImageAsset(index)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      storeName,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Amethysta',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text('Store Location'),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 18,
            child: Image.asset(
              'assets/images/home/img.png',
              width: 35,
              height: 35,
            ),
          ),
        ],
      ),
    );
  }

  String _getImageAsset(int index) {
    List<String> foodStoreImages = [
      'assets/idli.jpg',
      'assets/ShrirangFood.jpg',
      'assets/PheonixFoods.jpg',
      'assets/CRJuice.jpg',
      'assets/HonestOmlets.jpg',
    ];

    if (index >= 0 && index < foodStoreImages.length) {
      return foodStoreImages[index];
    } else {
      return 'assets/default_image.png';
    }
  }
}

class InfoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Info Section Title',
            style: TextStyle(
              fontFamily: 'Amethysta',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF625D5D),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
