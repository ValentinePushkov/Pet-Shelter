import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_app/constants/constants.dart';
import 'package:pet_app/screens/splash_screen.dart';
import 'package:pet_app/utils/services/database.dart';

enum Gender { male, female }

enum PetStatus { lost, adopt }

class AddingPet extends StatefulWidget {
  const AddingPet({Key key}) : super(key: key);

  @override
  State<AddingPet> createState() => _AddingPetState();
}

class _AddingPetState extends State<AddingPet> {
  File imageFile;
  final picker = ImagePicker();
  Gender _selectedGender = Gender.male;
  PetStatus _petStatus = PetStatus.adopt;
  String category;
  String pickedGender = 'male';
  String _pickedPetSatus = 'adopt';
  TextEditingController _nameController;
  TextEditingController _speciesController;
  TextEditingController _nfcTagController;
  TextEditingController _cityController;
  TextEditingController _streetController;
  TextEditingController _houseController;
  TextEditingController _descriptionController;
  DatabaseMethods databaseMethods = DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    _nameController = TextEditingController(text: "");
    _speciesController = TextEditingController(text: "");
    _nfcTagController = TextEditingController(text: "");
    _cityController = TextEditingController(text: "");
    _streetController = TextEditingController(text: "");
    _houseController = TextEditingController(text: "");
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

  void uploadPetAd() async {
    if (formKey.currentState.validate()) {
      if (imageFile == null) {
        SnackBar snackBar = SnackBar(
          content: Text(
            'Добавьте изображение.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        if (category == null) {
          SnackBar snackBar = SnackBar(
            content: Text(
              'Выберите категорию.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          setState(() {
            isLoading = true;
          });
          String url = await uploadImage();
          final DateTime dateToday = new DateTime.now();
          final String date = dateToday.toString().substring(0, 10);
          Map<String, dynamic> petInfoMap = {
            'name': _nameController.text,
            'species': _speciesController.text,
            'nfcTag': _nfcTagController.text,
            'image': url,
            'category': category,
            'sex': pickedGender,
            'petStatus': _pickedPetSatus,
            'owner': Constants.currentUser,
            'location':
                '${_cityController.text}, ${_streetController.text} ${_houseController.text}',
            'status': 'moderation',
            'date': date,
            'description': _descriptionController.text,
          };
          databaseMethods.uploadPetInfo(petInfoMap);
          SnackBar snackBar = SnackBar(
            content: Text(
              'Объявление отправлено на модерацию.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          setState(() {
            isLoading = false;
          });
        }
      }
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

  void clearControllers() {
    _nfcTagController.clear();
    _cityController.clear();
    _descriptionController.clear();
    _nameController.clear();
    _houseController.clear();
    _speciesController.clear();
    _streetController.clear();
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
                      petName(),
                      SizedBox(
                        height: 20,
                      ),
                      petSpecies(),
                      SizedBox(
                        height: 20,
                      ),
                      petNfcTag(),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Пол питомца:",
                              style: TextStyle(
                                color: Constants.kPrimaryColor,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              sexWidget("Самец", Gender.male),
                              SizedBox(
                                width: 20,
                              ),
                              sexWidget("Самка", Gender.female)
                            ],
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
                              "Категория питомца:",
                              style: TextStyle(
                                color: Constants.kPrimaryColor,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          categoryWidget(),
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
                              "Город*:",
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
                            controller: _cityController,
                            icon: Icons.edit,
                            hint: "Город",
                            validator: (value) {
                              return value.length > 20 ||
                                      value.length < 2 ||
                                      !RegExp(r'^[а-яА-Я]*$').hasMatch(value)
                                  ? 'Название города должно быть от 2 до 20 символов.'
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
                              "Улица*:",
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
                            controller: _streetController,
                            icon: Icons.edit,
                            hint: "Улица",
                            validator: (value) {
                              return value.length > 20 ||
                                      value.length < 2 ||
                                      !RegExp(r'^[а-яА-Я][а-яА-Я ]*$')
                                          .hasMatch(value)
                                  ? 'Название улицы должно быть от 2 до 20 символов.'
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
                              "Номер дома*:",
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
                            controller: _houseController,
                            icon: Icons.edit,
                            hint: "Номер дома",
                            validator: (value) {
                              return value.length > 20 ||
                                      value.length < 1 ||
                                      value == null
                                  ? 'Номер дома должнен быть от 2 до 20 символов. Только цифры.'
                                  : null;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Статус питомца:",
                                  style: TextStyle(
                                    color: Constants.kPrimaryColor,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  petStatusWidget("Бездомный", PetStatus.adopt),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  petStatusWidget("Потерян", PetStatus.lost),
                                ],
                              ),
                            ],
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
                              Constants.description,
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
                            hint: Constants.descriptionHint,
                            validator: (value) {
                              return value.length > 300 ||
                                      value.length < 10 ||
                                      !RegExp(r'^[а-яА-Я][а-яА-Я ,.:-]*$')
                                          .hasMatch(value)
                                  ? 'Описание должно быть от 10 до 300 символов.'
                                  : null;
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      PrimaryButton(
                        buttonText: "Создать",
                        press: () async {
                          uploadPetAd();
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

  Widget petName() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            Constants.name,
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
          hint: Constants.nameHint,
          validator: (String value) {
            return value.length > 20 ||
                    value.length < 2 ||
                    !RegExp(r'^[а-яА-Я][а-яА-Я ]*$').hasMatch(value)
                ? 'Название питомца от 2 до 20 символов. Только буквы.'
                : null;
          },
        ),
      ],
    );
  }

  Widget petSpecies() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            Constants.species,
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
          controller: _speciesController,
          icon: Icons.edit,
          hint: Constants.speciesHint,
          validator: (value) {
            return value.length > 30 ||
                    value.length < 2 ||
                    !RegExp(r'^[а-яА-Я][а-яА-Я ]*$').hasMatch(value)
                ? 'Порода питомца от 2 до 30 символов. Только буквы.'
                : null;
          },
        ),
      ],
    );
  }

  Widget petNfcTag() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'NFC-метка питомца:',
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
          controller: _nfcTagController,
          icon: Icons.edit,
          hint: 'NFC-метка',
        ),
      ],
    );
  }

  Widget sexWidget(String text, Gender gender) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          _selectedGender = gender;
          if (text == 'самец') {
            pickedGender = 'male';
          } else {
            pickedGender = 'female';
          }
        });
      },
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        side: BorderSide(
          color: (_selectedGender == gender)
              ? Constants.kPrimaryColor
              : Colors.grey,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: (_selectedGender == gender)
                ? Constants.kPrimaryColor
                : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget petStatusWidget(String text, PetStatus petStatus) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          _petStatus = petStatus;
          if (text == 'потерян') {
            _pickedPetSatus = 'lost';
          } else {
            _pickedPetSatus = 'adopt';
          }
        });
      },
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        side: BorderSide(
          color:
              (_petStatus == petStatus) ? Constants.kPrimaryColor : Colors.grey,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: (_petStatus == petStatus)
                ? Constants.kPrimaryColor
                : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget categoryWidget() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Constants.kPrimaryColor, width: 2),
        borderRadius: BorderRadius.circular(50),
      ),
      child: DropdownButton(
        value: category,
        icon: Icon(
          Icons.arrow_drop_down,
          color: Constants.kPrimaryColor,
        ),
        hint: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            "Категория:",
            style: TextStyle(
              color: Constants.kPrimaryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        iconSize: 36,
        isExpanded: true,
        underline: SizedBox(),
        items: Constants.category.map((valueItem) {
          return DropdownMenuItem(
            value: valueItem,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                valueItem,
                style: TextStyle(
                  color: Constants.kPrimaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            category = newValue;
          });
        },
      ),
    );
  }
}
