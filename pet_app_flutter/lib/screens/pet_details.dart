import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/configuration/configuration.dart';

// ignore: must_be_immutable
class PetDetails extends StatefulWidget {
  PetDetails({this.petDetails});

  final DocumentSnapshot petDetails;

  @override
  _PetDetailsState createState() => _PetDetailsState();
}

class _PetDetailsState extends State<PetDetails> {
  bool isFavorite = false;

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
                      tag: 'pet${widget.petDetails['petID']}',
                      child: Image.network(widget.petDetails['image']),
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
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        AssetImage('images/pet_cat1.png'),
                                  ),
                                  title: Text(
                                    widget.petDetails['owner'],
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
                                ),
                              ),
                              Text(
                                widget.petDetails['date'],
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
                          widget.petDetails['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 21.0,
                            color: Colors.grey[600],
                          ),
                        ),
                        (widget.petDetails['sex'] == 'самец')
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
                          widget.petDetails['species'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[500],
                            letterSpacing: 0.7,
                          ),
                        ),
                        Text(
                          widget.petDetails['age'].toString() + ' лет',
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
                          widget.petDetails['location'],
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
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isFavorite) {
                            isFavorite = false;
                          } else {
                            isFavorite = true;
                          }
                        });
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: shadowList,
                        ),
                        child: isFavorite
                            ? Icon(
                                Icons.favorite_rounded,
                                color: Colors.redAccent,
                              )
                            : Icon(
                                Icons.favorite_border_rounded,
                                color: Colors.white,
                              ),
                      ),
                    ),
                    SizedBox(width: 30),
                    Expanded(
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: shadowList,
                        ),
                        child: Center(
                          child: Text(
                            'Adoption',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
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
