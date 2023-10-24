import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noexis_task/app/modules/map/controllers/map_controller.dart';
import 'package:noexis_task/data/models/favorite_place.dart';
import 'package:noexis_task/db/db_helper.dart';
import 'package:noexis_task/utils/image_utils.dart';

class FavoritePlacesController extends GetxController {
  final MapController mapController = Get.find<MapController>();
  final DatabaseHelper databaseHelper = DatabaseHelper();

  RxList<FavoritePlace> favoritePlaces = <FavoritePlace>[].obs;
  RxList<FavoritePlace> filteredFavoritePlaces = <FavoritePlace>[].obs;

  final RxInt editingIndex = (-1).obs;
  final imageUtility = ImageUtility();

  @override
  void onInit() {
    super.onInit();
    retrieveFavoritePlaces();
  }

  void retrieveFavoritePlaces() {
    databaseHelper.queryAllFavoritePlaces().then((places) {
      favoritePlaces.assignAll(places);
      filteredFavoritePlaces.assignAll(places);
    });
  }

  ImageProvider getImageProvider(String? imageUrl) {
    if (imageUrl != null) {
      if (imageUrl.startsWith('http') || imageUrl.startsWith('https')) {
        return NetworkImage(imageUrl);
      } else {
        return AssetImage(imageUrl);
      }
    } else {
      return const AssetImage(
        ImageUtility.noImage,
      );
    }
  }

  void filterFavoritePlaces(String query) {
    if (query.isEmpty) {
      filteredFavoritePlaces.assignAll(favoritePlaces);
    } else {
      final lowerCaseQuery = query.toLowerCase();
      final filteredPlaces = favoritePlaces.where((place) {
        final lowerCaseName = place.name.toLowerCase();
        final location = '${place.latitude}, ${place.longitude}'.toLowerCase();
        return lowerCaseName.contains(lowerCaseQuery) ||
            location.contains(lowerCaseQuery);
      }).toList();
      filteredFavoritePlaces.assignAll(filteredPlaces);
    }
  }

  void editFavoritePlace(int index) {
    editingIndex.value = index;
  }

  void centerMapOnPlace(FavoritePlace place) {
    mapController.shouldUpdateMap.value = true;
    mapController.centerMapOnPlace(place);
    Get.back();
  }

  void showDeleteConfirmationDialog(int index) {
    Get.defaultDialog(
      title: "Confirm Deletion",
      middleText: "Are you sure you want to delete this favorite place?",
      actions: [
        ElevatedButton(
          onPressed: () {
            deleteFavoritePlace(index);
            Get.back();
          },
          child: const Text("Yes"),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: const Text("No"),
        ),
      ],
    );
  }

  void showEditFavoritePlaceDialog(int index) async {
    final favoritePlace = favoritePlaces[index];
    final placeNameController = TextEditingController(text: favoritePlace.name);
    final latitudeController =
        TextEditingController(text: favoritePlace.latitude.toString());
    final longitudeController =
        TextEditingController(text: favoritePlace.longitude.toString());
    final imageUrlController =
        TextEditingController(text: favoritePlace.imageUrl);

    String currentImagePath = favoritePlace.imageUrl ?? '';
    RxString newImagePath = currentImagePath.obs;

    Get.defaultDialog(
      title: "Edit Favorite Place",
      content: SingleChildScrollView(
        child: Column(
          children: [
            if (newImagePath.isNotEmpty)
              Obx(() {
                if (newImagePath.value.startsWith('http') ||
                    newImagePath.value.startsWith('https')) {
                  // Load image from URL
                  return Image.network(
                    newImagePath.value,
                    height: 200,
                    width: 400,
                  );
                } else {
                  // Load local image
                  return Image.file(
                    File(newImagePath.value),
                    height: 200,
                    width: 400,
                  );
                }
              }),
            ElevatedButton(
              onPressed: () async {
                final pickedImage = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );

                if (pickedImage != null) {
                  newImagePath.value = pickedImage.path;
                  imageUrlController.text = newImagePath.value;
                  updateFavoritePlaceImage(index, newImagePath.value);
                }
              },
              child: const Text("Change Image"),
            ),
            TextField(
              controller: placeNameController,
              decoration: const InputDecoration(labelText: "Place Name"),
            ),
            TextField(
              controller: latitudeController,
              decoration: const InputDecoration(labelText: "Latitude"),
            ),
            TextField(
              controller: longitudeController,
              decoration: const InputDecoration(labelText: "Longitude"),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            final latitude = double.tryParse(latitudeController.text) ?? 0.0;
            final longitude = double.tryParse(longitudeController.text) ?? 0.0;
            saveEditedFavoritePlace(
                index, placeNameController.text, latitude, longitude);
            Get.back();
          },
          child: const Text("Save"),
        ),
      ],
    );
  }

  void updateFavoritePlace(FavoritePlace updatedPlace) {
    final index =
        favoritePlaces.indexWhere((place) => place.id == updatedPlace.id);
    if (index >= 0) {
      favoritePlaces[index] = updatedPlace;
      databaseHelper.updateFavoritePlace(updatedPlace);
    }
  }

  void saveEditedFavoritePlace(
      int index, String newName, double latitude, double longitude) {
    final favoritePlace = favoritePlaces[index];
    favoritePlace.name = newName;
    favoritePlace.latitude = latitude;
    favoritePlace.longitude = longitude;
    editingIndex.value = -1;
    updateFavoritePlace(favoritePlace);
    retrieveFavoritePlaces();
  }

  void updateFavoritePlaceImage(int index, String newImagePath) {
    final favoritePlace = favoritePlaces[index];
    favoritePlace.imageUrl = newImagePath;
    updateFavoritePlace(favoritePlace);
  }

  void deleteFavoritePlace(int index) {
    final favoritePlace = favoritePlaces[index];
    final marker = mapController.placeMarkers[favoritePlace.id];
    if (marker != null) {
      mapController.markers.remove(marker);
    }
    favoritePlaces.remove(favoritePlace);
    editingIndex.value = -1;
    databaseHelper.removeFavoritePlace(favoritePlace.id!);
    retrieveFavoritePlaces();
  }

  void showSearchDialog() {
    String searchQuery = '';

    Get.defaultDialog(
      title: 'Search Places',
      content: Column(
        children: [
          TextField(
            onChanged: (query) {
              searchQuery = query;
            },
            decoration:
                const InputDecoration(labelText: 'Search by name or location'),
          ),
          ElevatedButton(
            onPressed: () {
              filterFavoritePlaces(searchQuery);
              Get.back();
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }
}
