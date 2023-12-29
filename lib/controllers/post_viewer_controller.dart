import 'package:get/get.dart';
import 'package:lost_flutter/models.dart';

import '../utils/server_utils.dart';

class PostViewerController extends GetxController{
  var profilePic = ''.obs;
  final serverUtils = ServerUtils();

  Future<void> getProfilePic(roll_no) async {
    final UserDetails userDetails = await serverUtils.getUserDetails(roll_no);
    profilePic.value = userDetails.profilePic;
    update();
  }

}