import 'package:cached_network_image/cached_network_image.dart';
import 'package:dummy/foodStores/providers/cart_provider.dart';
import 'package:dummy/minor%20screens/userHomescreenBottomNavBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../majorScreen/paymentscreen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isExpanded = false;
  double expandableHeight=75;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe6ebec),
      appBar: AppBar(
        actions: [IconButton(onPressed: (){context.read<Cart>().clearCart();}, icon: Icon(Icons.remove_shopping_cart_outlined))],
        backgroundColor: const Color(0xff252525),
        centerTitle: true,
        // automaticallyImplyLeading: false,
        title: const AppBarTitle(title: 'Cart'),
        elevation: 0,
      ),

      body:Provider.of<Cart>(context).getItems.length==0? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your cart is empty!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xff252525), // Text color
              ),
            ),
            SizedBox(height: 50),

          ],
        ),
      )
          : SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding:
        EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: MediaQuery.of(context).size.height - kToolbarHeight-150,
          child: Consumer<Cart>(builder: (context, cart, child) {
            return ListView.builder(
              itemCount: cart.count,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox(
                          height: 120,
                          width: 120,
                          child: CachedNetworkImage(
                            imageUrl: cart.getItems[index].image,
                            fit: BoxFit.cover,
                            // height: 150,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            filterQuality: FilterQuality.low,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Right side: Name, Price, and Buttons
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cart.getItems[index].name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Price: ₹${cart.getItems[index].price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  buildQuantityButtons(cart, index),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ),
      ),
      bottomSheet: buildBottomSheet(context),
    );
  }

  Widget buildQuantityButtons(Cart cart, int index) {
    return Row(
      children: [
        cart.getItems[index].qnt == 1
            ? IconButton(
          onPressed: () {
            cart.removeItem(cart.getItems[index]);
          },
          icon: const Icon(Icons.delete_forever),
        )
            : IconButton(
          onPressed: () {
            cart.dcr(cart.getItems[index]);
          },
          icon: const Icon(Icons.remove),
        ),
        Text(
          cart.getItems[index].qnt.toString(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: () {
            cart.incr(cart.getItems[index]);
          },
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  Widget buildBottomSheet(BuildContext context) {
    return Container(
      height: expandableHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            title: const Text(
              'Order Summary',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {

              setState(() {
                _isExpanded = !_isExpanded;
                if(_isExpanded){
                  expandableHeight=320;
                }
                else{expandableHeight=75;}
              });
            },
            trailing: _isExpanded ? const Icon(Icons.keyboard_arrow_up) : const Icon(Icons.keyboard_arrow_down),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Subtotal:',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        '\₹${Provider.of<Cart>(context).totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tax (7%):',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        '\₹${(Provider.of<Cart>(context).totalAmount * 0.07).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\₹${(Provider.of<Cart>(context).totalAmount * 1.07).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: Provider.of<Cart>(context).totalAmount * 1.07==0.00?  null: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>PaymentScreen(totalPrice: Provider.of<Cart>(context).totalAmount * 1.07,)));
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Proceed to Payment',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
        ],
      ),
    );
  }

}

class AppBarTitle extends StatelessWidget {
  final String title;
  const AppBarTitle({
    required this.title,
    Key? key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
    );
  }
}
