import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/map_controller.dart';

BitmapDescriptor customIcon =
    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);

class MapView extends GetView<MapController> {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50,
        leading: InkWell(
          onTap: () async {
            final selectedPlace = await Get.toNamed('/favorite-places');
            if (selectedPlace != null) {
              controller.navigateBackFromFavoritePlaces(selectedPlace);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
            child: const Icon(
              Icons.place,
              color: Colors.red,
              size: 40,
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(" Map,"),
            SizedBox(
              width: 20,
            ),
            const Text("Profile "),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
              child: InkWell(
                onTap: () => controller.goToProfile(),
                child: const Icon(
                  Icons.person_2_outlined,
                  color: Colors.red,
                  size: 35,
                ),
              ),
            ),
          ],
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () => controller.signOutAndNavigateToLogin(),
                child: const Icon(
                  Icons.logout_outlined,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        // Check if you should update the initialCameraPosition
        final initialCameraPosition = controller.shouldUpdateMap.value
            ? CameraPosition(
                target: controller.clickedLocation.value,
                zoom: 15,
              )
            : CameraPosition(
                target: const LatLng(42.20, 21.4194),
                zoom: 8,
                bearing: controller.currentMapPosition.value?.bearing ?? 0,
                tilt: controller.currentMapPosition.value?.tilt ?? 0,
              );

        // Reset the shouldUpdateMap flag
        if (controller.shouldUpdateMap.value) {
          controller.shouldUpdateMap.value = false;
        }

        return GoogleMap(
          onMapCreated: (GoogleMapController gmcontroller) {
            controller.setMapController(gmcontroller);
          },
          markers: Set<Marker>.from(controller.markers),
          onTap: controller.onMapTap,
          initialCameraPosition:
              initialCameraPosition, // Use the computed value
        );
      }),
    );
  }
}
