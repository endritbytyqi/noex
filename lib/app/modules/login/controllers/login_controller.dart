import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:noexis_task/data/services/auth_service.dart';

class LoginController extends GetxController {
  var authService = AuthService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailErrorController = TextEditingController();
  final passwordErrorController = TextEditingController();
  Future<void> loginUser() async {
    final email = emailController.text;
    final password = passwordController.text;

    try {
      var response = await authService.loginUser(email, password);
      if (response.isSuccess) {
        Get.snackbar(
          "Login success",
          "Success",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.toNamed('/mapview');
      } else {
        Get.snackbar(
          "Login Failed",
          "Invalid email or password",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Login Error",
        "An error occurred while logging in",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
