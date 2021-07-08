import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kassenzettel_app/models/item.dart';
import 'package:kassenzettel_app/models/receipt.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReceiptData extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  User currentUser;
  List<ScannedReceipt> _scannedReceipts = [];

  List<ScannedReceipt> get scannedReceipts {
    return _scannedReceipts;
  }

  Future getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        currentUser = user;
        print(currentUser.uid);
      }
    } catch (e) {
      print(e);
    }
    return currentUser;
  }

  void resetList() {
    _scannedReceipts = [];
    notifyListeners();
  }

  void addReceipt(int id, DateTime date, String supermarket, List<Item> items,
      double sum) async {
    final String docId = DateTime.now().toString();
    final receipt = ScannedReceipt(
        id: docId,
        date: date,
        supermarket: supermarket,
        items: items,
        sum: sum);
    _scannedReceipts.add(receipt);
    notifyListeners();
  }

  Future saveLastAddedReceipt() async {
    final _firestore = FirebaseFirestore.instance;
    final lastAdded = _scannedReceipts[_scannedReceipts.length - 1];
    double sum = 0.0;
    for (var item in lastAdded.items) {
      sum += item.price;
    }
    double finalSum = ((sum * pow(10.0, 2)).round().toDouble() / pow(10.0, 2));
    lastAdded.sum = finalSum;
    print("SUMME in savelastadded");
    print(finalSum);
    await getCurrentUser();
    print(currentUser.uid);

    _firestore
        .collection('userreceipts')
        .doc(currentUser.uid)
        .collection('receipts')
        .doc(lastAdded.id)
        .set({
      'date': lastAdded.date,
      'supermarket': lastAdded.supermarket,
      'sum': finalSum,
    });

    for (int i = 0; i < lastAdded.items.length; i++) {
      _firestore
          .collection('userreceipts')
          .doc(currentUser.uid)
          .collection('receipts')
          .doc(lastAdded.id)
          .collection('items')
          .add({
        'name': lastAdded.items[i].name,
        'price': lastAdded.items[i].price,
        'category': lastAdded.items[i].category,
        //'isChecked': lastAdded.items[i].isChecked,
      });
    }
  }

  Future getReceipts(context) async {
    Provider.of<ReceiptData>(context, listen: false).resetList();
    currentUser =
        await Provider.of<ReceiptData>(context, listen: false).getCurrentUser();
    List<Item> items = [];

    final userreceipts = await FirebaseFirestore.instance
        .collection('userreceipts')
        .doc(currentUser.uid)
        .collection('receipts')
        .get();

    for (var receipt in userreceipts.docs) {
      var itemsDoc = await FirebaseFirestore.instance
          .collection('userreceipts')
          .doc(currentUser.uid)
          .collection('receipts')
          .doc(receipt.id)
          .collection('items')
          .get();

      items = [];
      for (var item in itemsDoc.docs) {
        items.add(Item(
            name: item.data()['name'],
            price: item.data()['price'],
            category: item.data()['category']));
      }

      addReceipt(
        receipt.data()['id'],
        DateTime.parse(receipt.data()['date'].toDate().toString()),
        receipt.data()['supermarket'],
        items,
        receipt.data()['sum'],
      );
    }
  }
}
