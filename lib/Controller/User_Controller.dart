
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zootopia/Models/user_Model.dart';
import 'package:zootopia/Starting/Session.dart';

class UserController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register User
  Future<String?> registerUser(String name, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel user = UserModel(
        uid: userCredential.user!.uid,
        name: name,
        email: email,
        password: password,
        // phone: '',
      );

      await _firestore.collection("users").doc(user.uid).set(user.toMap());

      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message; // Return error message
    }
  }


  // Login User
  Future<String?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userID =userCredential.user!.uid;

      // Check if user exists in Firestore
      DocumentSnapshot userDoc = await _firestore.collection("users").doc(userCredential.user!.uid).get();

      if (!userDoc.exists) {
        return "User not found in database"; // Prevents unauthorized logins
      }
      String mode = 'User';
      await Session.saveSession(email, userID, mode);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message; // Return error message
    }
  }


  // Logout User
  // Future<void> logoutUser() async {
  //   await _auth.signOut();
  // }


}