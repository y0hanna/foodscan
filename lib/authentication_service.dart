import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'components/error_dialog.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> signIn(context, {String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      Navigator.pushNamed(context, '/');
      return "Signed in";
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => errorDialog(context, e.toString()),
      );
      return e;
    }
  }

  Future<String> signUp(context, {String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      Navigator.pushNamed(context, '/');
      return "Signed up";
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => errorDialog(context, e.code),
      );
      return e;
    }
  }
}
