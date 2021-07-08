import 'package:flutter/material.dart';
import 'package:kassenzettel_app/constants.dart';

Widget errorDialog(context, String e) {
  String errorMessage;
  print(e);
  switch (e) {
    case "ERROR_EMAIL_ALREADY_IN_USE":
    case "account-exists-with-different-credential":
    case "email-already-in-use":
      errorMessage =
          "Diese E-Mail-Adresse ist bereits in Benutzung. Bitte gehe zur Login-Seite.";
      break;
    case "ERROR_WRONG_PASSWORD":
    case "wrong-password":
      errorMessage = "Falsche E-Mail-Adresse oder falsches Passwort.";
      break;
    case "ERROR_USER_NOT_FOUND":
    case "user-not-found":
      errorMessage = "Kein User mit dieser E-Mail-Adresse gefunden.";
      break;
    case "ERROR_USER_DISABLED":
    case "user-disabled":
      errorMessage = "User disabled.";
      break;
    case "ERROR_TOO_MANY_REQUESTS":
    case "operation-not-allowed":
      errorMessage = "Too many requests to log into this account.";
      break;
    case "ERROR_OPERATION_NOT_ALLOWED":
    case "operation-not-allowed":
      errorMessage = "Server error, please try again later.";
      break;
    case "ERROR_INVALID_EMAIL":
    case "invalid-email":
      errorMessage = "E-Mail-Adresse ungültig.";
      break;
    case "ERROR_WEAK_PASSWORD":
    case "weak-password":
      errorMessage = "Das Passwort sollte mindestens 6 Zeichen haben.";
      break;
    default:
      errorMessage = "Login nicht erfolgreich.";
      break;
  }
  return AlertDialog(
    title: Text("Das hat nicht geklappt."),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(errorMessage),
      ],
    ),
    actions: <Widget>[
      new TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Schließen', style: TextStyle(color: kAccentColor)),
      ),
    ],
  );
}
