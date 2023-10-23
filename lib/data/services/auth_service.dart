import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:noexis_task/data/models/firebase_response_wrapper.dart';
import 'package:noexis_task/data/models/user_model.dart';

class AuthService extends GetxService {
  final FirebaseAuth _fireAuth = FirebaseAuth.instance;
  User? currentUser;

  AuthService() {
    _fireAuth.authStateChanges().listen((User? user) {
      currentUser = user;
    });
  }

  Future<ResponseWrapper> registerUser(
      String email, String password, String displayName) async {
    try {
      UserCredential authResult =
          await _fireAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await authResult.user?.updateDisplayName(displayName);

      UserModel userModel = UserModel.fromJson(authResult.user);
      return ResponseWrapper(true, null, userModel);
    } catch (e) {
      return ResponseWrapper(false, e.toString(), null);
    }
  }

  Future<ResponseWrapper> loginUser(String email, String password) async {
    try {
      UserCredential authResult = await _fireAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      UserModel userModel = UserModel.fromJson(authResult.user);
      return ResponseWrapper(true, null, userModel);
    } catch (e) {
      return ResponseWrapper(false, e.toString(), null);
    }
  }

  Future<void> signOutUser() async {
    await _fireAuth.signOut();
  }
}
