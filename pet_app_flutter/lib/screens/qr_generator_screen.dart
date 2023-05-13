import 'package:flutter/material.dart';
import 'package:pet_app/constants/constants.dart';
import 'package:pet_app/screens/qr_code_screen.dart';
import 'package:pet_app/screens/splash_screen.dart';
import 'package:pet_app/utils/services/database.dart';

enum Gender { male, female }

enum PetStatus { lost, adopt }

class QrGenerator extends StatefulWidget {
  const QrGenerator({Key key}) : super(key: key);

  @override
  State<QrGenerator> createState() => _QrGeneratorState();
}

class _QrGeneratorState extends State<QrGenerator> {
  Gender _selectedGender = Gender.male;
  PetStatus _petStatus = PetStatus.adopt;
  String category;
  String pickedGender = 'самец';
  String _pickedPetSatus = 'бездомный';
  TextEditingController _nameController;
  TextEditingController _speciesController;
  TextEditingController _ageController;
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
    _ageController = TextEditingController(text: "");
    _cityController = TextEditingController(text: "");
    _streetController = TextEditingController(text: "");
    _houseController = TextEditingController(text: "");
    _descriptionController = TextEditingController(text: "");
    super.initState();
  }

  void uploadPetAd() async {
    if (formKey.currentState.validate()) {
      String petInfoMap = {
        'Имя': _nameController.text,
        'Порода': _speciesController.text,
        'Возраст': double.parse(_ageController.text),
        'Категория': category,
        'Пол': pickedGender,
        'Статус_питомца': _pickedPetSatus,
        'Хозяин': Constants.currentUser,
        'Адрес':
            '${_cityController.text}, ${_streetController.text} ${_houseController.text}',
        'Описание': _descriptionController.text,
      }.toString().replaceAll("{", "").replaceAll("}", "");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QrCode(
            petInfoMap,
          ),
        ),
      );
    } else {
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
    _ageController.clear();
    _cityController.clear();
    _descriptionController.clear();
    _nameController.clear();
    _houseController.clear();
    _speciesController.clear();
    _streetController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Название питомца:",
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
                      hint: "Название",
                      validator: (String value) {
                        return value.length > 20 ||
                                value.length < 2 ||
                                !RegExp(r'^[а-яА-Я][а-яА-Я ]*$').hasMatch(value)
                            ? 'Название питомца от 2 до 20 символов. Только буквы.'
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
                        "Порода питомца:",
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
                      hint: "Порода",
                      validator: (value) {
                        return value.length > 30 ||
                                value.length < 2 ||
                                !RegExp(r'^[а-яА-Я][а-яА-Я ]*$').hasMatch(value)
                            ? 'Порода пиитомца от 2 до 30 символов. Только буквы.'
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
                        "Возраст питомца:",
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
                      controller: _ageController,
                      icon: Icons.edit,
                      hint: "Возраст",
                      validator: (value) {
                        return value.length > 20 ||
                                value.length < 2 ||
                                value == null
                            ? 'Возраст пиитомца от 1 до 20 символов. Только цифры.'
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
                        sexWidget("Cамка", Gender.female)
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
                        "Город:",
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
                        "Улица:",
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
                                !RegExp(r'^[а-яА-Я][а-яА-Я ]*$').hasMatch(value)
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
                        "Номер дома:",
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
                                value.length < 2 ||
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
                        "Описание:",
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
                  buttonText: "Сгенерировать QR",
                  press: () async {
                    uploadPetAd();
                  },
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget sexWidget(String text, Gender gender) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          _selectedGender = gender;
          pickedGender = text;
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
          _pickedPetSatus = text;
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
