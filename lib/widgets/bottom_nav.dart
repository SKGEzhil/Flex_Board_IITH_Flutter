import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lost_flutter/controllers/bottom_nav_controller.dart';
import 'package:lost_flutter/controllers/post_list_controller.dart';
import 'package:lost_flutter/controllers/post_tag_controller.dart';
import 'package:lost_flutter/controllers/replies_controller.dart';
import 'package:lost_flutter/globals.dart';
import 'package:lost_flutter/pages/search_page.dart';
import 'package:lost_flutter/utils/server_utils.dart';

import '../pages/home.dart';
import '../pages/profile.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {


  final BottomNavController bottomNavController = Get.put(BottomNavController());
  final currentIndex = Get.find<BottomNavController>().currentIndex;
  final PostListController postListController = Get.put(PostListController());
  final RepliesController repliesController = Get.put(RepliesController());
  final PostTagController postTagController = Get.put(PostTagController());
  late Widget currentWidget;


  void setBottomBarIndex(index) {
    bottomNavController.changeIndex(index);
    postListController.resetSearch();
    postTagController.resetTags();
    switch (index) {
      case 2:
        repliesController.fetchData();
        currentWidget = Home();
        break;
      case 3:
        currentWidget = Profile();
        postListController.userPosts(roll_no_);
        break;
    }

  }

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;

    return Positioned(
      bottom: 0,
      left: 0,
      child: Container(
        width: size.width,
        height: 80,
        child: Stack(
          // overflow: Overflow.visible,
          children: [
            ClipPath(
              clipper: ClipPathClass(),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: CustomPaint(
                  size: Size(size.width, 80),
                  painter: BNBCustomPainter(),
                ),
              ),
            ),
            Center(
              heightFactor: 0.6,
              child: SizedBox(
                height: 65,
                child: FittedBox(
                  child: FloatingActionButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                      backgroundColor: Colors.deepOrangeAccent, elevation: 0.1,
                      onPressed: () {
                      ServerUtils().getSeenPosts(roll_no_);
                        Navigator.pushNamed(context, '/create_post');
                      },
                      child: const Icon(Icons.add)
                  ),
                ),
              ),
            ),
            Obx(() {
              return Container(
                width: size.width,
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.home,
                        color: currentIndex == 0 ? Colors.orange : Colors.grey.shade400,
                      ),
                      onPressed: () {
                        setBottomBarIndex(0);
                      },
                      splashColor: Colors.white,
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.search,
                          color: currentIndex == 1 ? Colors.orange : Colors.grey.shade400,
                        ),
                        onPressed: () {
                          setBottomBarIndex(1);
                        }),
                    Container(
                      width: size.width * 0.20,
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.comment,
                          color: currentIndex == 2 ? Colors.orange : Colors.grey.shade400,
                        ),
                        onPressed: () {
                          setBottomBarIndex(2);
                        }),
                    IconButton(
                        icon: Icon(
                          Icons.person,
                          color: currentIndex == 3 ? Colors.orange : Colors.grey.shade400,
                        ),
                        onPressed: () {
                          setBottomBarIndex(3);
                        }),
                  ],
                ),
              );},
            )
          ],
        ),
      ),
    );

  }
}

class ClipPathClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20), radius: Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Color.fromRGBO(0, 0, 0, 0.8)
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20), radius: Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

