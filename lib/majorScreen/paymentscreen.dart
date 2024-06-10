
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy/minor%20screens/userHomescreenBottomNavBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../foodStores/providers/cart_provider.dart';

class PaymentMethod {
  final String title;
  final String logoPath;

  PaymentMethod({required this.title, required this.logoPath});
}

class PaymentScreen extends StatefulWidget {
  final double totalPrice; // Price fetched from the cart screen

  PaymentScreen({required this.totalPrice});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentMethod? _selectedPaymentMethod;
  late String orderId;
  final List<PaymentMethod> paymentMethods = [
    PaymentMethod(title: 'Google Pay', logoPath: 'assets/images/gpay.jpeg'),
    PaymentMethod(title: 'Paytm', logoPath: 'assets/images/paytm.png'),
    PaymentMethod(title: 'Debit Card', logoPath: 'assets/images/db.png'),
    // Add more payment methods as needed
  ];

  Future<void> _showOrderCompletionDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Order Completed'),
          content: const Text('Your order has been placed successfully!'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Navigate back to the home screen
                Navigator.of(context).pop(); // Navigate back to the home screen
              },
            ),
          ],
        );
      },
    );
  }
late Future<String?> userToken=FirebaseMessaging.instance.getToken();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: const Color(0xff252525), // Customize app bar color
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong!!'));
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document doesn't exist.");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Return a default widget or empty container to satisfy the return type
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text(
                      'Total Amount: \₹${widget.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Choose Payment Method:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  children: paymentMethods
                      .map(
                        (method) => ListTile(
                      leading: Radio<PaymentMethod>(
                        value: method,
                        groupValue: _selectedPaymentMethod,
                        onChanged: (value) {
                          setState(() {
                            _selectedPaymentMethod = value;
                          });
                        },
                      ),
                      title: Row(
                        children: [
                          Image.asset(
                            method.logoPath,
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            method.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = method;
                        });
                      },
                    ),
                  )
                      .toList(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    // Handle the payment process using _selectedPaymentMethod
                    if (_selectedPaymentMethod != null) {
                      for (var item in context.read<Cart>().getItems) {
                        CollectionReference orderRef =
                        FirebaseFirestore.instance.collection('orders');
                        orderId = const Uuid().v4();
                        QuerySnapshot storeQuery = await FirebaseFirestore.instance
                            .collection('foodStores')
                            .where('user_id', isEqualTo: item.storeId)
                            .get();
                        final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
                        final String? fcmToken = await _firebaseMessaging.getToken();
                        String storeName = ''; // Initialize with an empty string

                        if (storeQuery.docs.isNotEmpty) {
                          // Check if there's a matching store document
                          storeName = storeQuery.docs.first['name'];
                        }
                        await orderRef.doc(orderId).set({
                          'cust_id': data['user_id'],
                          'cust_name': data['name'],
                          'email': data['email'],
                          'phone': data['phone'],
                          'cust_image': data['profile_image'],
                          'store_id': item.storeId,
                          'store_name':storeName,
                          'pro_id': item.documentId,
                          'order_id': orderId,
                          'order_name':item.name,
                          'order_image': item.image,
                          'order_qnt': item.qnt,
                          'order_price': item.qnt * item.price,
                          'order_complete_time': '',
                          'order_status': 'Preparing',
                          'order_time': DateTime.now(),
                          'userToken':fcmToken
                        });
                      }
                      _showOrderCompletionDialog();
                      context.read<Cart>().clearCart();
                    } else {
                      // Show an error message because no payment method is selected
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a payment method.'),
                        ),
                      );
                    }
                  },
                  child: const Text('Proceed to Pay'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xff252525),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
          );// You can change this to another widget if needed
        },
      ),
    );
  }

}
