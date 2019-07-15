import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalPrice {
    double total = 0;
    _items.forEach((productId, item) {
      total += item.price * item.quantity;
    });
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      // Change Quantity + 1
      _items.update(productId, (val) {
        return CartItem(
          id: val.id,
          price: val.price,
          quantity: val.quantity + 1,
          title: val.title,
        );
      });
    } else {
      _items.putIfAbsent(productId, () {
        return CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        );
      });
    }
    
    notifyListeners();
  }
}
