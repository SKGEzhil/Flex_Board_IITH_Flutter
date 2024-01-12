import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lost_flutter/controllers/google_auth_controller.dart';
import 'package:lost_flutter/controllers/loading_controller.dart';
import 'package:lost_flutter/controllers/network_connectivity_controller.dart';
import 'package:lost_flutter/controllers/post_list_controller.dart';
import 'package:lost_flutter/controllers/profile_controller.dart';
import 'package:lost_flutter/utils/shared_prefs.dart';

import '../globals.dart';
import '../models/user_details_model.dart';
import '../page_builder.dart';
import '../pages/get_started.dart';
import '../utils/server_utils.dart';

class AuthenticationController extends GetxController {

  /// Variables declaration
  var isUserLoggedIn = false.obs;

  /// Utils declaration
  final sharedPrefs = SharedPrefs();
  final serverUtils = ServerUtils();

  /// GetX Controllers
  final GoogleAuthController googleAuthController =
  Get.put(GoogleAuthController());
  final LoadingController loadingController = Get.put(LoadingController());
  final ProfileController profileController = Get.put(ProfileController());
  final PostListController postListController = Get.put(PostListController());


  /// To start Authentication process
  Future<void> initialization() async {

    // Checks if user is logged in
    if (await sharedPrefs.getRollNo() != '') {

      // Fetches user details from shared preferences
      final rollNo = await sharedPrefs.getRollNo();
      final username = await sharedPrefs.getUsername();
      final authMethod = await sharedPrefs.getAuthMethod();

      print('ROLL NO 1: $rollNo');

      // Checks if user is logged in with [Google]
      if (authMethod == 'google') {
        roll_no_ = rollNo;
        username_ = username;
        isUserLoggedIn.value = true;
      }

      // Authenticates user with token
      print('set to true ');
      await tokenAuth(rollNo, username)
          ? isUserLoggedIn.value = true
          : isUserLoggedIn.value = false;
    } else {
      print('set to false ');
      isUserLoggedIn.value = false;
    }
  }

  /// Authenticate user with token when already logged in
  Future<bool> tokenAuth(rollNo, username) async {

    final NetworkController networkController = Get.put(NetworkController());

    // Fetches token from shared preferences
    final token = await sharedPrefs.getAuthToken();
    print('token = $token');

    // Checking for network connectivity
    if (!isConnected) {
      print('NO INTERNET TO AUTHENTICATE TOKEN');
      roll_no_ = rollNo;

      print('ROLL NO 2: $roll_no_');

      sharedPrefs.setRollNo(roll_no_);
      username_ = username;
      sharedPrefs.setUsername(username_);
      sharedPrefs.setFirstLaunch();
      return true;
    }

    // Checks if user is logged in with [Google]
    if(await sharedPrefs.getAuthMethod() == 'google'){
      print('GOOGLE USER TOKEN AUTH');
      return true;
    }

    // Authenticates user with token
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


  /// Authenticate user with [Google]
  void googleSignIn(BuildContext context) async {

    // Authenticates user with [Google]
      await googleAuthController.login(context);
      print('AUTH METHOD: ${await sharedPrefs.getAuthMethod()}');

      // Fetches post data if not fetched already
    if(postListController.result.isEmpty){
      postListController.fetchData();
    }
  }


  /// Register user with [Native] authentication
  void register(name, rollNo, email, password, BuildContext context) async {

    // Checks if all fields are filled
    if (name.isEmpty || rollNo.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all the fields'),
        ),
      );
      return;
    }

    loadingController.startLoading();

    // Registers user with [Native] authentication and fetches token
    final authToken = await serverUtils.register(
        name, rollNo, email, password, fcmToken, context);

    // Checks if registration is successful and verifies user with token
    await sharedPrefs.setAuthToken(authToken);
    bool isRegistrationSuccessful = await serverUtils.loginWithToken(authToken, rollNo, name);
    if (isRegistrationSuccessful) {
      roll_no_ = rollNo;
      sharedPrefs.setRollNo(rollNo);
      username_ = name;
      sharedPrefs.setUsername(username_);
      sharedPrefs.setFirstLaunch();
      profileController.getUserDetails();
      loadingController.stopLoading();

      // Fetches post data if not fetched already
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


  /// Login user with [Native] authentication
  void login(rollNo, password, BuildContext context) async {

    // Checks if all fields are filled
    if (rollNo.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all the fields'),
        ),
      );
      return;
    }

    loadingController.startLoading();

    // Login user with [Native] authentication and fetches token
    final authToken = await serverUtils.login(rollNo, password, fcmToken, context);

    // Checks if login is successful and initializes user data
    if(authToken != ''){

      // Fetches post data if not fetched already
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
      profileController.currentProfilePic.value = userDetails.profilePic;
      profileController.currentUsername.value = username_;
      profileController.currentRollNo.value = rollNo;
      sharedPrefs.setUsername(username_);
      sharedPrefs.setProfilePic(userDetails.profilePic);
      sharedPrefs.setFirstLaunch();
      sharedPrefs.setAuthToken(authToken);
      profileController.getUserDetails();
      print("Login successful, TOKEN: ${await sharedPrefs.getAuthToken()}");
      loadingController.stopLoading();
    }

  }


  /// Logout user
  Future<void> logout(BuildContext context) async {

    Navigator.pushReplacementNamed(context, '/get_started');

    // Checks if user is logged in with [Google]
    print('AUTH METHOD: ${await sharedPrefs.getAuthMethod()}');
    if(await sharedPrefs.getAuthMethod() == 'google'){
      print('GOOGLE USER LOGOUT');
      await googleAuthController.signOut();
    }

    // Logout user
    await serverUtils.logout(roll_no_, fcmToken, context);
    await sharedPrefs.clearAll();
    isUserLoggedIn.value = false;
  }


  /// Returns initial page to be displayed
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
