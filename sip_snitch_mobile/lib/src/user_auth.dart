import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserAuthenticationNotifier with ChangeNotifier {
  bool get isUserSignedIn => user != null;

  User? get user => FirebaseAuth.instance.currentUser;

  Future<void> signInAnonymously() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      print("Signed in with temporary account. ${userCredential.user!.uid}");
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
        default:
          print("Unknown error.");
      }
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}
