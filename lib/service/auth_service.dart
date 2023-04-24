import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final _auth=FirebaseAuth.instance;

  static Future<User?> signIn(String email,password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user=_auth.currentUser;
      return user;
    } on FirebaseAuthException catch (e) {
      print("Xatolik yuz berdi $e");
    }
  }

  static Future<User?> signUp(String email,password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user=_auth.currentUser;
      return user;
    } on FirebaseAuthException catch (e) {
      print("Xatolik yuz berdi $e");
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  static bool currentUser() {
    User? user=_auth.currentUser;
    return user!=null;
  }

  static String currentUserId() {
    User? user=_auth.currentUser;
    return user!.uid;
  }
}