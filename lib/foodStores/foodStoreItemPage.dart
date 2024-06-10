import 'package:flutter/material.dart';
import 'cart.dart';
import 'streamingFoodItems.dart'; // Assuming you have StreamingFoodItems.dart file

class FoodStoreItemPage extends StatefulWidget {
  final String fsname;
  final String image;
  final String storeId;

  const FoodStoreItemPage({
    Key? key,
    required this.fsname,
    required this.image,
    required this.storeId,
  }) : super(key: key);

  @override
  _FoodStoreItemPageState createState() => _FoodStoreItemPageState();
}

class _FoodStoreItemPageState extends State<FoodStoreItemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe6ebec),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
          child: AppBar(
            elevation: 0,
            title: Center(child: Text(widget.fsname)),
            flexibleSpace: Image.asset(
              widget.image,
              fit: BoxFit.cover,
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CartScreen()),
                  );
                },
                icon: Icon(Icons.shopping_cart),
              )
            ],
          ),
        ),
      ),
      body: StreamNewItem(storeId: widget.storeId),
    );
  }
}
