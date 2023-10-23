import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noexis_task/data/models/favorite_place.dart';
import 'package:noexis_task/data/services/auth_service.dart';
import 'package:noexis_task/db/db_helper.dart';

class MapController extends GetxController {
  final clickedLocation = Rx<LatLng>(const LatLng(0, 0));
  final favoritePlaces = <FavoritePlace>[].obs;
  final RxList<Marker> markers = <Marker>[].obs;
  final Map<int, Marker> placeMarkers = {};

  final placeNameController = TextEditingController();
  final authService = AuthService();
  final dbHelper = DatabaseHelper();

  FavoritePlace? selectedPlace;

  Rx<FavoritePlace?> selectedPlaceResult = Rx<FavoritePlace?>(null);
  Rx<CameraPosition?> currentMapPosition = Rx<CameraPosition?>(null);

  GoogleMapController? mapController;

  final imageUrlController = TextEditingController();

  void removeMarker(int placeId) {
    final marker = placeMarkers[placeId];
    if (marker != null) {
      markers.remove(marker);
    }
  }

  void onMapTap(LatLng location) {
    clickedLocation.value = location;
    showAddPlaceDialog(location);
  }

  void addMarker(FavoritePlace place) {
    final markerId = place.id.toString();
    final newMarker = Marker(
      markerId: MarkerId(markerId),
      position: LatLng(place.latitude, place.longitude),
      infoWindow: InfoWindow(
        title: place.name,
        snippet: 'Customize the snippet',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    placeMarkers[place.id!] = newMarker;
    markers.add(newMarker);
  }

  void addFavoritePlace(
      String placeName, double latitude, double longitude, String? imagePath) {
    String userId = authService.currentUser!.uid;
    if (clickedLocation.value.latitude != 0 &&
        clickedLocation.value.longitude != 0) {
      final newPlace = FavoritePlace(
        name: placeName,
        latitude: clickedLocation.value.latitude,
        longitude: clickedLocation.value.longitude,
        imageUrl: imagePath,
        userId: userId,
      );

      dbHelper.insertFavoritePlace(newPlace, userId).then((id) {
        newPlace.id = id;
        addMarker(newPlace);
        favoritePlaces.add(newPlace);
      });

      clickedLocation.value = const LatLng(0, 0);
    }
  }

  void clearMarkers() {
    markers.clear();
    placeMarkers.clear();
    update();
  }

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

  void handleSelectedPlace() {
    selectedPlace = selectedPlaceResult.value;
    if (selectedPlace != null) {
      centerMapOnPlace(selectedPlace!);
    }
  }

  @override
  void onInit() {
    clearMarkers();

    dbHelper.queryAllFavoritePlaces().then((places) {
      favoritePlaces.assignAll(places);
      for (var place in places) {
        addMarker(place);
      }
    });

    selectedPlaceResult.listen((_) => handleSelectedPlace());
    super.onInit();
  }

  void centerMapOnPlace(FavoritePlace place) {
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(place.latitude, place.longitude),
            zoom: 15.0,
          ),
        ),
      );
      currentMapPosition.value = CameraPosition(
        target: LatLng(place.latitude, place.longitude),
        zoom: 15.0,
      );
    }
  }

  void navigateBackFromFavoritePlaces(FavoritePlace selectedPlace) {
    centerMapOnPlace(selectedPlace);
  }

  void goToProfile() {
    Get.toNamed('/profile');
  }

  Future<void> signOutAndNavigateToLogin() async {
    final confirmed = await Get.defaultDialog(
      title: 'Sign Out Confirmation',
      titleStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      content: Container(
        padding: const EdgeInsets.all(16),
        child: const Column(
          children: [
            Icon(
              Icons.exit_to_app,
              size: 60,
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            Text('Are you sure you want to sign out?'),
          ],
        ),
      ),
      textConfirm: 'Confirm',
      textCancel: 'Cancel',
      onConfirm: () {
        authService.signOutUser();
        Get.offAllNamed('/login');
      },
      onCancel: () {
        Get.back();
      },
    );

    if (confirmed != null && confirmed) {}
  }

  void showAddPlaceDialog(LatLng location) {
    final imagePicker = ImagePicker();

    Rx<File?> selectedImage = Rx<File?>(null);

    Get.defaultDialog(
      title: "Add Favorite Place",
      content: Column(
        children: [
          TextField(
            controller: placeNameController,
            decoration: const InputDecoration(labelText: "Place Name"),
          ),
          Obx(() {
            return selectedImage.value != null
                ? Image.file(
                    selectedImage.value!,
                    height: 90,
                    width: 100,
                  )
                : const SizedBox();
          }),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final newImageFile =
                      await imagePicker.pickImage(source: ImageSource.gallery);

                  if (newImageFile != null) {
                    selectedImage.value = File(newImageFile.path);
                  }
                },
                child: const Icon(Icons.image),
              ),
              ElevatedButton(
                onPressed: () async {
                  final newImageFile =
                      await imagePicker.pickImage(source: ImageSource.camera);

                  if (newImageFile != null) {
                    selectedImage.value = File(newImageFile.path);
                  }
                },
                child: const Icon(Icons.camera_alt),
              ),
            ],
          ),
          TextField(
            controller: imageUrlController,
            decoration: const InputDecoration(labelText: "Image URL"),
          ),
          Text("Latitude: ${location.latitude.toString()}"),
          Text("Longitude: ${location.longitude.toString()}"),
          ElevatedButton(
            onPressed: () {
              final imagePath = selectedImage.value?.path;
              addFavoritePlace(
                placeNameController.text,
                location.latitude,
                location.longitude,
                imagePath ?? imageUrlController.text,
              );
              Get.back();
              placeNameController.text = '';
              imageUrlController.text = '';
            },
            child: const Text("Save location"),
          ),
        ],
      ),
    );
  }
}
