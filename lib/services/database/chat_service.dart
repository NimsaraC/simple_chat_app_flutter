import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:simple_chat_app/models/chat_model.dart';

class ChatService {
  final CollectionReference chatReference =
      FirebaseFirestore.instance.collection('chats');

  Future<void> openChat({
    required String user1,
    required String user2,
  }) async {
    try {
      String chatId = '$user1-$user2';
      String reverseChatId = '$user2-$user1';
      final existingChat = await chatReference.doc(chatId).get();
      final existingReverseChat = await chatReference.doc(reverseChatId).get();
      if (existingChat.exists || existingReverseChat.exists) {
        return;
      }
      final newChat = ChatModel(
        id: chatId,
        UserOneId: user1,
        UserTwoId: user2,
      );
      await chatReference.doc(chatId).set(newChat.toJson());
      print("New chat created");
    } catch (e) {
      print("Error creating new chat: $e");
    }
  }

  Future<List<ChatModel>> getUserChats({required String userId}) async {
    try {
      QuerySnapshot querySnapshot =
          await chatReference.where("UserOneId", isEqualTo: userId).get();
      QuerySnapshot reverseQuerySnapshot =
          await chatReference.where("UserTwoId", isEqualTo: userId).get();

      List<ChatModel> chats = querySnapshot.docs
          .map((doc) => ChatModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      List<ChatModel> reverseChats = reverseQuerySnapshot.docs
          .map((doc) => ChatModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return [...chats, ...reverseChats];
    } catch (e) {
      print("Error fetching user chats: $e");
      return [];
    }
  }

  Future<ChatModel?> getChatById(String chatId) async {
    try {
      DocumentSnapshot doc = await chatReference.doc(chatId).get();
      if (doc.exists) {
        return ChatModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print("Error fetching chat by ID: $e");
      return null;
    }
  }

  Future<ChatModel> getChatByUsers({required String userOne, required String userTwo}) async {
    try {
      String chatId = '$userOne-$userTwo';
      String reverseChatId = '$userTwo-$userOne';
      
      DocumentSnapshot doc = await chatReference.doc(chatId).get();
      if (doc.exists) {
        return ChatModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      
      DocumentSnapshot reverseDoc = await chatReference.doc(reverseChatId).get();
      if (reverseDoc.exists) {
        return ChatModel.fromJson(reverseDoc.data() as Map<String, dynamic>);
      }
      
      final newChat = ChatModel(
        id: chatId,
        UserOneId: userOne,
        UserTwoId: userTwo,
      );
      await chatReference.doc(chatId).set(newChat.toJson());
      print("New chat created");
      return newChat;
    } catch (e) {
      print("Error fetching or creating chat: $e");
      throw Exception("Failed to fetch or create chat");
    }
  }

  Future<void> deleteChat(String chatId) async {
    try {
      await chatReference.doc(chatId).delete();
      
      final messageReference = FirebaseFirestore.instance.collection('messages');
      final messagesSnapshot = await messageReference
          .where('chatId', isEqualTo: chatId)
          .get();
      
      for (var doc in messagesSnapshot.docs) {
        await doc.reference.delete();
      }
      
      print("Chat and associated messages deleted successfully");
    } catch (e) {
      print("Error deleting chat: $e");
      throw Exception("Failed to delete chat");
    }
  }
  
}
