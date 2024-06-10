import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xffe6ebec),
        appBar: AppBar(
          backgroundColor: const Color(0xff252525),
          title: const Text('Orders'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Preparing'),
              Tab(text: 'PickUp'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            OrderTab(
              status: 'Preparing',
              emptyText: 'There are no orders.',
            ),
            OrderTab(
              status: 'Ready for pickup',
              emptyText: 'There are no orders for pickups.',
            ),
            OrderTab(
              status: 'Completed',
              emptyText: 'There are no completed orders.',
            ),
          ],
        ),
      ),
    );
  }
}

class OrderTab extends StatelessWidget {
  final String status;
  final String emptyText;

  const OrderTab({
    Key? key,
    required this.status,
    required this.emptyText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('cust_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('order_status', isEqualTo: status)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong!"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.docs.isEmpty) {
          return  Center(child: Text(emptyText));
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var order = snapshot.data!.docs[index];
            return OrderItemWidget(orderData: order.data() as Map<String, dynamic>);
          },
        );
      },
    );
  }
}

class OrderItemWidget extends StatelessWidget {
  final Map<String, dynamic> orderData;

  const OrderItemWidget({
    Key? key,
    required this.orderData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl = orderData['order_image'];
    final itemName = orderData['order_name'];
    final price = orderData['order_price'];
    final quantity = orderData['order_qnt'];
    final orderTime = orderData['order_time'] as Timestamp;
    final orderCompleteTime = orderData['order_complete_time'] as String;
    // final custName = orderData['cust_name'];
    final orderId = orderData['order_id'];
    final orderStatus = orderData['order_status'];
    final storeName=orderData['store_name'];

    DateTime orderDateTime = orderTime.toDate();
    String formattedOrderTime = DateFormat('MMMM dd, yyyy h:mm a').format(orderDateTime);

    return Card(
      color: const Color(0xffe6ebec),
      margin: const EdgeInsets.all(8.0),
      elevation: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Card(
          margin: const EdgeInsets.all(8.0),
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: imageUrl,
                width: double.infinity,
                height: 150.0,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      itemName,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Price: ₹$price | Quantity: $quantity',
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),const SizedBox(height: 4.0),
                    Text(
                      'Store: $storeName',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Status: $orderStatus',
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Order Time: $formattedOrderTime',
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4.0),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
