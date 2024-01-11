import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lost_flutter/controllers/loading_controller.dart';
import 'package:lost_flutter/controllers/profile_controller.dart';
import 'package:lost_flutter/globals.dart';
import 'package:lost_flutter/page_builder.dart';
import 'package:lost_flutter/pages/get_started.dart';
import 'package:lost_flutter/pages/loading_page.dart';
import 'package:lost_flutter/utils/server_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_details_model.dart';
import '../utils/shared_prefs.dart';

class GoogleAuthController extends GetxController {
  /// Declarations
  final currentUserDetails = UserDetails(rollNo: '', name: '', profilePic: '');
  final serverUtils = ServerUtils();

  /// GetX Controllers
  final ProfileController profileController = Get.put(ProfileController());
  final LoadingController loadingController = Get.put(LoadingController());

  /// Starts the authentication process
  Future<void> login(context) async {
    loadingController.startLoading();

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoadingPage()));

    // Authenticates user with Google and fetches user credential
    final UserCredential? userCredential = await signInWithGoogle();

    // Checks if user is authenticated successfully
    if (userCredential == null) {
      loadingController.stopLoading();
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const GetStarted());
      return;
    }

    // Fetches user details from user credential
    currentUserDetails.name = (userCredential.user!.displayName)!;
    if (userCredential.user?.photoURL != null) {
      currentUserDetails.profilePic = (userCredential.user!.photoURL)!;
    }

    print('STARTING AUTHENTICATION');

    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Starting authentication')));

    // Authorizes user with server
    bool isAuthorized = await serverUtils.googleRegister(
        currentUserDetails.name,
        userCredential.user!.email!,
        currentUserDetails.profilePic,
        fcmToken,
        context);

    print('AUTHORIZATION STATUS: $isAuthorized');

    // Checks if user is authorized successfully and initializes user details
    if (isAuthorized) {
      print('LOGIN SUCCESSFUL');

      final rollNo = userCredential.user!.email!.split('@')[0];
      currentUserDetails.rollNo = rollNo;
      username_ = currentUserDetails.name;
      roll_no_ = rollNo;
      SharedPrefs().setAuthMethod('google');
      print('AUTH METHOD //: ${await SharedPrefs().getAuthMethod()}');
      SharedPrefs().setUsername(currentUserDetails.name);
      SharedPrefs().setRollNo(rollNo);
      SharedPrefs().setProfilePic(currentUserDetails.profilePic);
      SharedPrefs().setFirstLaunch();

      profileController.currentUsername.value = currentUserDetails.name;
      profileController.currentRollNo.value = currentUserDetails.rollNo;
      profileController.currentProfilePic.value = currentUserDetails.profilePic;

      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login successful')));

      Get.offAll(() => const PageBuilder());

      loadingController.stopLoading();
      return;
    }

    print('Login Failed');

    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed')));

    Get.offAll(() => const GetStarted());
    loadingController.stopLoading();
  }

  /// To sign out user
  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    currentUserDetails.rollNo = '';
    currentUserDetails.name = '';
    currentUserDetails.profilePic = '';
  }

  /// To sign in user with [Google] and get [UserCredential]
  Future<UserCredential?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    if (googleUser == null) {
      loadingController.stopLoading();
      return null;
    }
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
