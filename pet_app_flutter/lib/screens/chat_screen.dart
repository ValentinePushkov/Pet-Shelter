import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:pet_app/constants/constants.dart';
import 'package:pet_app/models/user.dart';
import 'package:pet_app/utils/services/database.dart';
import 'package:pet_app/utils/services/encryption_decryption.dart';

class ChatScreen extends StatefulWidget {
  final String ChatRoomID;

  ChatScreen(this.ChatRoomID);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textEditingController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream<QuerySnapshot> ChatMessageStream;
  UserClass user;
  ScrollController controller = ScrollController();

  Widget chatMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: ChatMessageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                controller: controller,
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  String msg = snapshot.data.docs[index]["message"];
                  int time = snapshot.data.docs[index]["time"];
                  return ChatMessageItem(
                    EncryptionDecryption.decryptMessage(
                      encrypt.Encrypted.fromBase64(msg),
                    ),
                    Constants.currentUser == snapshot.data.docs[index]["sentBy"]
                        ? true
                        : false,
                    DateTime.fromMillisecondsSinceEpoch(time),
                  );
                },
              )
            : Container();
      },
    );
  }

  Widget ChatMessageItem(String message, bool isSentByMe, final time) {
    Size screenSize = MediaQuery.of(context).size;

    String messageDate = time.toString().substring(0, 10);
    String messageTimestamp = time.toString().substring(11, 16);
    String currDate = DateTime.fromMillisecondsSinceEpoch(
      DateTime.now().millisecondsSinceEpoch,
    ).toString().substring(0, 10);

    String messageDateFormatted =
        "${messageDate.substring(8, 10)}/${messageDate.substring(5, 7)}/${messageDate.substring(2, 4)}";

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Row(
        mainAxisAlignment:
            isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: screenSize.width * 0.6),
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: isSentByMe ? Colors.deepPurple : Color(0xFFF1E6FF),
              borderRadius: isSentByMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    )
                  : BorderRadius.only(
                      topRight: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  messageDate == currDate
                      ? messageTimestamp
                      : messageDateFormatted,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  message,
                  style: TextStyle(
                    color: isSentByMe ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  scrollToEnd() {
    Timer(
      Duration(milliseconds: 500),
      () => controller.jumpTo(controller.position.maxScrollExtent),
    );
  }

  sendMessage() {
    if (textEditingController.text.isNotEmpty) {
      String encryptedMessage =
          EncryptionDecryption.encryptMessage(textEditingController.text);
      int time = DateTime.now().millisecondsSinceEpoch;
      Map<String, dynamic> ChatMessageMap = {
        "message": encryptedMessage,
        "sentBy": Constants.currentUser,
        "time": time
      };

      databaseMethods.addChatMessage(widget.ChatRoomID, ChatMessageMap);
      databaseMethods.updateLastChat(widget.ChatRoomID, encryptedMessage, time);
      textEditingController.text = "";
      scrollToEnd();
    }
  }

  @override
  void initState() {
    databaseMethods.getChatMessage(widget.ChatRoomID).then((val) {
      setState(() {
        ChatMessageStream = val;
      });
    });
    String username = widget.ChatRoomID.replaceAll("_", "")
        .replaceAll(Constants.currentUser, "");
    databaseMethods.getUserInfoByUsername(username).then((val) {
      setState(() {
        user = val;
      });
    });
    if (controller.hasClients) {
      scrollToEnd();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    String username = widget.ChatRoomID.replaceAll("_", "")
        .replaceAll(Constants.currentUser, "");
    return user != null
        ? Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.avatar),
                    maxRadius: 22,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /*Text(
                          user.name.toUpperCase(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 6),*/
                        Text(
                          username,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(child: chatMessageList()),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 10.0,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.05,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  MediaQuery.of(context).platformBrightness ==
                                          Brightness.light
                                      ? Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.05)
                                      : Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.4),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: TextField(
                              onTap: () {
                                Timer(
                                  Duration(milliseconds: 300),
                                  () => controller.jumpTo(
                                    controller.position.maxScrollExtent,
                                  ),
                                );
                              },
                              controller: textEditingController,
                              decoration: InputDecoration(
                                hintText: "Type message...",
                                hintStyle: TextStyle(
                                  color: MediaQuery.of(context)
                                              .platformBrightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 15,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          width: screenSize.width * 0.125,
                          height: screenSize.width * 0.125,
                          child: FloatingActionButton(
                            onPressed: () {
                              sendMessage();
                            },
                            backgroundColor:
                                Constants.kPrimaryColor.withOpacity(0.9),
                            elevation: 0,
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
