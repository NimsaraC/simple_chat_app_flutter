import 'package:firebase_auth/firebase_auth.dart';
import 'package:simple_chat_app/services/database/user_service.dart';

class LoginService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? get user => firebaseAuth.currentUser;

  Future<void> registerNewUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      var userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;
      UserService().createUser(
          userId: userId, name: name, email: email, password: password);
    } on FirebaseAuthException catch (error) {
      throw Exception(error.code);
    } catch (e) {
      print("Error register user");
    }
  }

  Future<void> userLogin({
    required String email,
    required String password,
  }) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (error) {
      throw Exception(error.code);
    } catch (e) {
      print("Error login user");
    }
  }
}
