import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_flutter/controllers/authentication_controller.dart';
import 'package:lost_flutter/controllers/bottom_nav_controller.dart';
import 'package:lost_flutter/controllers/image_picker_controller.dart';
import 'package:lost_flutter/controllers/post_list_controller.dart';
import 'package:lost_flutter/globals.dart';
import 'package:lost_flutter/widgets/no_internet.dart';
import '../controllers/post_tag_controller.dart';
import '../controllers/profile_controller.dart';
import '../widgets/post_list.dart';
import '../widgets/title_text.dart';
import 'package:get/get.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';

class Profile extends StatefulWidget {
  const Profile({
    super.key,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  /// GetX Controllers
  final BottomNavController bottomNavController =
      Get.put(BottomNavController());
  final PostListController postListController = Get.put(PostListController());
  final PostTagController postTagController = Get.put(PostTagController());
  final ImagePickerController imagePickerController =
      Get.put(ImagePickerController());
  final ProfileController profileController = Get.put(ProfileController());
  final AuthenticationController authenticationController =
      Get.put(AuthenticationController());


  /// Show popup to edit profile
  void editProfile() {
    showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Edit Profile'),
            content: Container(
              child: Column(
                children: [
                  ClipOval(
                    child: Stack(
                      children: [
                        GetBuilder<ImagePickerController>(
                          builder: (_) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: profileController.currentProfilePic.value !=
                                    ''
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: CachedNetworkImage(
                                      imageUrl: profileController
                                          .currentProfilePic.value,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(
                                    child: imagePickerController.image != null
                                        ? Image.file(
                                            File(imagePickerController
                                                .image!.path),
                                            fit: BoxFit.cover,
                                            height: 100,
                                            width: 100,
                                          )
                                        : AdvancedAvatar(
                                            name: username_,
                                            size: 100,
                                            decoration: BoxDecoration(
                                              color: Colors.redAccent
                                                  .withOpacity(0.7),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                          ),
                                  ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 60,
                                ),
                                InkWell(
                                  customBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(70),
                                  ),
                                  onTap: () {
                                    print('Edit Profile Picture');
                                    imagePickerController
                                        .getImage(ImageSource.gallery);
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(70),
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                      size: 18,
                                      color: Color.fromRGBO(213, 213, 213, 1.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Change Username:',
                          style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontSize: 14,
                              fontWeight: FontWeight.w500))),
                  const SizedBox(
                    height: 5,
                  ),
                  CupertinoTextField(
                    placeholder: 'Username',
                    onChanged: (value) {
                      profileController.setUsername(value);
                      print(profileController.currentUsername.value);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            actions: [
              CupertinoDialogAction(
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  profileController.getUserDetails();
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: const Text('OK',
                    style: TextStyle(color: Colors.deepOrange)),
                onPressed: () {
                  profileController.updateProfile();
                  // profileController.getUserDetails();
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            elevation: 1,
            backgroundColor: const Color.fromRGBO(255, 255, 255, 0.6),
            title: const TitleText(pageTitle: 'Profile'),
            actions: [
              IconButton(
                icon: const Icon(Icons.info_outline_rounded),
                onPressed: () {
                  Get.toNamed('/info');
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  authenticationController.logout(context);
                },
              )
            ]),

        // bottomNavigationBar: BottomNavigator(index: 3,),
        resizeToAvoidBottomInset: true,
        body: PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) {
            postTagController.resetTags();
            postListController.resetSearch();
            bottomNavController.changeIndex(0);
          },
          child: Stack(
            children: [
              SafeArea(
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        GetBuilder<ProfileController>(
                          builder: (_) => Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  profileController.currentProfilePic.value !=
                                          ''
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: CachedNetworkImage(
                                            imageUrl: profileController
                                                .currentProfilePic.value,
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : AdvancedAvatar(
                                          name: username_,
                                          size: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.redAccent
                                                .withOpacity(0.7),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                        ),
                                  // ProfilePicture(
                                  //     name: username,
                                  //     radius: 50,
                                  //     fontsize: 40),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          profileController
                                              .currentUsername.value,
                                          maxLines: 1,
                                          style: const TextStyle(
                                              overflow: TextOverflow.fade,
                                              color: Color.fromRGBO(0, 0, 0, 1),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            profileController
                                                .currentRollNo.value,
                                            style: const TextStyle(
                                                color:
                                                    Color.fromRGBO(0, 0, 0, 1),
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                editProfile();
                              },
                              customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(50)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.edit,
                                      color: Colors.black.withOpacity(0.6),
                                      size: 15,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Edit',
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.6),
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Scaffold(
                        extendBodyBehindAppBar: true,
                        backgroundColor: Colors.transparent,
                        appBar: AppBar(
                            automaticallyImplyLeading: false,
                            flexibleSpace: ClipRRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                            elevation: 1,
                            backgroundColor:
                                const Color.fromRGBO(255, 255, 255, 0.6),
                            title: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'My Posts',
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        body: const PostList(
                          page: 'profile',
                        )),
                  )
                ]),
              ),
              NoInternet()
            ],
          ),
        ));
  }
}
