import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy/foodStores/food%20Store%20owners%20pages/streamFoodStores.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '';
import '../foodStores/visitStores.dart'; // Import the VisitStore widget

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchInput = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: CupertinoSearchTextField(
          autofocus: true,
          onChanged: (value) {
            setState(() {
              searchInput = value.toLowerCase(); // Convert input to lowercase
            });
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: searchInput == ''
          ? Center(
        child: Text(
          'Search for any food items you want!!',
          style: TextStyle(fontSize: 20, color: Colors.blueGrey),
        ),
      )
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('foodItems')
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong!"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!.docs
              .where((e) => e['item_name']
              .toString()
              .toLowerCase()
              .contains(searchInput))
              .toList();

          return ListView(
            children: items
                .map((item) => ProductItemWidget(item: item))
                .toList(),
          );
        },
      ),
    );
  }
}

class ProductItemWidget extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> item;

  ProductItemWidget({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: CachedNetworkImage(
              imageUrl: item['item_image'].toString(),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['item_name'].toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    future: FirebaseFirestore.instance
                        .collection('foodStores')
                        .doc(item['store_id'].toString())
                        .get(),
                    builder: (context, storeSnapshot) {
                      if (storeSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (storeSnapshot.hasError) {
                        return const Text(
                          'Store: Error fetching store name',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        );
                      }
                      final storeData = storeSnapshot.data?.data();
                      final storeName = storeData?['name'] ?? 'Unknown Store';
                      return Text(
                        'Store: $storeName',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
