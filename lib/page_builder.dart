import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lost_flutter/controllers/bottom_nav_controller.dart';
import 'package:lost_flutter/controllers/notification_controller.dart';
import 'package:lost_flutter/pages/home.dart';
import 'package:lost_flutter/pages/post_viewer.dart';
import 'package:lost_flutter/pages/profile.dart';
import 'package:lost_flutter/pages/replies_page.dart';
import 'package:lost_flutter/pages/search_page.dart';
import 'package:lost_flutter/widgets/bottom_nav.dart';

class PageBuilder extends StatefulWidget {
  const PageBuilder({super.key});

  @override
  State<PageBuilder> createState() => _PageBuilderState();
}

class _PageBuilderState extends State<PageBuilder> {

  /// Bottom Navigation Controller
  final BottomNavController bottomNavController =
      Get.put(BottomNavController());

  @override
  void initState() {
    super.initState();
    final NotificationController notificationController =
    Get.put(NotificationController());

    /// Redirects to a specific post when app is opened from notification
    if(notificationController.isNotification.value == true){
      Get.to(PostViewer(post: notificationController.post));
    }
  }

  @override
  Widget build(BuildContext context) {
      return Stack(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: currentPage(),
            ),
            const BottomNav(),
          ]
      );
  }

  Widget currentPage() {
    return Obx(() => bottomNavController.currentIndex.value == 0
        ? const Home()
        : bottomNavController.currentIndex.value == 1
            ? const SearchPage()
            : bottomNavController.currentIndex.value == 2
                ? const RepliesPage()
                : const Profile());
  }
}
