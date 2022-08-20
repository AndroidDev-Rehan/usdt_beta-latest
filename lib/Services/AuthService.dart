import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<bool> deleteUser(String email, String password) async {
    try {
      User user = _auth.currentUser;
      AuthCredential credentials = EmailAuthProvider.credential(email: email, password: password);
      print(user);
      // UserCredential result = await user.reauthenticateWithCredential(credentials);
      // await DatabaseService(uid: result.user.uid).deleteuser(); // called from database class
      UserCredential result  = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      await result.user.delete();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}