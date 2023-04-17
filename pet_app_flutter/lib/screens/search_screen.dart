import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_app/constants/constants.dart';
import 'package:pet_app/models/user.dart';
import 'package:pet_app/screens/chat_screen.dart';
import 'package:pet_app/utils/helpers/helper_functions.dart';
import 'package:pet_app/utils/services/auth.dart';
import 'package:pet_app/utils/services/database.dart';
import 'package:pet_app/utils/services/encryption_decryption.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  UserClass user;
  TextEditingController SearchEditingController = new TextEditingController();

  QuerySnapshot UsersSnapshot;
  QuerySnapshot ChatRoomsSnapshot;

  Widget searchUsersList() {
    return user != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: 1,
            itemBuilder: (context, index) {
              return UserItem(
                user.username,
                user.name,
                user.avatar,
              );
            },
          )
        : Container();
  }

  createChatRoom(String username) {
    List<String> users = [username, Constants.currentUser];
    String chatRoomID =
        HelperFunctions.getChatRoomId(username, Constants.currentUser);
    Map<String, dynamic> ChatRoomMap = {
      'chatRoomID': chatRoomID,
      'users': users
    };
    databaseMethods.createChatRoom(chatRoomID, ChatRoomMap);
    databaseMethods.addLastChat(chatRoomID, {
      "LastChat": {
        "Message": EncryptionDecryption.encryptMessage(" "),
        "Time": 0
      }
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatScreen(chatRoomID)),
    );
  }

  Widget userList() {
    return UsersSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: UsersSnapshot.docs.length,
            itemBuilder: (context, index) {
              return UserItem(
                UsersSnapshot.docs[index]["username"],
                UsersSnapshot.docs[index]["name"],
                UsersSnapshot.docs[index]["picUrl"],
              );
            },
          )
        : Container();
  }

  Widget UserItem(String username, String name, String avatar) {
    return username != Constants.currentUser
        ? InkWell(
            onTap: () {
              String chatRoomID = HelperFunctions.getChatRoomId(
                username,
                Constants.currentUser,
              );
              databaseMethods.getCurrUserChatRoomsGet(chatRoomID).then((val) {
                val.size > 0
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(chatRoomID),
                        ),
                      )
                    : createChatRoom(username);
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(avatar),
                          maxRadius: 28,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    name[0].toUpperCase() + name.substring((1)),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    ' - @${username}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: MediaQuery.of(context)
                                                  .platformBrightness ==
                                              Brightness.light
                                          ? Colors.black54
                                          : Colors.white54,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 6),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
