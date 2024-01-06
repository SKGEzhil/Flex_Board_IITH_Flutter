import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lost_flutter/controllers/loading_controller.dart';
import 'package:lost_flutter/controllers/profile_controller.dart';
import 'package:lost_flutter/globals.dart';
import 'package:lost_flutter/page_builder.dart';
import 'package:lost_flutter/utils/server_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models.dart';
import '../utils/shared_prefs.dart';

class GoogleAuthController extends GetxController {
  final currentUserDetails = UserDetails(rollNo: '', name: '', profilePic: '');
  final serverUtils = ServerUtils();
  final ProfileController profileController = Get.put(ProfileController());
  final LoadingController loadingController = Get.put(LoadingController());

  Future<void> login(context) async {

    loadingController.startLoading();

    final UserCredential userLogin = await signInWithGoogle();

    if(userLogin.user == null){
      await FirebaseAuth.instance.signOut();
      return;
    }

    currentUserDetails.name = userLogin.user!.displayName!;
    if(userLogin.user?.photoURL != null){
      currentUserDetails.profilePic = userLogin.user!.photoURL!;
    }

    bool isAuthorized = await serverUtils.googleRegister(
        currentUserDetails.name,
        userLogin.user!.email!,
        currentUserDetails.profilePic,
        fcmToken,
        context);

    if (isAuthorized) {
      final roll_no = userLogin.user!.email!.split('@')[0];
      currentUserDetails.rollNo = roll_no;
      username_ = currentUserDetails.name;
      roll_no_ = roll_no;
      SharedPrefs().setAuthMethod('google');
      print('AUTH METHOD //: ${await SharedPrefs().getAuthMethod()}');
      SharedPrefs().setUsername(currentUserDetails.name);
      SharedPrefs().setRollNo(roll_no);
      SharedPrefs().setProfilePic(currentUserDetails.profilePic);
      SharedPrefs().setFirstLaunch();

      profileController.current_username.value = currentUserDetails.name;
      profileController.current_roll_no.value = currentUserDetails.rollNo;
      profileController.current_profile_pic.value = currentUserDetails.profilePic;

      Navigator.of(context).pop();

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const PageBuilder()));

      loadingController.stopLoading();
    }

    loadingController.stopLoading();
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    currentUserDetails.rollNo = '';
    currentUserDetails.name = '';
    currentUserDetails.profilePic = '';
  }

  Future<UserCredential> signInWithGoogle() async {
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
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
