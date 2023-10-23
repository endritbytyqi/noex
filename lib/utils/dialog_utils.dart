import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogUtility {
  static void showConfirmationDialog(
    String title,
    String message,
    Function onConfirm,
  ) {
    Get.defaultDialog(
      title: title,
      middleText: message,
      actions: [
        ElevatedButton(
          onPressed: () {
            onConfirm();
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

  static Future<String?> showSearchDialog() async {
    String? searchQuery;
    await Get.defaultDialog(
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
              Get.back(result: searchQuery);
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
    return searchQuery;
  }
}
