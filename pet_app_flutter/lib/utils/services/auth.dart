import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pet_app/models/firebase_user.dart';
import 'package:pet_app/utils/helpers/shared_pref_helper.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser _userFromFirebaseUser(User firebaseUser) {
    try {
      return firebaseUser != null
          ? FirebaseUser(firebaseUser.uid, firebaseUser.email)
          : null;
    } on FirebaseAuthException catch (error) {
      Fluttertoast.showToast(msg: error.message, gravity: ToastGravity.TOP);
      return null;
    }
  }

  Future loginWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    } on PlatformException catch (error) {
      Fluttertoast.showToast(msg: error.message, gravity: ToastGravity.TOP);
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        Fluttertoast.showToast(
          msg: "Пользователь не существует.",
          gravity: ToastGravity.TOP,
        );
      }
      if (error.code == 'wrong-password') {
        Fluttertoast.showToast(
          msg: "Неверный пароль.",
          gravity: ToastGravity.TOP,
        );
      }
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        Fluttertoast.showToast(
          msg: "Пользователь с таким e-mail уже существует.",
          gravity: ToastGravity.TOP,
        );
      }
      if (error.code == 'weak-password') {
        Fluttertoast.showToast(
          msg: "Слабый пароль.",
          gravity: ToastGravity.TOP,
        );
      }
    }
  }

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (error) {
      Fluttertoast.showToast(msg: error.message, gravity: ToastGravity.TOP);
    }
  }

  Future signOut() async {
    try {
      SharedPrefHelper().saveUserLoggedInSharedPref(false);
      return await _auth.signOut();
    } on FirebaseAuthException catch (error) {
      Fluttertoast.showToast(msg: error.message, gravity: ToastGravity.TOP);
    }
  }

  Stream<FirebaseUser> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }
}
