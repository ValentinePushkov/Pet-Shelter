// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';
import 'package:pet_app/configuration/configuration.dart';
import 'package:pet_app/constants/constants.dart';
import 'package:pet_app/models/homeless_pet.dart';
import 'package:pet_app/screens/adding_pet_screen.dart';
import 'package:pet_app/screens/my_ad_details.dart';
import 'package:pet_app/screens/pet_details.dart';
import 'package:pet_app/utils/helpers/shared_pref_helper.dart';
import 'package:pet_app/utils/services/database.dart';
import 'package:pet_app/widgets/pet_status_selector.dart';
import 'package:pet_app/widgets/sex_selector.dart';
import 'package:provider/provider.dart';

class ActivePetsScreen extends StatefulWidget {
  @override
  _ActivePetsScreenState createState() => _ActivePetsScreenState();
}

class _ActivePetsScreenState extends State<ActivePetsScreen> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;

  bool isDrawerOpen = false;
  String _category;
  Gender _gender;
  PetStatus _petStatus;
  final Stream<List<HomelessPet>> databaseMethods =
      DatabaseMethods().getHomelessPets();

  setLoggedInUsername() async {
    await SharedPrefHelper().getUsernameSharedPref().then((val) {
      setState(() {
        Constants.currentUser = val;
      });
    });
  }

  @override
  void initState() {
    setState(() {
      setLoggedInUsername();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var homelessPets = Provider.of<List<HomelessPet>>(context);
    var sortedPets = _sortPets(homelessPets);

    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: Column(
                children: [
                  SizedBox(height: 30.0),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey[400],
                        ),
                        hintText: 'Поиск питомца',
                        hintStyle: TextStyle(
                          letterSpacing: 1,
                          color: Colors.grey[400],
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: GestureDetector(
                          onTap: () => showBottomSheet(
                            enableDrag: true,
                            context: context,
                            builder: (context) => SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 15.0),
                                  SexSelector(
                                    selected: _gender,
                                    onSelect: (gender) => _gender = gender,
                                  ),
                                  SizedBox(height: 15.0),
                                  PetStatusSelector(
                                    selected: _petStatus,
                                    onSelect: (petStatus) =>
                                        _petStatus = petStatus,
                                  ),
                                  SizedBox(height: 15.0),
                                  SizedBox(height: 15.0),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                    child: Text(
                                      'Применить',
                                      style: TextStyle(
                                          color: Constants.kPrimaryColor),
                                    ),
                                  ),
                                  SizedBox(height: 15.0),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        _petStatus = null;
                                        _gender = null;
                                        _category = null;
                                      });
                                    },
                                    child: Text(
                                      'Восстановить фильтры',
                                      style: TextStyle(
                                          color: Constants.kPrimaryColor),
                                    ),
                                  ),
                                  SizedBox(height: 15.0),
                                ],
                              ),
                            ),
                          ),
                          child: Icon(
                            Icons.tune_sharp,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(left: 10),
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _category = categories[index]['category'];
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: shadowList,
                                  ),
                                  child: Image(
                                    image: AssetImage(
                                      categories[index]['imagePath'],
                                    ),
                                    height: 50,
                                    width: 50,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                categories[index]['name'],
                                style: TextStyle(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  ListView.builder(
                    physics: ScrollPhysics(),
                    itemCount: sortedPets.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final homelessPet = sortedPets[index];
                      if (homelessPet != null) {}
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyAdDetails(
                                petDetailsMap: homelessPet,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 230,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        boxShadow: shadowList,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            homelessPet.image,
                                          ),
                                        ),
                                      ),
                                      margin: EdgeInsets.only(top: 40),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(
                                    top: 65,
                                    bottom: 20,
                                  ),
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                    boxShadow: shadowList,
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            homelessPet.name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 21.0,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                          (homelessPet.sex == 'male')
                                              ? Icon(
                                                  Icons.male_rounded,
                                                  color: Colors.grey[500],
                                                )
                                              : Icon(
                                                  Icons.female_rounded,
                                                  color: Colors.grey[500],
                                                ),
                                        ],
                                      ),
                                      Text(
                                        homelessPet.species,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                      Text(
                                        homelessPet.petStatus == 'adopt'
                                            ? 'Потерян'
                                            : 'Бездомный',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<HomelessPet> _sortPets(List<HomelessPet> pets) {
    var sortedPets = pets;
    if (_category != null) {
      sortedPets =
          sortedPets.where((pet) => pet.category == _category).toList();
    }
    if (_gender != null) {
      sortedPets = sortedPets.where((pet) => pet.sex == _gender.name).toList();
    }
    if (_petStatus != null) {
      sortedPets =
          sortedPets.where((pet) => pet.petStatus == _petStatus.name).toList();
    }
    return sortedPets;
  }
}
