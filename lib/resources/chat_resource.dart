import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:pherico/config/firebase_constants.dart';
import 'package:pherico/models/message.dart';
import 'package:pherico/resources/storage_methods.dart';
import 'package:pherico/resources/store_registration.dart';
import 'package:pherico/utils/pick_image.dart';
import 'package:uuid/uuid.dart';

class ChatResource {
  static Future<bool> addChatUser(String userId) async {
    try {
      firebaseFirestore
          .collection(storeCollection)
          .doc(firebaseAuth.currentUser!.uid)
          .collection(chatUsersCollection)
          .doc(userId)
          .set({});
      return true;
    } catch (error) {
      return false;
    }
  }

  static Future<void> sendFirstMessage(
      String sellerId, String pushToken, String name, String msg) async {
    await firebaseFirestore
        .collection(storeCollection)
        .doc(sellerId)
        .collection(chatUsersCollection)
        .doc(firebaseAuth.currentUser!.uid)
        .set({}).then((value) => sendMessage(sellerId, pushToken, name, msg));
    await firebaseFirestore
        .collection(storeCollection)
        .doc(firebaseAuth.currentUser!.uid)
        .collection(chatUsersCollection)
        .doc(sellerId)
        .set({});

    await sendChatPushNotification(pushToken, name, msg);
  }

  static Future<void> sendFirstFile(String sellerId, Uint8List file) async {
    await firebaseFirestore
        .collection(storeCollection)
        .doc(sellerId)
        .collection(chatUsersCollection)
        .doc(firebaseAuth.currentUser!.uid)
        .set({}).then((value) => sendFile(sellerId, file));
    await firebaseFirestore
        .collection(storeCollection)
        .doc(firebaseAuth.currentUser!.uid)
        .collection(chatUsersCollection)
        .doc(sellerId)
        .set({});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getChatIds() {
    return firebaseFirestore
        .collection(storeCollection)
        .doc(firebaseAuth.currentUser!.uid)
        .collection(chatUsersCollection)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
      List<String> userIds) {
    return firebaseFirestore
        .collection(storeCollection)
        .where('uid', whereIn: userIds)
        .snapshots();
  }

  static String getConversationalId(String id) =>
      firebaseAuth.currentUser!.uid.hashCode <= id.hashCode
          ? '${firebaseAuth.currentUser!.uid}_$id'
          : '${id}_${firebaseAuth.currentUser!.uid}';

  static Query<Map<String, dynamic>> getAllMessages(String sellerId) {
    return firebaseFirestore
        .collection('chats/${getConversationalId(sellerId)}/messages')
        .orderBy('sent', descending: true);
  }

  static Future<void> sendMessage(
      String sellerId, String pushToken, String name, String msg) async {
    // used as chat id and sent time
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final messageId = const Uuid().v1();
    final Message message = Message(
        fromid: firebaseAuth.currentUser!.uid,
        toid: sellerId,
        message: msg,
        read: '',
        sent: time,
        messageId: messageId,
        isDelete: '',
        type: Type.text);

    final ref = firebaseFirestore
        .collection('chats/${getConversationalId(sellerId)}/messages/');

    await ref.doc(messageId).set(message.toJson());
    await sendChatPushNotification(pushToken, name, msg);
  }

  static Future<void> updateMessageReadStatus(
      String sellerId, String messageId) async {
    await firebaseFirestore
        .collection('chats/${getConversationalId(sellerId)}/messages/')
        .doc(messageId)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      String sellerId) {
    return firebaseFirestore
        .collection('chats/${getConversationalId(sellerId)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> sendFile(String sellerId, Uint8List file) async {
    Uint8List image = await compressImage(file);
    String imageUrl = await uploadImage(const Uuid().v1(), image, 'chats');

    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final messageId = const Uuid().v1();
    final Message message = Message(
        fromid: firebaseAuth.currentUser!.uid,
        toid: sellerId,
        message: imageUrl,
        read: '',
        sent: time,
        messageId: messageId,
        isDelete: '',
        type: Type.image);

    final ref = firebaseFirestore
        .collection('chats/${getConversationalId(sellerId)}/messages/');

    await ref.doc(messageId).set(message.toJson());
  }

// to get the seller info like status and last time etc
  static Stream<QuerySnapshot<Map<String, dynamic>>> getSellerInfo(
      String sellerId) {
    return firebaseFirestore
        .collection(storeCollection)
        .where('uid', isEqualTo: sellerId)
        .limit(1)
        .snapshots();
  }

  static Future<void> updateStatus(bool isOnline) async {
    if (await StoreRegistration.sellerRegistered()) {
      await firebaseFirestore
          .collection(storeCollection)
          .doc(firebaseAuth.currentUser!.uid)
          .update({
        'isOnline': isOnline,
        'lastActive': DateTime.now().millisecondsSinceEpoch.toString(),
      });
    }
  }

  static Future<void> sendChatPushNotification(
      String pushToken, String name, String message) async {
    try {
      final body = {
        "to": pushToken,
        "notification": {
          "title": "Pherico",
          'body': message,
          "android_channel_id": 'chats'
        },
      };
      await post(
        Uri.parse(fcmUrl),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: fcmServerKey
        },
        body: jsonEncode(body),
      );
    } catch (error) {}
  }

  static Future<String> deleteMessage(String sellerId, String messageId) async {
    String res = "error to delete";
    try {
      await firebaseFirestore
          .collection('chats/${getConversationalId(sellerId)}/messages/')
          .doc(messageId)
          .update(
              {'isDelete': DateTime.now().millisecondsSinceEpoch.toString()});
      res = 'success';
    } catch (error) {
      res = 'fail to delete';
    }

    return res;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMessageCount(
      String sellerId) {
    return firebaseFirestore
        .collection('chats/${getConversationalId(sellerId)}/messages/')
        .where('read', isEqualTo: '')
        .snapshots();
  }
}
