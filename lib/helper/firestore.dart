import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat/models/chat.dart';
import 'package:firebase_chat/models/message.dart';
import 'package:uuid/uuid.dart';

class Firestore {
  final _firestore = FirebaseFirestore.instance;

  Future<void> insertUser(String email) async {
    final doc = await _firestore.collection("users").doc("user").get();
    if (doc.exists) {
      await _firestore
          .collection("users")
          .doc("user")
          .update({const Uuid().v4(): email});
    } else {
      await _firestore
          .collection("users")
          .doc("user")
          .set({const Uuid().v4(): email});
    }
  }

  Stream<List<Chat>?> getChats(String email) {
    return _firestore.collection("chats").doc(email).snapshots().map((event) {
      return event
          .data()
          ?.values
          .map((element) => Chat.fromJson(element))
          .toList();
    });
  }

  Future<void> createChat(String email, String name, String uuid) async {
    final doc = _firestore.collection("chats").doc(email);
    if ((await doc.get()).exists) {
      await doc.update({
        uuid: {
          "id": uuid,
          "email": name,
          "updatedAt": DateTime.now().toIso8601String(),
        }
      });
    } else {
      await doc.set({
        uuid: {
          "id": uuid,
          "email": name,
          "updatedAt": DateTime.now().toIso8601String(),
        }
      });
    }
  }

  Future<void> createMessage(String email, String name, String uuid) async {
    final doc = _firestore.collection("messages").doc(uuid);
    if ((await doc.get()).exists) {
      await doc.update({});
    } else {
      await doc.set({});
    }
  }

  Future<void> sendMessage(
    String email,
    String name,
    String chatId,
    String message,
  ) async {
    final doc = _firestore.collection("messages").doc(chatId);
    // if ((await doc.get()).exists)
    // {
    final id = const Uuid().v4();
    await doc.update({
      id: {
        "id": const Uuid().v4(),
        "sender": email,
        "receiver": name,
        "message": message,
        "time": DateTime.now().toIso8601String(),
      }
    });
  }

  Stream<List<Message>?> getMessages(String chatId) {
    return _firestore
        .collection("messages")
        .doc(chatId)
        .snapshots()
        .map((element) {
      return element.data()?.values.map((e) => Message.fromJson(e)).toList();
    });
  }

  Future<List?> getUsers() async {
    final data =
        (await _firestore.collection("users").doc("user").get()).data();
    return data?.values.where((element) => element != "").toList();
  }

  Future<String> initiateChat(String email, String name) async {
    final uuid = const Uuid().v4();
    // 1. Create Chat for both user
    await createChat(email, name, uuid);
    await createChat(name, email, uuid);
    // 2. create message-
    await createMessage(email, name, uuid);

    return uuid;
  }
}
