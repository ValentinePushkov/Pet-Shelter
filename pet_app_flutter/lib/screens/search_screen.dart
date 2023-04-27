import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/constants/constants.dart';
import 'package:pet_app/models/user.dart';
import 'package:pet_app/utils/services/auth.dart';
import 'package:pet_app/utils/services/database.dart';
import 'package:pet_app/widgets/user_item.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  UserClass user;
  TextEditingController SearchEditingController = TextEditingController();

  QuerySnapshot UsersSnapshot;
  QuerySnapshot ChatRoomsSnapshot;

  Widget searchUsersList() {
    return user != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: 1,
            itemBuilder: (context, index) {
              return UserItem(user.username, user.avatar, databaseMethods);
            },
          )
        : Container();
  }

  Widget userList() {
    return UsersSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: UsersSnapshot.docs.length,
            itemBuilder: (context, index) {
              return UserItem(
                UsersSnapshot.docs[index]["username"],
                UsersSnapshot.docs[index]["picUrl"],
                databaseMethods,
              );
              /*return UserItem(
                UsersSnapshot.docs[index]["username"],
                UsersSnapshot.docs[index]["picUrl"],
              );*/
            },
          )
        : Container();
  }

  @override
  void initState() {
    getAllUsers();
    super.initState();
  }

  void getAllUsers() {
    databaseMethods.getAllUsers().then(
          (val) => {
            setState(() {
              UsersSnapshot = val;
            })
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return UsersSnapshot != null
        ? Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Выберите пользователя',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: screenSize.height * 0.02,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${UsersSnapshot.docs.length - 1} пользоватлей",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: screenSize.height * 0.015,
                    ),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Divider(color: Colors.white70, height: 0.5),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: screenSize.height * 0.06,
                        child: TextField(
                          controller: SearchEditingController,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Поиск пользователя...',
                            hintStyle: TextStyle(color: Colors.white70),
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Constants.kPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        databaseMethods
                            .getUserInfoByUsername(
                              SearchEditingController.text,
                            )
                            .then(
                              (val) => setState(() {
                                user = val;
                              }),
                            );
                      },
                      child: Container(
                        height: screenSize.height * 0.06,
                        width: screenSize.width * 0.125,
                        decoration: BoxDecoration(
                          color: Constants.kPrimaryColor,
                        ),
                        child: Icon(
                          Icons.search,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: user != null ? searchUsersList() : userList(),
                )
              ],
            ),
          )
        : Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Center(child: CircularProgressIndicator()),
          );
  }
}
