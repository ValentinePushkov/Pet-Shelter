import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_app/models/homeless_pet.dart';
import 'package:pet_app/models/user.dart';

class DatabaseMethods {
  getAllUsers() async {
    return await FirebaseFirestore.instance.collection('users').get();
  }

  Future<UserClass> getUserInfoByUsername(String username) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    return UserClass(
      username: snapshot.docs[0].data()['username'],
      avatar: snapshot.docs[0].data()['picUrl'],
    );
  }

  updateUserInfo(String username, String name, String bio) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .update({'name': name, 'bio': bio});
  }

  updateUserProfilePic(String username, String url) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .update({'picUrl': url});
  }

  getUserInfoByEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
  }

  uploadUserInfo(String username, Map<String, String> userInfoMap) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .set(userInfoMap);
  }

  createChatRoom(String chatRoomID, Map<String, dynamic> chatRoomMap) {
    FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(chatRoomID)
        .set(chatRoomMap);
  }

  addChatMessage(String chatRoomID, Map<String, dynamic> chatMessageMap) {
    FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(chatRoomID)
        .collection('chats')
        .add(chatMessageMap);
  }

  addLastChat(String chatRoomID, String lastChatMessage, int time) {
    FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(chatRoomID)
        .update({'LastChat.Message': lastChatMessage, 'LastChat.Time': time});
  }

  getChatMessage(String chatRoomID) async {
    return FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(chatRoomID)
        .collection('chats')
        .orderBy("time", descending: false)
        .snapshots();
  }

  getChatRooms(String username) async {
    return FirebaseFirestore.instance
        .collection('ChatRooms')
        .where('users', arrayContains: username)
        .snapshots();
  }

  getCurrUserChatRooms(String chatRoomID) async {
    return FirebaseFirestore.instance
        .collection('ChatRooms')
        .where('chatRoomID', isEqualTo: chatRoomID)
        .snapshots();
  }

  getCurrUserChatRoomsGet(String chatRoomID) async {
    return await FirebaseFirestore.instance
        .collection('ChatRooms')
        .where('chatRoomID', isEqualTo: chatRoomID)
        .get();
  }

  Stream<List<HomelessPet>> getHomelessPets() => FirebaseFirestore.instance
      .collection("homeless_pets")
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => HomelessPet.fromJson(doc.data()))
          .toList());
}
