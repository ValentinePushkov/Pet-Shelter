import 'package:flutter/material.dart';
import 'package:pet_app/configuration/configuration.dart';
import 'package:pet_app/constants/constants.dart';
import 'package:pet_app/models/homeless_pet.dart';
import 'package:pet_app/screens/my_ad_details.dart';
import 'package:pet_app/utils/helpers/shared_pref_helper.dart';
import 'package:provider/provider.dart';

class MyAds extends StatefulWidget {
  @override
  _MyAdsState createState() => _MyAdsState();
}

class _MyAdsState extends State<MyAds> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;

  bool isDrawerOpen = false;

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
    var homelessPets = Provider.of<List<HomelessPet>>(context)
        .where((pet) => pet.owner == Constants.currentUser)
        .toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(height: 10.0),
                  ListView.builder(
                    physics: ScrollPhysics(),
                    itemCount: homelessPets.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final homelessPet = homelessPets[index];
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
                                        homelessPet.age.toString() + ' лет',
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
            ],
          ),
        ),
      ),
    );
  }
}
