import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kassenzettel_app/models/item.dart';
import 'package:kassenzettel_app/models/receipt_data.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;

  BottomNavBar(this.currentIndex);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  User currentUser;

  int _cIndex = 1;

  void _incrementTab(index) {
    if (index != 1) {
      setState(() {
        _cIndex = index;
      });
      if (_cIndex == 0) {
        Provider.of<ReceiptData>(context, listen: false).getReceipts(context);
        Navigator.pushNamed(context, '/showreceipts');
      } else if (_cIndex == 2) {
        Provider.of<ReceiptData>(context, listen: false).getReceipts(context);
        Navigator.pushNamed(context, '/statistics');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: kAccentColor,
      selectedFontSize: 15.0,
      unselectedFontSize: 15.0,
      currentIndex: widget.currentIndex, //TODO Front page muss schön aussehen
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.receipt,
            //color: widget.currentIndex == 0 ? kAccentColor : Colors.grey,
          ),
          label: 'Kassenbons',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: '.'),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.bar_chart,
            //color: widget.currentIndex == 0 ? Colors.grey : kAccentColor,
          ),
          label: 'Statistiken',
        ),
      ],
      onTap: (index) {
        _incrementTab(index);
      },
    );
  }
}
