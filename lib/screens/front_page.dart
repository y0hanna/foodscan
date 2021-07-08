import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kassenzettel_app/components/bottom_nav_bar.dart';
import 'package:kassenzettel_app/components/fab_with_speed_dial.dart';
import 'package:kassenzettel_app/components/main_app_bar.dart';
import 'package:kassenzettel_app/constants.dart';
import 'package:provider/provider.dart';

class FrontPage extends StatefulWidget {
  @override
  _FrontPageState createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  int receiptCount;
  bool loading = true;

  dynamic images = [
    'img/avatar02.png',
    'img/avatar03.png',
    'img/avatar05.png',
    'img/avatar06.png',
  ];

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    loading = true;
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print("User logged in");
        print(loggedInUser.uid);
        final userreceipts = await FirebaseFirestore.instance
            .collection('userreceipts')
            .doc(loggedInUser.uid)
            .collection('receipts')
            .get();
        receiptCount = userreceipts.docs.length;
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    loggedInUser = context.watch<User>();
    if (loading) {
      return Container();
    } else {
      return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: MainAppBar(
            "",
            action: [
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  _auth.signOut();
                  Navigator.pushNamed(context, '/login');
                },
              ),
            ],
          ),
          backgroundColor: kBackgroundColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Schön, dass du da bist!",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: kAccentColor),
              ),
              Text(
                "Füge neue Kassenzettel hinzu, oder schaue dir deine Statistiken an.",
                textAlign: TextAlign.center,
              ),
              buildImg(),
              Text(
                loggedInUser == null ? "" : loggedInUser.email,
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: kAccentColor),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Gespeicherte Kassenzettel: ",
                    style: TextStyle(fontSize: 20),
                  ),
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: kAccentColor),
                    child: Text(
                      receiptCount == null ? "0" : receiptCount.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                  ),
                ],
              ),
            ],
          ),
          floatingActionButton:
              Container(width: 50.0, child: FABWithSpeedDial()),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomNavBar(1),
        ),
      );
    }
  }

  Container buildImg() {
    int min = 0;
    int max = images.length - 1;
    String imageName = "";
    setState(() {
      Random rnd = new Random();
      int r = min + rnd.nextInt(max - min);
      imageName = images[r].toString();
    });
    return Container(
      width: 300,
      height: 300,
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        image: DecorationImage(image: AssetImage(imageName), fit: BoxFit.fill),
      ),
    );
  }
}
