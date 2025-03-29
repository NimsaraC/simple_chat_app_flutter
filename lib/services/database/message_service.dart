import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simple_chat_app/models/message_model.dart';

class MessageService {
  final CollectionReference messageReference =
      FirebaseFirestore.instance.collection('messages');

  Future<void> sendMessage({
    required String chatId,
    required String content,
  }) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DateTime timestamp = DateTime.now();
      String id = messageReference.doc().id;
      final newMessage = MessageModel(
        id: id,
        userId: userId,
        chatId: chatId,
        content: content,
        timestamp: timestamp,
      );
      await messageReference.doc(id).set(newMessage.toJson());
      print("Message sent");
    } catch (e) {
      print("Error sending message $e");
    }
  }
}
