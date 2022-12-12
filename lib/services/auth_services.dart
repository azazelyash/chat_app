import 'package:chat_application/helper/helper_function.dart';
import 'package:chat_application/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //-----------------------Login-------------------------//

  Future loginUserWithEmailandPassword(String email, String password) async {
    try {
      // register user`
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e);
      return e;
    }
  }

  // Register Method

  Future registerUserWithEmailandPassword(
      String fullName, String email, String password) async {
    try {
      // register user`
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        await DatabaseService(uid: user.uid).savingUserData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e);
      return e;
    }
  }

  //----------------------Sign Out----------------------//

  Future signout() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserName("");
      await HelperFunctions.saveUserEmail("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
