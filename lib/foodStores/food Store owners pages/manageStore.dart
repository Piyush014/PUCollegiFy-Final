import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'EditItem.dart';

class ManageStore extends StatefulWidget {
  const ManageStore({super.key});

  @override
  State<ManageStore> createState() => _ManageStoreState();
}

class _ManageStoreState extends State<ManageStore> {
  final CollectionReference EditStore = // Renamed variable to EditStore
  FirebaseFirestore.instance.collection('users');

  final Stream<DocumentSnapshot> EditStoreStream = // Renamed variable to EditStoreStream
  FirebaseFirestore.instance
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
      stream: EditStoreStream, // Updated variable name
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong!!');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final EditStoreData = snapshot.data?.data() as Map<String, dynamic>?; // Updated variable name

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
                    onPressed: () {
                      _editStore(); // Implement this function
                    },
                    icon: const Icon(Icons.edit),
                  )
                ],
                flexibleSpace: CachedNetworkImage(
                  imageUrl: EditStoreData?['profile_image'] ?? '',
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
                ),
                centerTitle: true,
                elevation: 1,
                title: Text(EditStoreData?['name'] ?? ''), // Updated variable name
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
                  return ItemCard(
                    itemName: itemData?['item_name'] ?? '',
                    itemImage: itemData?['item_image'] ?? '',
                    itemPrice: itemData?['item_price']?.toString() ?? '',
                    onEdit: () {
                      final itemId = snapshot.data!.docs[index].id;
                      _editItem(itemId); // Implement this function
                    },
                    onDelete: () {
                      final itemId = snapshot.data!.docs[index].id;
                      _deleteItem(itemId);
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  void _editStore() {
    // Implement store edit action here
  }

  void _editItem(String itemId) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditItem(itemId: itemId), // Updated variable name
    ));
  }

  Future<void> _deleteItem(String itemId) async {
    try {
      await FirebaseFirestore.instance.collection('foodItems').doc(itemId).delete();
      // Item deleted successfully
      print('Item deleted successfully');
    } catch (e) {
      // Handle any errors that occur during deletion
      print('Error deleting item: $e');
    }
  }
}

class ItemCard extends StatelessWidget {
  final String itemName;
  final String itemImage;
  final String itemPrice;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ItemCard({
    Key? key,
    required this.itemName,
    required this.itemImage,
    required this.itemPrice,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                Expanded(
                  child: Padding(
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
                            ),
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
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        onDelete(); // Call the delete callback
                      },
                      icon: const Icon(Icons.delete),
                    ),
                    SizedBox(height: 5), // Reduce the distance between icons
                    IconButton(
                      onPressed: () {
                        onEdit(); // Call the edit callback
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ManageStore(),
  ));
}
