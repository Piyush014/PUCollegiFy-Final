import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy/majorScreen/foodOrder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyStore extends StatefulWidget {
  const MyStore({Key? key});

  @override
  State<MyStore> createState() => _MyStoreState();
}

class _MyStoreState extends State<MyStore> {
  CollectionReference store = FirebaseFirestore.instance.collection('users');
  final Stream<DocumentSnapshot> storeStream = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .snapshots();
  final Stream<QuerySnapshot> itemStream = FirebaseFirestore.instance
      .collection('foodItems')
      .where('store_id', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: storeStream,
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong!!');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final storeData = snapshot.data?.data() as Map<String, dynamic>?;

        return Scaffold(
          backgroundColor: const Color(0xffe6ebec),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(200),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AppBar(
                backgroundColor: Color(0xff252525),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit),
                  )
                ],
                flexibleSpace: CachedNetworkImage(
                  imageUrl: storeData?['profile_image'] ?? '',
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
                ),
                centerTitle: true,
                elevation: 1,
                title: Text(storeData?['name'] ?? ''),
              ),
            ),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: itemStream,
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong!');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data?.docs.length ?? 0,
                itemBuilder: (context, index) {
                  final itemData =
                  snapshot.data?.docs[index].data() as Map<String, dynamic>?;
                  return itemCard(
                    context,
                    itemData?['item_name'] ?? '',
                    itemData?['item_image'] ?? '',
                    itemData?['item_price']?.toString() ?? '',
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Padding itemCard(BuildContext context, itemName, itemImage, itemPrice) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width * 0.95,
          height: 120,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 100,
                        width: 100,
                        child: CachedNetworkImage(
                          imageUrl: itemImage,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            itemName,
                            style: const TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            '₹' + itemPrice,
                            style: const TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
