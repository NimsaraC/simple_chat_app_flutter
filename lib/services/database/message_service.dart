import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simple_chat_app/models/message_model.dart';

class MessageService {
  final CollectionReference messageReference =
      FirebaseFirestore.instance.collection('messages');
  final CollectionReference chatReference =
      FirebaseFirestore.instance.collection('chats');

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

      await chatReference.doc(chatId).update({
        'lastMessage': content,
        'messages': FieldValue.arrayUnion([id]),
      });

      print("Message sent");
    } catch (e) {
      print("Error sending message $e");
    }
  }

  Stream<List<MessageModel>> getMessageList(String chatId) {
    return messageReference
        .where('chatId', isEqualTo: chatId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      return snapshot.docs.map((doc) {
        return MessageModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<void> deleteMessage({
    required String messageId,
    required String chatId,
  }) async {
    try {
      final messageDoc = await messageReference.doc(messageId).get();
      if (!messageDoc.exists) {
        throw Exception("Message not found");
      }

      // final messageData = messageDoc.data() as Map<String, dynamic>;
      // final messageContent = messageData['content'];

      await messageReference.doc(messageId).delete();

      await chatReference.doc(chatId).update({
        'messages': FieldValue.arrayRemove([messageId]),
      });

      final remainingMessages = await messageReference
          .where('chatId', isEqualTo: chatId)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (remainingMessages.docs.isNotEmpty) {
        final latestMessage =
            remainingMessages.docs.first.data() as Map<String, dynamic>;
        await chatReference.doc(chatId).update({
          'lastMessage': latestMessage['content'],
        });
      } else {
        await chatReference.doc(chatId).update({
          'lastMessage': null,
        });
      }

      print("Message deleted successfully");
    } catch (e) {
      print("Error deleting message: $e");
      throw Exception("Failed to delete message");
    }
  }
}
