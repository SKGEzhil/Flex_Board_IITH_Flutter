import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lost_flutter/controllers/google_auth_controller.dart';
import 'package:lost_flutter/controllers/loading_controller.dart';
import 'package:lost_flutter/controllers/network_connectivity_controller.dart';
import 'package:lost_flutter/controllers/profile_controller.dart';
import 'package:lost_flutter/utils/shared_prefs.dart';

import '../globals.dart';
import '../models.dart';
import '../page_builder.dart';
import '../pages/get_started.dart';
import '../utils/server_utils.dart';

class AuthenticationController extends GetxController {
  var isUserLoggedIn = false.obs;

  final sharedPrefs = SharedPrefs();
  final serverUtils = ServerUtils();

  final GoogleAuthController googleAuthController =
  Get.put(GoogleAuthController());
  final NetworkController networkController = Get.put(NetworkController());
  final LoadingController loadingController = Get.put(LoadingController());
  final ProfileController profileController = Get.put(ProfileController());


  Future<void> initialization() async {
    if (await sharedPrefs.getRollNo() != '') {
      final roll_no = await sharedPrefs.getRollNo();
      final username = await sharedPrefs.getUsername();
      final auth_method = await sharedPrefs.getAuthMethod();

      print('ROLL NO 1: $roll_no');

      if (auth_method == 'google') {
        roll_no_ = roll_no;
        username_ = username;
        isUserLoggedIn.value = true;
      }

      print('set to true ');
      await tokenAuth(roll_no, username)
          ? isUserLoggedIn.value = true
          : isUserLoggedIn.value = false;
    } else {
      print('set to false ');
      isUserLoggedIn.value = false;
    }
  }

  Future<bool> tokenAuth(roll_no, username) async {
    final token = await sharedPrefs.getAuthToken();
    print('token = $token');

    if (networkController.connectionType == 0) {
      print('NO INTERNET TO AUTHENTICATE TOKEN');
      return true;
    }

    bool isAuthSuccess =
        await serverUtils.loginWithToken(token, roll_no, username);

    if (isAuthSuccess) {
      roll_no_ = roll_no;

      print('ROLL NO 2: $roll_no_');

      sharedPrefs.setRollNo(roll_no_);
      username_ = username;
      sharedPrefs.setUsername(username_);
      sharedPrefs.setFirstLaunch();
    }

    return isAuthSuccess;
  }

  void googleSignIn(roll_no, BuildContext context) async {
    final isValidRollNo = await serverUtils.validateRollNo(roll_no, context);


    if (isValidRollNo) {
      googleAuthController.login(roll_no, context);
    }
  }

  void register(name, roll_no, email, password, BuildContext context) async {

    if (name.isEmpty || roll_no.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all the fields'),
        ),
      );
      return;
    }

    loadingController.startLoading();

    final auth_token = await serverUtils.register(
        name, roll_no, email, password, fcmToken, context);

    await sharedPrefs.setAuthToken(auth_token);
    bool isRegisterationSuccessful = await serverUtils.loginWithToken(auth_token, roll_no, name);
    if (isRegisterationSuccessful) {
      profileController.getUserDetails();
      loadingController.stopLoading();
      Navigator.of(context).pop();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PageBuilder(),
          ));
    }
    loadingController.stopLoading();


  }

  void login(roll_no, password, BuildContext context) async {

    if (roll_no.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all the fields'),
        ),
      );
      return;
    }

    loadingController.startLoading();

    final auth_token = await serverUtils.login(roll_no, password, fcmToken, context);

    if(auth_token != ''){
      Navigator.of(context).pop();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PageBuilder(),
          ));
      sharedPrefs.setRollNo(roll_no);
      roll_no_ = roll_no;
      final UserDetails userDetails = await serverUtils.getUserDetails(roll_no);
      print('USER DETAILS: ${userDetails.name}');
      username_ = userDetails.name;
      profileController.current_profile_pic.value = userDetails.profilePic;
      profileController.current_username.value = username_;
      profileController.current_roll_no.value = roll_no;
      sharedPrefs.setUsername(username_);
      sharedPrefs.setProfilePic(userDetails.profilePic);
      sharedPrefs.setFirstLaunch();
      sharedPrefs.setAuthToken(auth_token);
      profileController.getUserDetails();
      print("Login successful, TOKEN: ${await sharedPrefs.getAuthToken()}");
      loadingController.stopLoading();
    }

  }

  Future<void> logout(BuildContext context) async {

    await serverUtils.logout(roll_no_, fcmToken, context);
    await sharedPrefs.logout();
    if(await sharedPrefs.getAuthMethod() == 'google_user'){
      print('GOOGLE USER LOGOUT');
      await googleAuthController.signOut();
    }
    isUserLoggedIn.value = false;
    Navigator.pushReplacementNamed(context, '/get_started');
  }

  Widget initialPage() {
    if (isUserLoggedIn.value) {
      print('User is logged in');
      return const PageBuilder();
    } else {
      print('User is not logged in');
      return GetStarted();
    }
  }

  @override
  void onInit() {
    super.onInit();
  }
}
