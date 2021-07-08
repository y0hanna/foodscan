import 'package:flutter/material.dart';
import 'package:kassenzettel_app/authentication_service.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class RegistrationPage extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool showSpinner = false;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  CircleAvatar(
                    radius: 100,
                    foregroundImage: AssetImage('img/icon.png'),
                    //child: Image.asset('img/icon.png'),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                      child: Text(
                    'Registrieren',
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: kAccentColor),
                  )),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      email = value;
                    },
                    cursorColor: kAccentColor,
                    decoration: InputDecoration(
                      labelText: 'E-Mail',
                      labelStyle: TextStyle(color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: kAccentColor),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    obscureText: true,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      password = value;
                    },
                    cursorColor: kAccentColor,
                    decoration: InputDecoration(
                      labelText: 'Passwort',
                      labelStyle: TextStyle(color: Colors.grey),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: kAccentColor),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  ElevatedButton(
                    child: Text('Account erstellen',
                        style: TextStyle(fontSize: 18.0)),
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        Provider.of<AuthenticationService>(context,
                                listen: false)
                            .signUp(context, email: email, password: password);
                        setState(() {
                          showSpinner = false;
                        });
                      } catch (e) {
                        setState(() {
                          showSpinner = false;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: kAccentColor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
