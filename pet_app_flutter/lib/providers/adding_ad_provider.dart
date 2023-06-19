import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_app/constants/constants.dart';
import 'package:pet_app/models/homeless_pet.dart';
import 'package:pet_app/screens/adding_pet_screen.dart';
import 'package:pet_app/utils/services/database.dart';

class AddingAdProvider extends ChangeNotifier {
  DatabaseMethods databaseMethods = DatabaseMethods();
  File _imageFile;
  final _picker = ImagePicker();
  Gender _selectedGender = Gender.male;
  PetStatus _petStatus = PetStatus.adopt;
  String _category;
  String _pickedGender = 'male';
  String _pickedPetStatus = 'adopt';
  TextEditingController _nameController;
  TextEditingController _speciesController;
  TextEditingController _nfcTagController;
  TextEditingController _cityController;
  TextEditingController _streetController;
  TextEditingController _houseController;
  TextEditingController _descriptionController;

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  File get imageFile => _imageFile;
  Gender get selectedGender => _selectedGender;
  PetStatus get petStatus => _petStatus;
  String get category => _category;
  String get pickedGender => _pickedGender;
  String get pickedPetSatus => _pickedPetStatus;
  TextEditingController get nameController => _nameController;
  TextEditingController get speciesController => _speciesController;
  TextEditingController get nfcTagController => _nfcTagController;
  TextEditingController get cityController => _cityController;
  TextEditingController get streetController => _streetController;
  TextEditingController get houseController => _houseController;
  TextEditingController get descriptionController => _descriptionController;

  AddingAdProvider() {
    _nameController = TextEditingController(text: "");
    _speciesController = TextEditingController(text: "");
    _nfcTagController = TextEditingController(text: "");
    _cityController = TextEditingController(text: "");
    _streetController = TextEditingController(text: "");
    _houseController = TextEditingController(text: "");
    _descriptionController = TextEditingController(text: "");
  }

  set selectedGender(Gender gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  set pickedGender(String gender) {
    _pickedGender = gender;
    notifyListeners();
  }

  set petStatus(PetStatus petStatus) {
    _petStatus = petStatus;
    notifyListeners();
  }

  set pickedPetStatus(String petStatus) {
    _pickedPetStatus = petStatus;
    notifyListeners();
  }

  set category(String category) {
    _category = category;
    notifyListeners();
  }

  Future pickImage(ImageSource source, BuildContext context) async {
    final temp = await _picker.pickImage(
      source: source,
      maxHeight: 480,
      maxWidth: 640,
      imageQuality: 30,
    );
    if (temp != null) {
      _imageFile = File(temp.path);
      notifyListeners();
    }
    Navigator.pop(context);
  }

  uploadImage() async {
    final firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child(Constants.currentUser + DateTime.now().toString());
    final task = await firebaseStorageRef.putFile(_imageFile);
    return task.ref.getDownloadURL();
  }

  void uploadPetAd(BuildContext context) async {
    if (formKey.currentState.validate()) {
      if (_imageFile == null) {
        SnackBar snackBar = SnackBar(
          content: Text(
            Constants.addPicture,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        if (_category == null) {
          SnackBar snackBar = SnackBar(
            content: Text(
              Constants.chooseCategory,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          isLoading = true;
          notifyListeners();
          String url = await uploadImage();
          final DateTime dateToday = new DateTime.now();
          final String date = dateToday.toString().substring(0, 10);

          HomelessPet homelessPet = new HomelessPet(
            name: _nameController.text,
            species: _speciesController.text,
            nfcTag: _nfcTagController.text,
            image: url,
            category: _category,
            sex: _pickedGender,
            petStatus: _pickedPetStatus,
            owner: Constants.currentUser,
            location:
                '${_cityController.text}, ${_streetController.text} ${_houseController.text}',
            status: 'moderation',
            date: date,
            description: _descriptionController.text,
          );
          databaseMethods.uploadPetInfo(homelessPet.toJson());
          clearForm();
          SnackBar snackBar = SnackBar(
            duration: Duration(seconds: 2),
            content: Text(
              Constants.adOnModeration,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          isLoading = false;
          notifyListeners();
        }
      }
    } else {
      isLoading = false;
      notifyListeners();
      SnackBar snackBar = SnackBar(
        content: Text(
          Constants.incorrectFields,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void clearForm() {
    _nfcTagController.clear();
    _cityController.clear();
    _descriptionController.clear();
    _nameController.clear();
    _houseController.clear();
    _speciesController.clear();
    _streetController.clear();
    _imageFile = null;
  }
}
