import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pet_app/constants/constants.dart';
import 'package:pet_app/models/homeless_pet.dart';
import 'package:pet_app/models/moderation_pet.dart';
import 'package:pet_app/models/store.dart';
import 'package:pet_app/models/user.dart';

class DatabaseMethods {
  getAllUsers() async {
    return await FirebaseFirestore.instance.collection('users').get();
  }

  Future<UserClass> getUserInfoByUsername(String username) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();
      return snapshot == null || snapshot.size == 0
          ? null
          : UserClass(
              username: snapshot.docs[0].data()['username'],
              avatar: snapshot.docs[0].data()['picUrl'],
              publicKey: snapshot.docs[0].data()['publicKey'],
            );
    } on FirebaseException catch (error) {
      Fluttertoast.showToast(msg: error.message, gravity: ToastGravity.TOP);
      return null;
    }
  }

  updateUserInfo(String username, String name) async {
    try {
      return await FirebaseFirestore.instance
          .collection('users')
          .doc(username)
          .update({'name': name});
    } on FirebaseException catch (error) {
      Fluttertoast.showToast(msg: error.message, gravity: ToastGravity.TOP);
    }
  }

  updateUserProfilePic(String username, String url) async {
    try {
      return await FirebaseFirestore.instance
          .collection('users')
          .doc(username)
          .update({'picUrl': url});
    } on FirebaseException catch (error) {
      Fluttertoast.showToast(msg: error.message, gravity: ToastGravity.TOP);
    }
  }

  updateAd(String owner, String name) async {
    try {
      var snapshots = await FirebaseFirestore.instance
          .collection("homeless_pets")
          .where("owner", isEqualTo: owner)
          .where("name", isEqualTo: name)
          .get();
      for (final doc in snapshots.docs) {
        await doc.reference.update({'status': 'active'});
      }
    } on FirebaseException catch (error) {
      Fluttertoast.showToast(msg: error.message, gravity: ToastGravity.TOP);
    }
  }

  Future<UserClass> getUserInfoByEmail(String email) async {
    try {
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
    } on FirebaseException catch (error) {
      Fluttertoast.showToast(msg: error.message, gravity: ToastGravity.TOP);
    }
  }

  uploadUserInfo(String username, Map<String, dynamic> userInfoMap) {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(username)
          .set(userInfoMap);
    } on FirebaseException catch (error) {
      Fluttertoast.showToast(msg: error.message, gravity: ToastGravity.TOP);
    }
  }

  uploadPetInfo(Map<String, dynamic> petInfo) {
    try {
      FirebaseFirestore.instance.collection("homeless_pets").doc().set(petInfo);
    } on FirebaseException catch (error) {
      Fluttertoast.showToast(msg: error.message, gravity: ToastGravity.TOP);
    }
  }

  uploadStoreInfo(Map<String, dynamic> storeInfo) {
    try {
      FirebaseFirestore.instance.collection("stores").doc().set(storeInfo);
    } on FirebaseException catch (error) {
      Fluttertoast.showToast(msg: error.message, gravity: ToastGravity.TOP);
    }
  }

  createChatRoom(String chatRoomID, Map<String, dynamic> chatRoomMap) {
    try {
      FirebaseFirestore.instance
          .collection('ChatRooms')
          .doc(chatRoomID)
          .set(chatRoomMap);
    } on FirebaseException catch (error) {
      Fluttertoast.showToast(msg: error.message, gravity: ToastGravity.TOP);
    }
  }

  addChatMessage(String chatRoomID, Map<String, dynamic> chatMessageMap) {
    try {
      FirebaseFirestore.instance
          .collection('ChatRooms')
          .doc(chatRoomID)
          .collection('chats')
          .add(chatMessageMap);
    } on FirebaseException catch (error) {
      Fluttertoast.showToast(msg: error.message, gravity: ToastGravity.TOP);
    }
  }

  updateLastChat(String chatRoomID, String lastChatMessage, int time) {
    try {
      FirebaseFirestore.instance
          .collection('ChatRooms')
          .doc(chatRoomID)
          .update({'LastChat.Message': lastChatMessage, 'LastChat.Time': time});
    } on FirebaseException catch (error) {
      Fluttertoast.showToast(msg: error.message, gravity: ToastGravity.TOP);
    }
  }

  addLastChat(String chatRoomID, Map<String, dynamic> lastMessage) {
    try {
      FirebaseFirestore.instance
          .collection('ChatRooms')
          .doc(chatRoomID)
          .set(lastMessage, SetOptions(merge: true));
    } on FirebaseException catch (error) {
      Fluttertoast.showToast(msg: error.message, gravity: ToastGravity.TOP);
    }
  }

  getChatMessage(String chatRoomID) async {
    try {
      return FirebaseFirestore.instance
          .collection('ChatRooms')
          .doc(chatRoomID)
          .collection('chats')
          .orderBy("time", descending: false)
          .snapshots();
    } on FirebaseException catch (error) {
      Fluttertoast.showToast(msg: error.message, gravity: ToastGravity.TOP);
    }
  }

  getChatRooms(String username) async {
    try {
      return FirebaseFirestore.instance
          .collection('ChatRooms')
          .where('users', arrayContains: username)
          .snapshots();
    } on FirebaseException catch (error) {
      Fluttertoast.showToast(msg: error.message, gravity: ToastGravity.TOP);
    }
  }

  getCurrUserChatRooms(String chatRoomID) async {
    try {
      return FirebaseFirestore.instance
          .collection('ChatRooms')
          .where('chatRoomID', isEqualTo: chatRoomID)
          .snapshots();
    } on FirebaseException catch (error) {
      Fluttertoast.showToast(msg: error.message, gravity: ToastGravity.TOP);
    }
  }

  getCurrUserChatRoomsGet(String chatRoomID) async {
    try {
      return await FirebaseFirestore.instance
          .collection('ChatRooms')
          .where('chatRoomID', isEqualTo: chatRoomID)
          .get();
    } on FirebaseException catch (error) {
      Fluttertoast.showToast(msg: error.message, gravity: ToastGravity.TOP);
    }
  }

  deleteAd(String name, String owner) async {
    try {
      var collection = await FirebaseFirestore.instance
          .collection('homeless_pets')
          .where('owner', isEqualTo: owner)
          .where('name', isEqualTo: name)
          .get();
      for (final doc in collection.docs) {
        await doc.reference.delete();
      }
    } on FirebaseException catch (error) {
      Fluttertoast.showToast(msg: error.message, gravity: ToastGravity.TOP);
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

  Stream<List<Store>> getStores() =>
      FirebaseFirestore.instance.collection("stores").snapshots().map(
            (snapshot) =>
                snapshot.docs.map((doc) => Store.fromJson(doc.data())).toList(),
          );

  Stream<UserClass> getUser(String username) => FirebaseFirestore.instance
      .collection("users")
      .where('username', isEqualTo: username)
      .snapshots()
      .map(
        (snapshot) =>
            snapshot.docs.map((doc) => UserClass.fromJson(doc.data())).first,
      );

  Future<HomelessPet> getPetByTagID(String id) async {
    try {
      var homelessPet = await FirebaseFirestore.instance
          .collection("homeless_pets")
          .where('nfcTag', isEqualTo: id)
          .get()
          .then(
            (value) => value.docs.map((e) => HomelessPet.fromJson(e.data())),
          );
      return homelessPet != null && homelessPet.length > 0
          ? homelessPet.first
          : null;
    } on FirebaseException catch (error) {
      Fluttertoast.showToast(msg: error.message, gravity: ToastGravity.TOP);
    }
  }

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
