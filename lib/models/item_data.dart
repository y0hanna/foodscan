import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kassenzettel_app/models/item.dart';

class ItemData extends ChangeNotifier {
  List<Item> _items = [];

  UnmodifiableListView<Item> get items {
    return UnmodifiableListView(_items);
  }

  void resetList() {
    _items = [];
    notifyListeners();
  }

  void addItem(String newItemTitle, double newItemPrice) {
    final item = Item(name: newItemTitle, price: newItemPrice);
    _items.add(item);

    notifyListeners();
  }

  void updateItem(Item item) {
    item.toggleChecked();
    notifyListeners();
  }

  void addCategory(String itemName, String category) {
    for (Item item in _items) {
      if (itemName == item.name) {
        item.category = category;
      }
    }
    notifyListeners();
  }

  void deleteItem(Item item) {
    _items.remove(item);
    notifyListeners();
  }

  double getSum() {
    double sum = 0.0;
    for (var item in _items) {
      sum += item.price;
    }
    double finalSum = ((sum * pow(10.0, 2)).round().toDouble() / pow(10.0, 2));
    sum = finalSum;
    notifyListeners();
    return sum;
  }
}
