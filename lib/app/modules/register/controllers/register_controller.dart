import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noexis_task/data/services/auth_service.dart';

class RegisterController extends GetxController {
  var authService = AuthService();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  RxBool isChecked = false.obs;

  void clearTextFields() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  Future<void> registerUser() async {
    final email = emailController.text;
    final password = passwordController.text;
    final displayName = nameController.text;
    try {
      var response =
          await authService.registerUser(email, password, displayName);
      if (response.isSuccess) {
        Get.snackbar(
          "Registration success",
          "Success",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.toNamed('/login');
        clearTextFields();
        
      } else {
        Get.snackbar(
          "Registration Failed",
          response.error ?? "Registration error message here",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Registration Error",
        "An error occurred while registering: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
