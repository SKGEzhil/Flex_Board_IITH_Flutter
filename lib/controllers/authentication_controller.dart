import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lost_flutter/controllers/google_auth_controller.dart';
import 'package:lost_flutter/controllers/loading_controller.dart';
import 'package:lost_flutter/controllers/network_connectivity_controller.dart';
import 'package:lost_flutter/controllers/post_list_controller.dart';
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
  final PostListController postListController = Get.put(PostListController());


  Future<void> initialization() async {
    if (await sharedPrefs.getRollNo() != '') {
      final rollNo = await sharedPrefs.getRollNo();
      final username = await sharedPrefs.getUsername();
      final authMethod = await sharedPrefs.getAuthMethod();

      print('ROLL NO 1: $rollNo');

      if (authMethod == 'google') {
        roll_no_ = rollNo;
        username_ = username;
        isUserLoggedIn.value = true;
      }

      print('set to true ');
      await tokenAuth(rollNo, username)
          ? isUserLoggedIn.value = true
          : isUserLoggedIn.value = false;
    } else {
      print('set to false ');
      isUserLoggedIn.value = false;
    }
  }

  Future<bool> tokenAuth(rollNo, username) async {
    final token = await sharedPrefs.getAuthToken();
    print('token = $token');

    if (networkController.connectionType == 0) {
      print('NO INTERNET TO AUTHENTICATE TOKEN');
      return true;
    }

    if(await sharedPrefs.getAuthMethod() == 'google'){
      print('GOOGLE USER TOKEN AUTH');
      return true;
    }

    bool isAuthSuccess =
        await serverUtils.loginWithToken(token, rollNo, username);

    if (isAuthSuccess) {
      roll_no_ = rollNo;

      print('ROLL NO 2: $roll_no_');

      sharedPrefs.setRollNo(roll_no_);
      username_ = username;
      sharedPrefs.setUsername(username_);
      sharedPrefs.setFirstLaunch();
    }

    return isAuthSuccess;
  }

  void googleSignIn(BuildContext context) async {
    // final isValidRollNo = await serverUtils.validateRollNo(roll_no, context);
    // if (isValidRollNo) {
      await googleAuthController.login(context);
      print('AUTH METHOD: ${await sharedPrefs.getAuthMethod()}');
    // }
    if(postListController.result.isEmpty){
      postListController.fetchData();
    }
  }

  void register(name, rollNo, email, password, BuildContext context) async {

    if (name.isEmpty || rollNo.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all the fields'),
        ),
      );
      return;
    }

    loadingController.startLoading();

    final authToken = await serverUtils.register(
        name, rollNo, email, password, fcmToken, context);

    await sharedPrefs.setAuthToken(authToken);
    bool isRegisterationSuccessful = await serverUtils.loginWithToken(authToken, rollNo, name);
    if (isRegisterationSuccessful) {
      roll_no_ = rollNo;
      sharedPrefs.setRollNo(rollNo);
      username_ = name;
      sharedPrefs.setUsername(username_);
      sharedPrefs.setFirstLaunch();
      profileController.getUserDetails();
      loadingController.stopLoading();

      if(postListController.result.isEmpty){
        postListController.fetchData();
      }

      Navigator.of(context).pop();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PageBuilder(),
          ));
    }
    loadingController.stopLoading();


  }

  void login(rollNo, password, BuildContext context) async {

    if (rollNo.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all the fields'),
        ),
      );
      return;
    }

    loadingController.startLoading();

    final authToken = await serverUtils.login(rollNo, password, fcmToken, context);

    if(authToken != ''){
      if(postListController.result.isEmpty){
        postListController.fetchData();
      }
      Navigator.of(context).pop();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PageBuilder(),
          ));
      sharedPrefs.setRollNo(rollNo);
      roll_no_ = rollNo;
      final UserDetails userDetails = await serverUtils.getUserDetails(rollNo);
      print('USER DETAILS: ${userDetails.name}');
      username_ = userDetails.name;
      profileController.current_profile_pic.value = userDetails.profilePic;
      profileController.current_username.value = username_;
      profileController.current_roll_no.value = rollNo;
      sharedPrefs.setUsername(username_);
      sharedPrefs.setProfilePic(userDetails.profilePic);
      sharedPrefs.setFirstLaunch();
      sharedPrefs.setAuthToken(authToken);
      profileController.getUserDetails();
      print("Login successful, TOKEN: ${await sharedPrefs.getAuthToken()}");
      loadingController.stopLoading();
    }

  }

  Future<void> logout(BuildContext context) async {
    print('AUTH METHOD: ${await sharedPrefs.getAuthMethod()}');
    if(await sharedPrefs.getAuthMethod() == 'google'){
      print('GOOGLE USER LOGOUT');
      await googleAuthController.signOut();
    }
    await serverUtils.logout(roll_no_, fcmToken, context);
    await sharedPrefs.logout();
    isUserLoggedIn.value = false;
    Navigator.pushReplacementNamed(context, '/get_started');
  }

  Widget initialPage() {
    if (isUserLoggedIn.value) {
      print('User is logged in');
      return const PageBuilder();
    } else {
      print('User is not logged in');
      return const GetStarted();
    }
  }

}
