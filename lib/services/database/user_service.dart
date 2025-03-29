import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simple_chat_app/models/user_model.dart';

class UserService {
  final CollectionReference userReference =
      FirebaseFirestore.instance.collection('users');

  Future<void> createUser({
    required String userId,
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final QuerySnapshot existingUser =
          await userReference.where('email', isEqualTo: email).get();
      if (existingUser.docs.isNotEmpty) {
        return;
      }
      final QuerySnapshot snapshot =
          await userReference.where('id', isEqualTo: userId).get();
      if (snapshot.docs.isNotEmpty) {
        return;
      } else {
        UserModel user = UserModel(
          id: userId,
          name: name,
          email: email,
        );
        final Map<String, dynamic> userData = user.toJson();
        final DocumentReference documentReference =
            await userReference.add(userData);
        await documentReference.update({'id': userId});
      }
    } catch (e) {
      print("Error creating user");
    }
  }

  Future<void> editUser({
    required String userId,
    required UserModel newUser,
  }) async {
    try {
      final QuerySnapshot snapshot =
          await userReference.where('id', isEqualTo: userId).get();

      if (snapshot.docs.isNotEmpty) {
        final DocumentReference documentReference =
            snapshot.docs.first.reference;
        await documentReference.update(newUser.toJson());
      } else {
        print("User not found");
      }
    } catch (e) {
      print("Error editing user");
    }
  }

  Future<void> addFriend({
    required String friendId,
    required bool isAdd,
  }) async {
    try {
      final QuerySnapshot snapshot =
          await userReference.where('id', isEqualTo: friendId).get();
      final QuerySnapshot currentUserSnapshot = await userReference
          .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      UserModel currentUser = UserModel.fromJson(
          currentUserSnapshot.docs.first.data() as Map<String, dynamic>);
      UserModel friend = UserModel.fromJson(
          snapshot.docs.first.data() as Map<String, dynamic>);

      List<String> friend_friends = [];
      List<String> user_friends = [];

      friend_friends = friend.friends;
      user_friends = currentUser.friends;

      if (isAdd) {
        friend_friends.add(currentUser.id);
        user_friends.add(friend.id);
      } else {
        friend_friends.remove(currentUser.id);
        user_friends.remove(friend.id);
      }

      await editUser(userId: friend.id, newUser: friend);
      await editUser(userId: currentUser.id, newUser: currentUser);
    } catch (e) {
      print("Error adding users $e");
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      QuerySnapshot snapshot = await userReference.get();
      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error getting users: $e");
      return [];
    }
  }

  Future<UserModel?> getUserById(String userId) async {
    try {
      final QuerySnapshot snapshot =
          await userReference.where('id', isEqualTo: userId).get();

      if (snapshot.docs.isNotEmpty) {
        return UserModel.fromJson(
            snapshot.docs.first.data() as Map<String, dynamic>);
      } else {
        print("User not found");
        return null;
      }
    } catch (e) {
      print("Error getting user by ID: $e");
      return null;
    }
  }

  Future<List<UserModel>> getUserFriends() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      final UserModel? user = await getUserById(userId);
      if (user == null) {
        print("User not found");
        return [];
      }

      List<String> friendIds = user.friends;
      List<UserModel> friends = [];

      for (String friendId in friendIds) {
        final UserModel? friend = await getUserById(friendId);
        if (friend != null) {
          friends.add(friend);
        }
      }

      return friends;
    } catch (e) {
      print("Error getting user friends: $e");
      return [];
    }
  }
}
