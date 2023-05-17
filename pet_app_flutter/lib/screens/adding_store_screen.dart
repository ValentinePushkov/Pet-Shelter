import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_app/constants/constants.dart';
import 'package:pet_app/screens/splash_screen.dart';
import 'package:pet_app/utils/services/database.dart';

class AddingStore extends StatefulWidget {
  const AddingStore({Key key}) : super(key: key);

  @override
  State<AddingStore> createState() => _AddingStoreState();
}

class _AddingStoreState extends State<AddingStore> {
  File imageFile;
  final picker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController _nameController;
  TextEditingController _urlController;
  TextEditingController _descriptionController;
  DatabaseMethods databaseMethods = DatabaseMethods();

  @override
  void initState() {
    _nameController = TextEditingController(text: "");
    _urlController = TextEditingController(text: "");
    _descriptionController = TextEditingController(text: "");
    super.initState();
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
    }
    Navigator.pop(context);
  }

  uploadImage() async {
    final firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child(Constants.currentUser + DateTime.now().toString());
    final task = await firebaseStorageRef.putFile(imageFile);
    return task.ref.getDownloadURL();
  }

  void uploadStore() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      String url = await uploadImage();
      Map<String, dynamic> storeInfoMap = {
        'name': _nameController.text,
        'url': _urlController.text,
        'description': _descriptionController.text,
        'image': url,
      };
      databaseMethods.uploadStoreInfo(storeInfoMap);
      SnackBar snackBar = SnackBar(
        content: Text(
          'Магазин успешно добавлен.',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      SnackBar snackBar = SnackBar(
        content: Text(
          'Некорректные поля!',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.symmetric(
                vertical: screenSize.height * 0.05,
                horizontal: 15,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  width: 4,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.1),
                                    offset: Offset(0, 10),
                                  )
                                ],
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: imageFile == null
                                      ? AssetImage(Constants.catPng)
                                      : FileImage(imageFile),
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
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                  ),
                                  color: Constants.kPrimaryColor,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (builder) =>
                                          bottomSheet(screenSize),
                                    );
                                  },
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Название магазина:",
                              style: TextStyle(
                                color: Constants.kPrimaryColor,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InputWithIcon(
                            controller: _nameController,
                            icon: Icons.edit,
                            hint: "Магазин",
                            validator: (value) {
                              return value.length > 20 || value.length < 2
                                  ? 'Название магазина должно быть от 2 до 20 символов.'
                                  : null;
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "URL магазина:",
                              style: TextStyle(
                                color: Constants.kPrimaryColor,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InputWithIcon(
                            controller: _urlController,
                            icon: Icons.edit,
                            hint: "URL",
                            validator: (value) {
                              return value.length < 2
                                  ? 'URL магазина должнен быть от 2 символов.'
                                  : null;
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Описание магазина:",
                              style: TextStyle(
                                color: Constants.kPrimaryColor,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InputWithIcon(
                            controller: _descriptionController,
                            icon: Icons.edit,
                            hint: "Описание",
                            validator: (value) {
                              return value.length > 100 ||
                                      value.length < 1 ||
                                      value == null
                                  ? 'Описание магазина должно быть от 2 до 100 символов.'
                                  : null;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      PrimaryButton(
                        buttonText: "Создать",
                        press: () async {
                          uploadStore();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
            Constants.chooseImage,
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
                  Constants.camera,
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
}
