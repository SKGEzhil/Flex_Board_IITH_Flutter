import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lost_flutter/controllers/bottom_nav_controller.dart';
import 'package:lost_flutter/controllers/notification_controller.dart';
import 'package:lost_flutter/pages/home.dart';
import 'package:lost_flutter/pages/post_viewer.dart';
import 'package:lost_flutter/pages/profile.dart';
import 'package:lost_flutter/pages/replies_page.dart';
import 'package:lost_flutter/pages/samle_list.dart';
import 'package:lost_flutter/pages/search_page.dart';
import 'package:lost_flutter/widgets/bottom_nav.dart';

class PageBuilder extends StatefulWidget {
  const PageBuilder({super.key});

  @override
  State<PageBuilder> createState() => _PageBuilderState();
}

class _PageBuilderState extends State<PageBuilder> {
  final BottomNavController bottom_nav_controller =
      Get.put(BottomNavController());


  @override
  void initState() {
    super.initState();
    final NotificationController notificationController =
    Get.put(NotificationController());
    if(notificationController.isNotification.value == true){
      Get.to(PostViewer(post: notificationController.post));
    }
  }

  @override
  Widget build(BuildContext context) {
      return Stack(
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: currentPage(),
            ),
            BottomNav(),
          ]
      );
  }

  Widget currentPage() {
    return Obx(() => bottom_nav_controller.currentIndex.value == 0
        ? Home()
        : bottom_nav_controller.currentIndex.value == 1
            ? SearchPage()
            : bottom_nav_controller.currentIndex.value == 2
                ? RepliesPage()
                : Profile());
  }
}
