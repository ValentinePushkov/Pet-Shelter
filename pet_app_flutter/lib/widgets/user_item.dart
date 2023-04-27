import 'package:flutter/material.dart';
import 'package:pet_app/constants/constants.dart';
import 'package:pet_app/screens/chat_screen.dart';
import 'package:pet_app/utils/helpers/helper_functions.dart';
import 'package:pet_app/utils/services/database.dart';
import 'package:pet_app/utils/services/encryption_decryption.dart';

class UserItem extends StatefulWidget {
  final String username;
  final String avatar;
  final DatabaseMethods databaseMethods;
  UserItem(this.username, this.avatar, this.databaseMethods);

  @override
  State<UserItem> createState() => _UserItemState();
}

class _UserItemState extends State<UserItem> {
  @override
  Widget build(BuildContext context) {
    return widget.username != Constants.currentUser
        ? InkWell(
            onTap: () {
              String chatRoomID = HelperFunctions.getChatRoomId(
                widget.username,
                Constants.currentUser,
              );
              widget.databaseMethods
                  .getCurrUserChatRoomsGet(chatRoomID)
                  .then((val) {
                val.size > 0
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(chatRoomID),
                        ),
                      )
                    : createChatRoom(widget.username);
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
                          backgroundImage: widget.avatar != null
                              ? NetworkImage(widget.avatar)
                              : AssetImage('images/cat.png'),
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
                                    widget.username,
                                    style: TextStyle(
                                      fontSize: 16,
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

  createChatRoom(String username) {
    List<String> users = [username, Constants.currentUser];
    String chatRoomID =
        HelperFunctions.getChatRoomId(username, Constants.currentUser);
    Map<String, dynamic> ChatRoomMap = {
      'chatRoomID': chatRoomID,
      'users': users
    };
    widget.databaseMethods.createChatRoom(chatRoomID, ChatRoomMap);
    widget.databaseMethods.addLastChat(chatRoomID, {
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
}
