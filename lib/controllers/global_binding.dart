import 'package:get/get.dart';
import 'package:lost_flutter/controllers/authentication_controller.dart';
import 'package:lost_flutter/controllers/image_picker_controller.dart';
import 'package:lost_flutter/controllers/network_connectivity_controller.dart';
import 'package:lost_flutter/controllers/notification_controller.dart';
import 'package:lost_flutter/controllers/post_list_controller.dart';
import 'package:lost_flutter/controllers/post_seen_controller.dart';
import 'package:lost_flutter/controllers/profile_controller.dart';
import 'package:lost_flutter/controllers/replies_controller.dart';

class GlobalBindings extends Bindings{

  /// To initialize all the GetX controllers
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<AuthenticationController>(AuthenticationController());
    Get.lazyPut<NetworkController>(() => NetworkController());
    Get.lazyPut<PostListController>(() => PostListController());
    Get.lazyPut<PostSeenController>(() => PostSeenController());
    Get.lazyPut<RepliesController>(() => RepliesController());
    Get.lazyPut<NotificationController>(() => NotificationController());
    Get.lazyPut<ImagePickerController>(() => ImagePickerController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }

}