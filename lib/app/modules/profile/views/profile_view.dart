import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noexis_task/app/modules/profile/controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('User Profile'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade200, Colors.blue.shade800],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                    ),
                    child: Obx(() {
                      final profilePicture = controller.profilePictureUrl.value;
                      return Stack(
                        children: [
                          if (profilePicture.isNotEmpty)
                            ClipOval(
                              child: Image.network(
                                profilePicture,
                                width: 144,
                                height: 144,
                                fit: BoxFit.cover,
                              ),
                            ),
                          if (controller.isLoading.value)
                            LoadingDialog(), // Show loading dialog
                          if (profilePicture.isEmpty &&
                              !controller.isLoading.value)
                            const Icon(
                              Icons.account_circle,
                              size: 144,
                              color: Colors.white,
                            ),
                        ],
                      );
                    }),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.changeProfilePicture().then((_) {
                          controller.fetchProfilePicture();
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(const CircleBorder()),
                      ),
                      child: const Icon(Icons.camera_alt),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildUserInfo("User ID", controller.user.value?.uid ?? ''),
                  _buildUserInfo(
                      "Name", controller.user.value?.displayName ?? ''),
                  _buildUserInfo("Email", controller.user.value?.email ?? ''),
                  _buildUserInfo("Email verified",
                      controller.user.value?.emailVerified.toString() ?? ''),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$title:",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
            ),
          ],
        ),
      ),
    );
  }
}
