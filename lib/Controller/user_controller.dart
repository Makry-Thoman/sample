import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:zootopia/Model/user_model.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var isLoading = false.obs;
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  // Register User
  Future<String?> registerUser(String name, String email, String phone, String password) async {
    try {
      isLoading.value = true;
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel user = UserModel(
        uid: userCredential.user!.uid,
        name: name,
        email: email,
        password: password,
        phone: phone,
      );

      await _firestore.collection("users").doc(user.uid).set(user.toMap());
      currentUser.value = user;
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message; // Return error message
    } finally {
      isLoading.value = false;
    }
  }

  // Login User
  Future<String?> loginUser(String email, String password) async {
    try {
      isLoading.value = true;
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot userDoc = await _firestore.collection("users").doc(userCredential.user!.uid).get();
      if (!userDoc.exists) {
        return "User not found in database";
      }

      currentUser.value = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message;
    } finally {
      isLoading.value = false;
    }
  }

  // Logout User
  Future<void> logoutUser() async {
    await _auth.signOut();
    currentUser.value = null;
  }
}