import 'package:get/get.dart';
import 'package:lost_flutter/controllers/image_picker_controller.dart';
import 'package:lost_flutter/globals.dart';

import '../utils/server_utils.dart';
import '../utils/shared_prefs.dart';

class ProfileController extends GetxController{

  final sharedPrefs = SharedPrefs();
  final serverUtils = ServerUtils();
  final ImagePickerController imagePickerController = Get.put(ImagePickerController());

  var current_username = "".obs;
  var current_roll_no = "".obs;
  var current_profile_pic = "".obs;
  var current_profile_color = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getUserDetails();
  }

  void setUsername(String username) {
    current_username.value = username;
  }

  void getUserDetails() async {
    current_username.value = await sharedPrefs.getUsername();
    current_roll_no.value = await sharedPrefs.getRollNo();
    current_profile_pic.value = await sharedPrefs.getProfilePic();
    update();
  }

  void printUserDetails() {
    print('USERNAME: ${current_username.value}');
    print('ROLL NO: ${current_roll_no.value}');
    print('PROFILE PIC: ${current_profile_pic.value}');
  }

  void refreshProfile() async {
    current_profile_pic.value = await sharedPrefs.getProfilePic();
    update();
  }

  void updateProfile() async {
    if(current_profile_pic.value == '') {
      final profilePic = await serverUtils.uploadImage(imagePickerController.image, true);
      current_profile_pic.value = profilePic;
    }
    await serverUtils.updateProfile(current_roll_no.value, current_profile_pic.value, current_username.value);
    await sharedPrefs.setUsername(current_username.value);
    await sharedPrefs.setUsername(current_username.value);
    await sharedPrefs.setProfilePic(current_profile_pic.value);
    update();
  }


}