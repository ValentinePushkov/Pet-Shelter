import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/constants/constants.dart';
import 'package:pet_app/models/homeless_pet.dart';
import 'package:pet_app/models/moderation_per.dart';
import 'package:pet_app/utils/helpers/shared_pref_helper.dart';
import 'package:pet_app/utils/services/auth.dart';
import 'package:pet_app/utils/services/database.dart';
import 'package:pet_app/utils/services/encryption.dart';
import 'package:pet_app/utils/services/local_database.dart';
import 'package:pet_app/widgets/login_wrapper.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn;
  @override
  void initState() {
    setState(() {
      getLoggedInState();
    });
    super.initState();
  }

  getLoggedInState() async {
    await SharedPrefHelper().getUserLoggedInSharedPref().then((val) {
      setState(() {
        isLoggedIn = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<HomelessPet>>(
          create: (context) => DatabaseMethods().getHomelessPets(),
          initialData: [],
        ),
        StreamProvider<List<ModerationPet>>(
          create: (context) => DatabaseMethods().getHomelessPetsForModeration(),
          initialData: [],
        ),
        Provider<Encryption>(
          create: (context) => Encryption(),
        ),
        Provider<AuthMethods>(
          create: (context) => AuthMethods(),
        ),
        Provider<DatabaseMethods>(
          create: (context) => DatabaseMethods(),
        ),
        Provider<LocalDatabaseProvider>(
          create: (context) => LocalDatabaseProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Constants.kPrimaryColor,
            foregroundColor: Colors.white,
            shadowColor: Colors.transparent,
          ),
        ),
        home: LoginWrapper(),
      ),
    );
  }
}
