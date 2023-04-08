import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_app/constants/constants.dart';
import 'package:pet_app/screens/splash_screen.dart';
import 'package:pet_app/utils/helpers/shared_pref_helper.dart';
import 'package:pet_app/utils/models/user.dart';
import 'package:pet_app/utils/services/auth.dart';
import 'package:pet_app/utils/services/database.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final authMethods = AuthMethods();
  final databaseMethods = DatabaseMethods();
  final nameEditingController = TextEditingController();
  final bioEditingController = TextEditingController();
  bool isNameValid = true;
  bool isBioValid = true;

  File imageFile;
  String avatar;
  User user;
  String username;
  final picker = ImagePicker();

  @override
  void initState() {
    SharedPrefHelper().getUsernameSharedPref().then((val) {
      username = val;
    });

    databaseMethods.getUserInfoByUsername(username).then((val) {
      setState(() {
        user = val;
        nameEditingController.text = user.name;
        avatar = user.avatar;
      });
    });
    super.initState();
  }

  updateUserInfo() {
    setState(() {
      nameEditingController.text.trim().length < 3 || nameEditingController.text.trim().isEmpty
          ? isNameValid = false
          : isNameValid = true;
      bioEditingController.text.trim().length > 30 || bioEditingController.text.trim().isEmpty
          ? isBioValid = false
          : isBioValid = true;
    });

    if (isNameValid && isBioValid) {
      databaseMethods.updateUserInfo(
        Constants.currentUser,
        nameEditingController.text,
        bioEditingController.text,
      );
      SnackBar snackBar = SnackBar(
        duration: Duration(seconds: 2),
        content: Text('Profile updated!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      FocusScope.of(context).unfocus();
    }
  }

  Future pickImage(ImageSource source) async {
    final temp = await picker.pickImage(
      source: source,
      maxHeight: 480,
      maxWidth: 640,
      imageQuality: 30,
    );
    if (temp != null) {
      setState(() {
        imageFile = File(temp.path);
      });
      SnackBar snackBar = SnackBar(
        content: Text('Profile Picture updated!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      final url = await uploadImage();
      databaseMethods.updateUserProfilePic(Constants.currentUser, url);
    }
    Navigator.pop(context);
  }

  uploadImage() async {
    final firebaseStorageRef =
        FirebaseStorage.instance.ref().child(Constants.currentUser + DateTime.now().toString());
    final task = await firebaseStorageRef.putFile(imageFile);
    return task.ref.getDownloadURL();
  }

  logout() {
    authMethods.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return SplashScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return user != null
        ? GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              key: scaffoldKey,
              body: Container(
                padding: EdgeInsets.symmetric(
                  vertical: screenSize.height * 0.05,
                  horizontal: 15,
                ),
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 4,
                                color: Theme.of(context).scaffoldBackgroundColor,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1),
                                  offset: Offset(0, 10),
                                )
                              ],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: imageFile == null && avatar == null
                                    ? AssetImage("images/cat.png")
                                    : imageFile != null
                                        ? FileImage(imageFile)
                                        : NetworkImage(
                                            avatar,
                                          ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 4,
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                ),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (builder) => bottomSheet(screenSize),
                                  );
                                },
                                child: Icon(
                                  Icons.camera_alt_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Text(
                        '@${user.username}',
                        style: TextStyle(
                          color: MediaQuery.of(context).platformBrightness == Brightness.light
                              ? Constants.kPrimaryColor
                              : Constants.kSecondaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.05,
                      ),
                      child: Column(
                        children: [
                          ProfileTextField(
                            context,
                            "Name",
                            "Enter name",
                            nameEditingController,
                          ),
                          ProfileTextField(
                            context,
                            "Bio",
                            "Enter bio",
                            bioEditingController,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.1,
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                updateUserInfo();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    MediaQuery.of(context).platformBrightness == Brightness.light
                                        ? Constants.kPrimaryColor
                                        : Constants.kSecondaryColor,
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                "Обновить",
                                style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 2.2,
                                  color:
                                      MediaQuery.of(context).platformBrightness == Brightness.light
                                          ? Colors.white
                                          : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                              vertical: screenSize.height * 0.25,
                            ),
                            /*padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.1,
                            ),*/
                            child: ElevatedButton(
                              onPressed: () {
                                logout();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 130,
                                  vertical: 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                "Выход",
                                style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 2.2,
                                  color:
                                      MediaQuery.of(context).platformBrightness == Brightness.light
                                          ? Colors.white
                                          : Colors.black87,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        : Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Center(child: CircularProgressIndicator()),
          );
  }

  Widget bottomSheet(Size screenSize) {
    return Container(
      height: screenSize.height * 0.14,
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          Text(
            "Выберите изображение",
            style: TextStyle(fontSize: 20.0, color: Constants.kPrimaryColor),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                icon: Icon(
                  Icons.camera,
                  color: Constants.kPrimaryColor,
                ),
                onPressed: () {
                  pickImage(ImageSource.camera);
                },
                label: Text(
                  "Камера",
                  style: TextStyle(color: Constants.kPrimaryColor),
                ),
              ),
              SizedBox(
                width: screenSize.width * 0.2,
              ),
              TextButton.icon(
                icon: Icon(
                  Icons.image,
                  color: Constants.kPrimaryColor,
                ),
                onPressed: () {
                  pickImage(ImageSource.gallery);
                },
                label: Text(
                  "Галерея",
                  style: TextStyle(color: Constants.kPrimaryColor),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget ProfileTextField(
    BuildContext context,
    String labelText,
    String placeholder,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            labelText == 'Bio' ? Icons.info_outline_rounded : Icons.account_circle_rounded,
            color: MediaQuery.of(context).platformBrightness == Brightness.light
                ? Constants.kPrimaryColor
                : Colors.grey,
          ),
          suffixIcon: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.edit,
              color: MediaQuery.of(context).platformBrightness == Brightness.light
                  ? Colors.grey
                  : Constants.kPrimaryColor,
            ),
          ),
          contentPadding: EdgeInsets.only(bottom: 3),
          labelText: labelText,
          labelStyle: TextStyle(
            color: MediaQuery.of(context).platformBrightness == Brightness.light
                ? Colors.black45
                : Colors.grey,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          errorText: labelText == 'Name'
              ? (isNameValid ? null : "Name too short")
              : (isBioValid
                  ? null
                  : bioEditingController.text.trim().isEmpty
                      ? "Bio too short"
                      : "Bio too long"),
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: MediaQuery.of(context).platformBrightness == Brightness.light
                ? Colors.black
                : Colors.white70,
          ),
        ),
      ),
    );
  }
}
