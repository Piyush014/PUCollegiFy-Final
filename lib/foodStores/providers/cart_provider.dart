import 'package:flutter/material.dart';

class Product {
  late String name;
  late double price;
  late int qnt = 1;
  late String image;
  late String documentId;
  late String storeId;

  Product(
      {required this.name,
      required this.price,
      required this.qnt,
      required this.image,
      required this.documentId,
      required this.storeId});
  void increase(){
    qnt++;
  }
  void decrease(){
    qnt--;
  }
}

class Cart extends ChangeNotifier {
  final List<Product> _list = [];
  List<Product> get getItems {
    return _list;
  }

  int get count {
    return _list.length;
  }
  double get totalAmount{
    var total =0.0;
    for (var item in _list){
      total+=item.price * item.qnt;
    }
    return total;
  }
  void addItems(
    String name,
    double price,
    int qnt,
    String image,
    String documentId,
    String storeId,
  ) {
    final product = Product(
        name: name,
        price: price.toDouble(),
        qnt: qnt,
        image: image,
        documentId: documentId,
        storeId: storeId);
    _list.add(product);
    notifyListeners();
  }
  void incr(Product product){
    product.increase();
    notifyListeners();
  }

  void dcr(Product product){
    product.decrease();
    notifyListeners();
  }
  void removeItem(Product product){
    _list.remove(product);
    notifyListeners();

  }
  void clearCart(){
    _list.clear();
    notifyListeners();

  }
}
