import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noexis_task/utils/image_utils.dart';

class ProfileController extends GetxController {
  final user = Rx<User?>(null);
  final RxString profilePictureUrl = ''.obs;
  final RxBool isLoading = false.obs; // Add loading indicator state
  final imageUtility = ImageUtility();

  @override
  void onInit() {
    fetchUserData();
    fetchProfilePicture();
    super.onInit();
  }

  void fetchUserData() {
    final currentUser = FirebaseAuth.instance.currentUser;
    user.value = currentUser;
  }

  Future<void> fetchProfilePicture() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('profile_pictures/${user.uid}/profile_picture.jpg');
        final url = await ref.getDownloadURL();
        profilePictureUrl.value = url;
      }
    } catch (e) {
      profilePictureUrl.value = '';
    }
  }

  Future<void> uploadProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('profile_pictures/${user.uid}/profile_picture.jpg');
        isLoading.value = true; // Show loading indicator
        try {
          final imageUrl = await imageUtility.uploadImage(file, ref.fullPath);
          if (imageUrl != null) {
            profilePictureUrl.value = imageUrl;
          }
        } catch (e) {
          print("Error uploading profile picture: $e");
        } finally {
          isLoading.value = false; // Hide loading indicator
        }
      }
    }
  }

  Future<void> changeProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('profile_pictures/${user.uid}/profile_picture.jpg');
        isLoading.value = true; // Show loading indicator
        try {
          await ref.putFile(file);
          fetchProfilePicture();
        } catch (e) {
          print("Error changing profile picture: $e");
        } finally {
          isLoading.value = false; // Hide loading indicator
        }
      }
    }
  }
}
