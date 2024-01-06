import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lost_flutter/controllers/network_connectivity_controller.dart';
import 'package:lost_flutter/controllers/post_list_controller.dart';
import 'package:lost_flutter/controllers/post_tag_controller.dart';
import 'package:lost_flutter/utils/server_utils.dart';
import '../widgets/no_internet.dart';
import '../widgets/post_list.dart';
import 'package:get/get.dart';

import '../widgets/title_text.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  /// Declarations
  final serverUtils = ServerUtils();

  /// GetX Controllers
  final NetworkController networkController = Get.find<NetworkController>();
  final PostTagController postTagController = Get.put(PostTagController());
  final PostListController postListController = Get.put(PostListController());

  @override
  Widget build(BuildContext context) {

    return Obx(() {
      return PopScope(
        canPop: postTagController.selectedTags.isEmpty ? true : false,
        onPopInvoked: (bool didPop) {
          postTagController.resetTags();
          postListController.resetSearch();
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: buildAppBar(context),
          body: Stack(
            children: [
              const PostList(),
              NoInternet()
              // BottomNav()
            ],
          ),
        ),
      );
    }
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            color: Colors.transparent,
          ),
        ),
      ),
      elevation: 1,
      backgroundColor: const Color.fromRGBO(255, 255, 255, 0.6784313725490196),
      title: const TitleText(pageTitle: 'Home'),
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            CupertinoIcons.add,
            color: Color.fromRGBO(0, 0, 0, 1.0),
          ),
          tooltip: 'Create Post',
          onPressed: () {
            throw Exception();
            // Navigator.pushNamed(context, '/create_post');
          },
        )
      ],
    );
  }
}

