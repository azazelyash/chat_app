import 'package:chat_application/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';
import 'package:http/http.dart' as http;

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // Register Method

  Future registerUserWithEmailandPassword(
      String fullName, String email, String password) async {
    try {
      // register user`
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        await DatabaseService(uid: user.uid).updateUserData(fullName, email);
        return true;
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return e;
    }
  }
}
