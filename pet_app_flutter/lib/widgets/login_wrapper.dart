import 'package:flutter/material.dart';
import 'package:pet_app/drawer/admin_hidden_drawer.dart';
import 'package:pet_app/drawer/hidden_drawer.dart';
import 'package:pet_app/models/firebase_user.dart';
import 'package:pet_app/models/user.dart';
import 'package:pet_app/screens/splash_screen.dart';
import 'package:pet_app/utils/services/auth.dart';
import 'package:pet_app/utils/services/database.dart';
import 'package:provider/provider.dart';

class LoginWrapper extends StatefulWidget {
  const LoginWrapper({Key key}) : super(key: key);

  @override
  State<LoginWrapper> createState() => _LoginWrapperState();
}

class _LoginWrapperState extends State<LoginWrapper> {
  final databaseMethods = DatabaseMethods();
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthMethods>(context);
    return StreamBuilder<FirebaseUser>(
      stream: auth.user,
      builder: (_, AsyncSnapshot<FirebaseUser> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            final FirebaseUser firebaseUser = snapshot.data;
            return FutureBuilder(
              future: databaseMethods.getUserInfoByEmail(firebaseUser.email),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (firebaseUser != null) {
                    final data = snapshot.data as UserClass;
                    if (data.role == 'Admin') {
                      return AdminHiddenDrawer();
                    } else {
                      return HiddenDrawer();
                    }
                  } else {
                    return SplashScreen();
                  }
                } else if (snapshot.hasError) {
                  throw snapshot.error;
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            );
          } else {
            return SplashScreen();
          }
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
