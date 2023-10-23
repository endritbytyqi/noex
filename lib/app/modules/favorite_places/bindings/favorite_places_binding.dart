import 'package:get/get.dart';

import '../controllers/favorite_places_controller.dart';

class FavoritePlacesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavoritePlacesController>(
      () => FavoritePlacesController(),
    );
  }
}
