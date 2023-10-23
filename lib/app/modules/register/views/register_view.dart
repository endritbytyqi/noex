import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noexis_task/data/services/auth_service.dart';
import 'package:noexis_task/utils/widget_utils.dart';
import '../controllers/register_controller.dart';

// ignore: must_be_immutable
class RegisterView extends GetView<RegisterController> {
  var authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/register.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: Get.height * 0.20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Column(
                      children: [
                        const Text(
                          'Create Account',
                          style: TextStyle(color: Colors.white, fontSize: 33),
                        ),
                        const SizedBox(height: 30),
                        WidgetUtils.buildCustomField(
                          controller: controller.nameController,
                          hintText: "Name",
                          errorText: "Name cannot be empty",
                        ),

                        const SizedBox(height: 20),
                        WidgetUtils.buildCustomField(
                          controller: controller.emailController,
                          hintText: "Email",
                          errorText: "Email cannot be empty",
                        ),
                        const SizedBox(height: 20),
                        WidgetUtils.buildCustomField(
                          controller: controller.passwordController,
                          hintText: "Password",
                          obscureText: true,
                          errorText: "Password cannot be empty",
                        ),
                        const SizedBox(height: 20),
                        WidgetUtils.buildCustomField(
                          controller: controller.confirmPasswordController,
                          hintText: "Confirm Password",
                          errorText: "Password cannot be empty",
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Confirm Password is required';
                            }
                            if (value != controller.passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 27,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: const Color(0xff4c505b),
                              child: IconButton(
                                color: Colors.white,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    controller.registerUser();
                                  }
                                },
                                icon: const Icon(
                                  Icons.arrow_forward,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                Get.toNamed('/login');
                              },
                              style: const ButtonStyle(),
                              child: const Text(
                                'Sign In',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
