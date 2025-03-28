import 'package:cloud_firestore/cloud_firestore.dart';
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
}
