import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:pet_app/constants/constants.dart';
import 'package:pet_app/drawer/hidden_drawer.dart';
import 'package:pet_app/models/user.dart';
import 'package:pet_app/screens/chat_screen.dart';
import 'package:pet_app/screens/search_screen.dart';
import 'package:pet_app/utils/helpers/helper_functions.dart';
import 'package:pet_app/utils/helpers/shared_pref_helper.dart';
import 'package:pet_app/utils/services/auth.dart';
import 'package:pet_app/utils/services/database.dart';
import 'package:pet_app/utils/services/encryption_decryption.dart';
import 'package:pet_app/widgets/alert_dialog.dart';
import 'package:provider/provider.dart';

class ChatRooms extends StatefulWidget {
  @override
  _ChatRoomsState createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {
  AuthMethods authMethods = new AuthMethods();
  SharedPrefHelper sharedPrefHelper = new SharedPrefHelper();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream ChatRoomsStream;

  int currIndex = 0;

  Icon searchIcon = new Icon(Icons.search);
  final TextEditingController SearchEditingController =
      new TextEditingController();
  String _searchText = "";

  Widget appBarTitle = new Text(
    'Чаты',
    style: TextStyle(
      color: Colors.white60,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
  );

  _ChatRoomsState() {
    SearchEditingController.addListener(() {
      if (SearchEditingController.text.isNotEmpty) {
        setState(() {
          _searchText = SearchEditingController.text;
        });
        databaseMethods.getUserInfoByUsername(_searchText).then((val) {
          if (val != null) {
            String ChatRoomID = HelperFunctions.getChatRoomId(
              _searchText,
              Constants.currentUser,
            );
            databaseMethods.getCurrUserChatRooms(ChatRoomID).then(
                  (val) => {
                    setState(() {
                      ChatRoomsStream = val;
                    })
                  },
                );
          } else {
            getCurrUserandChats();
          }
        });
      } else {
        getCurrUserandChats();
      }
    });
  }

  void searchChatRoom() {
    setState(() {
      if (this.searchIcon.icon == Icons.search) {
        this.searchIcon = new Icon(Icons.close);
        this.appBarTitle = new TextField(
          controller: SearchEditingController,
          decoration: new InputDecoration(
            prefixIcon: new Icon(Icons.search, color: Colors.white60),
            hintText: 'Поиск пользователей',
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
          cursorColor: Colors.white54,
          style: TextStyle(color: Colors.white54),
        );
      } else {
        this.searchIcon = new Icon(Icons.search);
        this.appBarTitle = new Text(
          'Чаты',
          style: TextStyle(
            color: Colors.white60,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        );
        SearchEditingController.clear();
      }
    });
  }

  Widget chatRoomsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: ChatRoomsStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  String ChatRoomID = snapshot.data.docs[index]["chatRoomID"];
                  String lastMessage = "";
                  int lastMessageTime = 0;
                  if (snapshot.data.docs[index]["LastChat"] != null) {
                    lastMessage = EncryptionDecryption.decryptMessage(
                      encrypt.Encrypted.fromBase64(
                        snapshot.data.docs[index]["LastChat"]["Message"],
                      ),
                    );
                    lastMessageTime =
                        snapshot.data.docs[index]["LastChat"]["Time"];
                    return ChatRoomsItem(
                      ChatRoomID,
                      lastMessage,
                      DateTime.fromMillisecondsSinceEpoch(lastMessageTime),
                    );
                  }
                  return Container();
                },
              )
            : Container();
      },
    );
  }

  Widget ChatRoomsItem(
    String ChatRoomID,
    String lastMessage,
    final lastMessageTime,
  ) {
    String username =
        ChatRoomID.replaceAll('_', "").replaceAll(Constants.currentUser, "");
    String lastMessageDate = lastMessageTime.toString().substring(0, 10);

    String lastMessageTimestamp = lastMessageTime.toString().substring(11, 16);
    String currDate = DateTime.fromMillisecondsSinceEpoch(
      DateTime.now().millisecondsSinceEpoch,
    ).toString().substring(0, 10);

    String lastMessageDateFormatted =
        "${lastMessageDate.substring(8, 10)}/${lastMessageDate.substring(5, 7)}/${lastMessageDate.substring(2, 4)}";
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatScreen(ChatRoomID)),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  FutureProvider<UserClass>(
                    create: (context) =>
                        databaseMethods.getUserInfoByUsername(username),
                    initialData: null,
                    child: Consumer<UserClass>(
                      builder: (context, user, child) {
                        return (user != null)
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(user.avatar),
                                maxRadius: 28,
                              )
                            : CircularProgressIndicator();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(username, style: TextStyle(fontSize: 16)),
                        SizedBox(height: 6),
                        Text(
                          lastMessage.length > 20
                              ? lastMessage.substring(0, 20) + "..."
                              : lastMessage,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        )
                      ],
                    ),
                  ),
                  lastMessageDate != "1970-01-01"
                      ? Text(
                          lastMessageDate == currDate
                              ? lastMessageTimestamp
                              : lastMessageDateFormatted,
                          style: TextStyle(fontSize: 12),
                        )
                      : Container()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getCurrUserandChats() async {
    Constants.currentUser = await sharedPrefHelper.getUsernameSharedPref();
    databaseMethods.getChatRooms(Constants.currentUser).then(
          (val) => {
            setState(() {
              ChatRoomsStream = val;
            })
          },
        );
  }

  void LogoutPressed() async {
    final action = await AlertDialogsClass.logoutDialog(
      context,
      'Logout',
      'Are you sure you want to exit?',
    );
    if (action == DialogsAction.yes) {
      authMethods.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HiddenDrawer()),
      );
    }
  }

  @override
  void initState() {
    getCurrUserandChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        //centerTitle: true,
        elevation: 0,
        title: appBarTitle,
        leading: IconButton(
          icon: searchIcon,
          onPressed: searchChatRoom,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: LogoutPressed,
          )
        ],
      ),
      body: Container(
        child: chatRoomsList(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Constants.kPrimaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchScreen()),
          );
        },
        child: Icon(Icons.person_add_alt_1, color: Colors.white),
      ),
    );
  }
}
