import 'package:get/get.dart';
import 'package:lost_flutter/controllers/image_picker_controller.dart';

import '../utils/server_utils.dart';
import '../utils/shared_prefs.dart';

class ProfileController extends GetxController{

  /// Observables
  var currentUsername = ''.obs;
  var currentRollNo = ''.obs;
  var currentProfilePic = ''.obs;
  var currentProfileColor = ''.obs;

  /// GetX Controllers
  final ImagePickerController imagePickerController = Get.put(ImagePickerController());


  @override
  void onInit() {
    super.onInit();
    getUserDetails();
  }

  /// Sets username
  void setUsername(String username) {
    currentUsername.value = username;
  }

  /// Gets user details from shared preferences
  void getUserDetails() async {
    currentUsername.value = await SharedPrefs().getUsername();
    currentRollNo.value = await SharedPrefs().getRollNo();
    currentProfilePic.value = await SharedPrefs().getProfilePic();
    update();
  }

  void printUserDetails() {
    print('USERNAME: ${currentUsername.value}');
    print('ROLL NO: ${currentRollNo.value}');
    print('PROFILE PIC: ${currentProfilePic.value}');
  }

  /// Updates user details from shared preferences
  void refreshProfile() async {
    currentProfilePic.value = await SharedPrefs().getProfilePic();
    update();
  }

  /// Updates user details to server
  void updateProfile() async {
    if(currentProfilePic.value == '') {
      final profilePic = await ServerUtils().uploadImage(imagePickerController.image, true);
      currentProfilePic.value = profilePic;
    }
    await ServerUtils().updateProfile(currentRollNo.value, currentProfilePic.value, currentUsername.value);
    await SharedPrefs().setUsername(currentUsername.value);
    await SharedPrefs().setUsername(currentUsername.value);
    await SharedPrefs().setProfilePic(currentProfilePic.value);
    update();
  }


}