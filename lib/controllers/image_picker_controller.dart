import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerController extends GetxController {

  XFile? image;
  final ImagePicker picker = ImagePicker();


  void resetImage() {
    image = null;
    update();
  }

  Future getImage(ImageSource media) async {
    try {
      var img = await picker.pickImage(source: media);
      if (img != null) {
        image = img;
        update();
      }
    } catch (e) {
      print("Error picking image: $e");
      update();
      // Handle the error as needed
    }
    update();
  }

  @override
  void onInit() {
    super.onInit();
  }

}