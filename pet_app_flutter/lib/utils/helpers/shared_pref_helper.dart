import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  String sharedPrefUserLoggedInKey = 'ISLOGGEDIN';
  String sharedPrefUsernameKey = 'USERNAMEKEY';
  String sharedPrefUserEmailKey = 'USEREMAILKEY';

  Future<SharedPreferences> get _prefs async {
    return await SharedPreferences.getInstance();
  }

  //Saving user shared _prefs
  Future<bool> saveUserLoggedInSharedPref(bool isUserLoggedIn) async {
    return _prefs.then((prefs) => prefs.setBool(sharedPrefUserLoggedInKey, isUserLoggedIn));
  }

  Future<bool> saveUsernameSharedPref(String username) async {
    return _prefs.then((prefs) => prefs.setString(sharedPrefUsernameKey, username));
  }

  Future<bool> saveUserEmailSharedPref(String userEmail) async {
    return _prefs.then((prefs) => prefs.setString(sharedPrefUserEmailKey, userEmail));
  }

  //Getting user shared _prefs
  Future<bool> getUserLoggedInSharedPref() async {
    return _prefs.then((prefs) => prefs.getBool(sharedPrefUserLoggedInKey));
  }

  Future<String> getUsernameSharedPref() async {
    return _prefs.then((prefs) => prefs.getString(sharedPrefUsernameKey));
  }

  Future<String> getUserEmailSharedPref() async {
    return _prefs.then((prefs) => prefs.getString(sharedPrefUserEmailKey));
  }
}
