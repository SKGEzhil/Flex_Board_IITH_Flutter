import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lost_flutter/controllers/cab_sharing_controller.dart';
import 'package:lost_flutter/controllers/image_picker_controller.dart';
import 'package:lost_flutter/controllers/post_list_controller.dart';
import 'package:lost_flutter/controllers/post_tag_controller.dart';
import 'package:lost_flutter/utils/server_utils.dart';

import '../globals.dart';
import '../page_builder.dart';
import '../utils/shared_prefs.dart';
import 'loading_controller.dart';

class CreatePostController extends GetxController {

  /// GetX Controllers
  final CabSharingController cabSharingController =
      Get.put(CabSharingController());
  final PostTagController postTagController = Get.put(PostTagController());
  final ImagePickerController imagePickerController =
      Get.put(ImagePickerController());
  final PostListController postListController = Get.put(PostListController());
  final LoadingController loadingController = Get.put(LoadingController());

  /// Declarations
  final serverUtils = ServerUtils();
  final sharedPrefs = SharedPrefs();

  /// Shows a snackbar when [subject] or [content] is empty
  SnackbarController showSnackBar() {
    return Get.snackbar('Error', 'Subject or Body cannot be empty',
        isDismissible: true,
        mainButton: TextButton(
          child: Text(
            'OK',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          onPressed: () {
            Get.back();
          },
        ),
        snackPosition: SnackPosition.TOP,
        animationDuration: const Duration(milliseconds: 150),
        borderRadius: 8,
        margin: const EdgeInsets.all(10),
        backgroundColor: Colors.redAccent.withOpacity(0.7),
        colorText: Colors.black);
  }

  /// Creates a post
  Future<void> createPost(subject, content, context) async {
    
    print('object');
    
    print('subject: ${subject}');
    print('content: ${content}');

    // Checks if [subject] or [content] is empty
    if (subject.isEmpty || content.isEmpty) {
      showSnackBar();
      return;
    }

    loadingController.startLoading();

    // stores cab details in [cabDetails]
    var cabDetails = {
      'from': cabSharingController.fromLocation.value,
      'to': cabSharingController.toLocation.value,
      'time': cabSharingController.dateTime.value
    };

    // gets selected tags from [postTagController]
    final tags = postTagController.selectedTags;

    // uploads image if [imagePickerController.image] is not null
    if (imagePickerController.image != null) {
      await serverUtils.uploadImage(imagePickerController.image, false);
    }

    // creates a post in server
    bool isPosted = await serverUtils.createPost(roll_no_, subject,
        content, post_image_link, tags, cabDetails, context);

    // resets all necessary values after post is created successfully
    if (isPosted) {

      post_image_link = "";
      cabSharingController.fromLocation.value = "From";
      cabSharingController.toLocation.value = "To";
      sharedPrefs.saveDraft('', '');
      postTagController.resetTags();
      postListController.fetchData();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PageBuilder(),
          ));
      loadingController.stopLoading();

    }

  }
}
