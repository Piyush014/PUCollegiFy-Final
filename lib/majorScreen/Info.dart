import 'package:flutter/material.dart';
import 'package:dummy/foodStores/cart.dart';
import 'package:dummy/foodStores/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dummy/majorScreen/HomeScreen.dart';

class InfoScreen extends StatefulWidget {
  final String storeId;

  InfoScreen({Key? key, required this.storeId}) : super(key: key);

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  late Stream<QuerySnapshot> itemStream;

  @override
  void initState() {
    super.initState();
    itemStream = FirebaseFirestore.instance
        .collection('foodItems')
        .where('store_id', isEqualTo: widget.storeId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: itemStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong!');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return buildLoadingSkeleton();
          }

          final dataDocs = snapshot.data?.docs;
          if (dataDocs == null || dataDocs.isEmpty) {
            return Center(child: Text('No food items available.'));
          }

          return ListView(
            children: dataDocs.map((DocumentSnapshot document) {
              final data = document.data() as Map<String, dynamic>?;

              if (data == null) {
                return SizedBox.shrink();
              }

              final itemName = data['item_name'] as String? ?? 'Item Name';
              final itemImage = data['item_image'] as String? ?? '';
              final itemPrice = (data['item_price'] as double?)?.toStringAsFixed(2) ?? '0';
              final itemId = data['item_id'] as String? ?? '0';

              return buildFoodMenuItem(
                itemName,
                itemImage,
                itemPrice,
                itemId,
              );
            }).toList(),
          );
        },
      ),
    );
  }

  AppBar buildCustomAppBar() {
    return AppBar(
      backgroundColor: Color(0xff252525),
      title: Text(
        'Food Items',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => CartScreen()),
            );
          },
          icon: Consumer<Cart>(
            builder: (context, cart, child) {
              return Badge(
                isLabelVisible: cart.getItems.isEmpty ? false : true,
                label: Text(cart.getItems.length.toString()),
                child: Icon(Icons.shopping_cart),
              );
            },
          ),
        ),
      ],
    );
  }

  InkWell buildFoodMenuItem(
      String itemName, String itemImage, String itemPrice, String itemId) {
    return InkWell(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 100,
                width: 100,
                child: CachedNetworkImage(
                  imageUrl: itemImage,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    itemName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '₹$itemPrice',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                final cart = context.read<Cart>();
                final item = cart.getItems.firstWhereOrNull(
                      (product) => product.documentId == itemId,
                );

                if (item != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Already in cart!'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(milliseconds: 1000),
                    ),
                  );
                } else {
                  cart.addItems(
                    itemName,
                    double.parse(itemPrice),
                    1,
                    itemImage,
                    itemId,
                    widget.storeId,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Item added to cart!'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(milliseconds: 1000),
                    ),
                  );
                }
              },
              child: Container(
                height: 40,
                width: 100,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: Text(
                    'Add to Cart',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLoadingSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300] ?? Colors.grey,
      highlightColor: Colors.grey[100] ?? Colors.grey,
      child: ListView.builder(
        itemCount: 10, // Number of skeleton items
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  color: Colors.white, // Shimmer background color
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 20,
                        color: Colors.white, // Shimmer background color
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: 200,
                        height: 16,
                        color: Colors.white, // Shimmer background color
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
