import 'package:get/get.dart';
import 'package:lost_flutter/controllers/network_connectivity_controller.dart';
import 'package:lost_flutter/globals.dart';
import 'package:lost_flutter/utils/server_utils.dart';
import 'package:lost_flutter/utils/shared_prefs.dart';

class PostSeenController extends GetxController {

  var seenPosts = <String>[].obs;
  final NetworkController networkController = Get.put(NetworkController());

  Future<void> getSeenPosts() async {
    print('GETTING SEEN POSTS');
    if(networkController.connectionType != 0){
      seenPosts.value = await ServerUtils().getSeenPosts(roll_no_);
      SharedPrefs().storeSeenPosts(seenPosts.value);
    } else {
      seenPosts.value = await SharedPrefs().getSeenPosts();
    }
  }

  @override
  void onInit() {
    super.onInit();
    getSeenPosts();
  }

}