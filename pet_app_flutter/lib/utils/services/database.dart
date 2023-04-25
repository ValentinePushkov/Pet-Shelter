import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_app/constants/constants.dart';
import 'package:pet_app/models/homeless_pet.dart';
import 'package:pet_app/models/moderation_per.dart';
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
      publicKey: snapshot.docs[0].data()['publicKey'],
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

  updateAd(String owner, String name) async {
    var snapshots = await FirebaseFirestore.instance
        .collection("homeless_pets")
        .where("owner", isEqualTo: owner)
        .where("name", isEqualTo: name)
        .get();
    for (final doc in snapshots.docs) {
      await doc.reference.update({'status': 'active'});
    }
  }

  Future<UserClass> getUserInfoByEmail(String email) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    return UserClass(
      username: snapshot.docs[0].data()['username'],
      email: snapshot.docs[0].data()['email'],
      avatar: snapshot.docs[0].data()['picUrl'],
      role: snapshot.docs[0].data()['role'],
    );
  }

  uploadUserInfo(String username, Map<String, dynamic> userInfoMap) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .set(userInfoMap);
  }

  uploadPetInfo(Map<String, dynamic> petInfo) {
    FirebaseFirestore.instance.collection("homeless_pets").doc().set(petInfo);
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

  updateLastChat(String chatRoomID, String lastChatMessage, int time) {
    FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(chatRoomID)
        .update({'LastChat.Message': lastChatMessage, 'LastChat.Time': time});
  }

  addLastChat(String chatRoomID, Map<String, dynamic> lastMessage) {
    FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(chatRoomID)
        .set(lastMessage, SetOptions(merge: true));
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

  deleteAd(String name) async {
    var collection = await FirebaseFirestore.instance
        .collection('homeless_pets')
        .where('owner', isEqualTo: Constants.currentUser)
        .where('name', isEqualTo: name)
        .get();
    for (final doc in collection.docs) {
      await doc.reference.delete();
    }
  }

  Stream<List<HomelessPet>> getHomelessPets() => FirebaseFirestore.instance
      .collection("homeless_pets")
      .where('status', isEqualTo: 'active')
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => HomelessPet.fromJson(doc.data()))
            .toList(),
      );

  Stream<List<ModerationPet>> getHomelessPetsForModeration() =>
      FirebaseFirestore.instance
          .collection("homeless_pets")
          .where('status', isEqualTo: 'moderation')
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => ModerationPet.fromJson(doc.data()))
                .toList(),
          );

  Stream<UserClass> getUser(String username) => FirebaseFirestore.instance
      .collection("users")
      .where('username', isEqualTo: username)
      .snapshots()
      .map(
        (snapshot) =>
            snapshot.docs.map((doc) => UserClass.fromJson(doc.data())).first,
      );

  Stream<List<HomelessPet>> getHomelessPetsByUsername() =>
      FirebaseFirestore.instance
          .collection("homeless_pets")
          .where('username', isEqualTo: Constants.currentUser)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => HomelessPet.fromJson(doc.data()))
                .toList(),
          );
}
