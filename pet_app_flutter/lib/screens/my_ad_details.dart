import 'package:flutter/material.dart';
import 'package:pet_app/configuration/configuration.dart';
import 'package:pet_app/models/homeless_pet.dart';
import 'package:pet_app/models/user.dart';
import 'package:pet_app/screens/home_screen.dart';
import 'package:pet_app/screens/splash_screen.dart';
import 'package:pet_app/utils/services/database.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MyAdDetails extends StatefulWidget {
  MyAdDetails({this.petDetailsMap});

  HomelessPet petDetailsMap;

  @override
  _MyAdDetailsState createState() => _MyAdDetailsState();
}

class _MyAdDetailsState extends State<MyAdDetails> {
  bool isFavorite = false;
  DatabaseMethods databaseMethods = DatabaseMethods();
  UserClass user;

  @override
  void initState() {
    databaseMethods
        .getUserInfoByUsername(widget.petDetailsMap.owner)
        .then((val) {
      setState(() {
        user = val;
      });
    });
    super.initState();
  }

  void deleteAd() {
    databaseMethods.deleteAd(widget.petDetailsMap.name);
    Navigator.pop(context);
    SnackBar snackBar = SnackBar(
      content: Text(
        'Обяъявление удалено!',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Hero(
                      tag: 'pet${widget.petDetailsMap.petID}',
                      child: Image.network(widget.petDetailsMap.image),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 80, 10, 120),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: FutureProvider<UserClass>(
                                  initialData: null,
                                  create: (context) =>
                                      databaseMethods.getUserInfoByUsername(
                                    widget.petDetailsMap.owner,
                                  ),
                                  child: Consumer<UserClass>(
                                    builder: (context, user, child) {
                                      return (user != null)
                                          ? ListTile(
                                              leading: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                  user.avatar,
                                                ),
                                              ),
                                              title: Text(
                                                widget.petDetailsMap.owner,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                              subtitle: Text(
                                                'Owner',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[400],
                                                ),
                                              ),
                                            )
                                          : CircularProgressIndicator();
                                    },
                                  ),
                                ),
                              ),
                              Text(
                                widget.petDetailsMap.date,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              details,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[500],
                                letterSpacing: 0.7,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            child: Align(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Sharing Pet File"),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.ios_share,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 140,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                boxShadow: shadowList,
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.petDetailsMap.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 21.0,
                            color: Colors.grey[600],
                          ),
                        ),
                        (widget.petDetailsMap.sex == 'самец')
                            ? Icon(
                                Icons.male_rounded,
                                color: Colors.grey[500],
                                size: 30,
                              )
                            : Icon(
                                Icons.female_rounded,
                                color: Colors.grey[500],
                                size: 30,
                              ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.petDetailsMap.species,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[500],
                            letterSpacing: 0.7,
                          ),
                        ),
                        Text(
                          widget.petDetailsMap.age.toString() + ' лет',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[500],
                            letterSpacing: 0.7,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: primaryColor,
                          size: 18,
                        ),
                        SizedBox(width: 3),
                        Text(
                          widget.petDetailsMap.location,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[400],
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        width: 50,
                        child: Center(
                          child: PrimaryButton(
                            buttonText: "Удалить объявление",
                            press: deleteAd,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
