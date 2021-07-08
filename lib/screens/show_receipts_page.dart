import 'package:flutter/material.dart';
import 'package:kassenzettel_app/components/bottom_nav_bar.dart';
import 'package:kassenzettel_app/components/fab_with_speed_dial.dart';
import 'package:kassenzettel_app/components/main_app_bar.dart';
import 'package:kassenzettel_app/components/receipts_list.dart';
import '../constants.dart';

class ShowReceipts extends StatefulWidget {
  @override
  _ShowReceiptsState createState() => _ShowReceiptsState();
}

class _ShowReceiptsState extends State<ShowReceipts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        'Übersicht',
        action: <Widget>[
          IconButton(
            icon: Icon(Icons.home, color: Colors.white),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
            },
          ),
        ],
      ),
      backgroundColor: kBackgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(width: 50.0, child: FABWithSpeedDial()),
      bottomNavigationBar: BottomNavBar(0),
      body: Container(
        child: ReceiptsList(),
      ),
    );
  }
}
