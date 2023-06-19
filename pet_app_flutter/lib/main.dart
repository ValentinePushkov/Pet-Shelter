import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/constants/constants.dart';
import 'package:pet_app/models/homeless_pet.dart';
import 'package:pet_app/models/moderation_pet.dart';
import 'package:pet_app/models/store.dart';
import 'package:pet_app/providers/adding_ad_provider.dart';
import 'package:pet_app/providers/nfc_provider.dart';
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
  @override
  void initState() {
    super.initState();
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
        StreamProvider<List<Store>>(
          create: (context) => DatabaseMethods().getStores(),
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
        Provider<LocalDatabase>(
          create: (context) => LocalDatabase(),
        ),
        ChangeNotifierProvider<NFCProvider>(
          create: (context) => NFCProvider(),
        ),
        ChangeNotifierProvider<AddingAdProvider>(
          create: (context) => AddingAdProvider(),
        ),
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
