import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kassenzettel_app/authentication_service.dart';
import 'package:kassenzettel_app/text_recognition.dart';
import 'package:kassenzettel_app/screens/addmanually_page.dart';
import 'package:kassenzettel_app/screens/addreceipt_page.dart';
import 'package:kassenzettel_app/screens/front_page.dart';
import 'package:kassenzettel_app/screens/login_page.dart';
import 'package:kassenzettel_app/screens/registration_page.dart';
import 'package:kassenzettel_app/screens/show_receipts_page.dart';
import 'package:kassenzettel_app/screens/showitems_page.dart';
import 'package:kassenzettel_app/screens/statistics_page.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'models/item_data.dart';
import 'models/receipt_data.dart';
import 'models/statistics_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
          initialData: null,
        ),
        ChangeNotifierProvider(
          create: (context) => ItemData(),
        ),
        ChangeNotifierProvider(
          create: (context) => ReceiptData(),
        ),
        ChangeNotifierProvider<TextRecognition>(
          create: (context) => TextRecognition(),
        ),
        ChangeNotifierProvider<StatisticsData>(
          create: (context) => StatisticsData(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Kassenzettel App',
          theme: Theme.of(context).copyWith(
            backgroundColor: kBackgroundColor,
          ),
          initialRoute: '/auth', //TODO change back to front page
          routes: {
            '/': (context) => FrontPage(),
            '/auth': (context) => AuthenticationWrapper(),
            '/login': (context) => LoginPage(),
            '/registration': (context) => RegistrationPage(),
            '/addreceipt': (context) => AddReceipt(),
            '/addmanually': (context) => AddManually(),
            '/statistics': (context) => Statistics(),
            '/showitems': (context) => ShowItems(),
            '/showreceipts': (context) => ShowReceipts(),
            //'/details': (context) => Details(index),
          }),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      return FrontPage(); //return homepage
    } else {
      return LoginPage();
    } //return other page
  }
}
