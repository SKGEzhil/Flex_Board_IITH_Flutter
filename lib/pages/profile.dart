import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:lost_flutter/controllers/bottom_nav_controller.dart';
import 'package:lost_flutter/controllers/post_list_controller.dart';
import 'package:lost_flutter/globals.dart';
import 'package:lost_flutter/utils/shared_prefs.dart';
import 'package:lost_flutter/widgets/bottom_nav.dart';

import '../controllers/post_tag_controller.dart';
import '../widgets/post_list.dart';
import '../widgets/title_text.dart';
import 'home.dart';
import 'package:get/get.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final BottomNavController bottomNavController = Get.put(BottomNavController());
  final PostListController postListController = Get.put(PostListController());
  final PostTagController postTagController = Get.put(PostTagController());

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
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
          title: TitleText(pageTitle: 'Profile'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await SharedPrefs().logout();
                Navigator.pushReplacementNamed(context, '/get_started');
              },
            )
          ]
      ),

      // bottomNavigationBar: BottomNavigator(index: 3,),
        resizeToAvoidBottomInset: true,
        body: PopScope(
          canPop: false,
          onPopInvoked: (bool didPop){
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
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            ProfilePicture(
                                name: username,
                                radius: 50,
                                fontsize: 40),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    '${username}',
                                    maxLines: 1,
                                    style: TextStyle(
                                        overflow: TextOverflow.fade,
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '${roll_no_}',
                                      style: TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, 1),
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
                            backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
                            title: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'My Posts',
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        body: PostList()
                    ),
                  )
                ]),
              ),
              BottomNav()
            ],
          ),
        ));
  }
}
