import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_app/models/firebase_user.dart';
import 'package:pet_app/utils/helpers/shared_pref_helper.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser _userFromFirebaseUser(User firebaseUser) {
    return firebaseUser != null
        ? FirebaseUser(firebaseUser.uid, firebaseUser.email)
        : null;
  }

  Future loginWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e);
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

  Stream<FirebaseUser> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }
}
