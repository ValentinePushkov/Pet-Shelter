import 'package:firebase_auth/firebase_auth.dart';

import 'package:pet_app/models/user.dart';
import 'package:pet_app/utils/helpers/shared_pref_helper.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserClass _userFromFirebaseUser(User firebaseUser) {
    return firebaseUser != null ? UserClass(userID: firebaseUser.uid) : null;
  }

  Future loginWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e);
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e);
    }
  }

  Future signOut() async {
    try {
      SharedPrefHelper().saveUserLoggedInSharedPref(false);
      return await _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
