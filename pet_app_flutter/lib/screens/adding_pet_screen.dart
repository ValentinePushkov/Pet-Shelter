import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_app/constants/constants.dart';
import 'package:pet_app/providers/adding_ad_provider.dart';
import 'package:pet_app/screens/splash_screen.dart';
import 'package:provider/provider.dart';

enum Gender { male, female }

enum PetStatus { lost, adopt }

class AddingPet extends StatefulWidget {
  const AddingPet({Key key}) : super(key: key);

  @override
  State<AddingPet> createState() => _AddingPetState();
}

class _AddingPetState extends State<AddingPet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var addingAdProvider = Provider.of<AddingAdProvider>(context);
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: addingAdProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.symmetric(
                vertical: screenSize.height * 0.05,
                horizontal: 15,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: addingAdProvider.formKey,
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
                                  image: addingAdProvider.imageFile == null
                                      ? AssetImage(Constants.catPng)
                                      : FileImage(addingAdProvider.imageFile),
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
                                      builder: (builder) => bottomSheet(
                                        screenSize,
                                        addingAdProvider,
                                      ),
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
                            controller: addingAdProvider.cityController,
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
                            controller: addingAdProvider.streetController,
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
                            controller: addingAdProvider.houseController,
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
                            controller: addingAdProvider.descriptionController,
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
                          addingAdProvider.uploadPetAd(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget bottomSheet(Size screenSize, var provider) {
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
                  provider.pickImage(ImageSource.camera, context);
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
                  provider.pickImage(ImageSource.gallery, context);
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
    var addingAdProvider = Provider.of<AddingAdProvider>(context);
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
          controller: addingAdProvider.nameController,
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
    var addingAdProvider = Provider.of<AddingAdProvider>(context);
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
          controller: addingAdProvider.speciesController,
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
    var addingAdProvider = Provider.of<AddingAdProvider>(context);
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
          controller: addingAdProvider.nfcTagController,
          icon: Icons.edit,
          hint: 'NFC-метка',
        ),
      ],
    );
  }

  Widget sexWidget(String text, Gender gender) {
    var addingAdProvider = Provider.of<AddingAdProvider>(context);
    return OutlinedButton(
      onPressed: () {
        setState(() {
          addingAdProvider.selectedGender = gender;
          if (text == 'самец') {
            addingAdProvider.pickedGender = 'male';
          } else {
            addingAdProvider.pickedGender = 'female';
          }
        });
      },
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        side: BorderSide(
          color: (addingAdProvider.selectedGender == gender)
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
            color: (addingAdProvider.selectedGender == gender)
                ? Constants.kPrimaryColor
                : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget petStatusWidget(String text, PetStatus petStatus) {
    var addingAdProvider = Provider.of<AddingAdProvider>(context);
    return OutlinedButton(
      onPressed: () {
        setState(() {
          addingAdProvider.petStatus = petStatus;
          if (text == 'потерян') {
            addingAdProvider.pickedPetStatus = 'lost';
          } else {
            addingAdProvider.pickedPetStatus = 'adopt';
          }
        });
      },
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        side: BorderSide(
          color: (addingAdProvider.petStatus == petStatus)
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
            color: (addingAdProvider.petStatus == petStatus)
                ? Constants.kPrimaryColor
                : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget categoryWidget() {
    var addingAdProvider = Provider.of<AddingAdProvider>(context);
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Constants.kPrimaryColor, width: 2),
        borderRadius: BorderRadius.circular(50),
      ),
      child: DropdownButton(
        value: addingAdProvider.category,
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
            addingAdProvider.category = newValue;
          });
        },
      ),
    );
  }
}
