import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noexis_task/app/modules/favorite_places/controllers/favorite_places_controller.dart';

class FavoritePlacesView extends GetView<FavoritePlacesController> {
  const FavoritePlacesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Places'),
        actions: [
          IconButton(
            onPressed: () {
              controller.showSearchDialog();
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Obx(
        () {
          final filteredFavoritePlaces = controller.filteredFavoritePlaces;

          return filteredFavoritePlaces.isNotEmpty
              ? ListView.builder(
                  itemCount: filteredFavoritePlaces.length,
                  itemBuilder: (context, index) {
                    final place = filteredFavoritePlaces[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {
                          controller.centerMapOnPlace(place);
                          
                        },
                        contentPadding: const EdgeInsets.all(0.0),
                        title: Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image:
                                  controller.getImageProvider(place.imageUrl),
                            ),
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Place name: ${place.name}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text('Lat: ${place.latitude}'),
                            Text('Long: ${place.longitude} '),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                controller.showEditFavoritePlaceDialog(index);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                controller.showDeleteConfirmationDialog(index);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text("No favorite places"),
                );
        },
      ),
    );
  }
}
