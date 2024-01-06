import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:lost_flutter/controllers/bottom_nav_controller.dart';
import 'package:lost_flutter/controllers/post_list_controller.dart';
import 'package:lost_flutter/controllers/replies_controller.dart';
import 'package:lost_flutter/pages/post_viewer.dart';
import 'package:lost_flutter/widgets/no_internet.dart';

import '../models.dart';
import '../utils/server_utils.dart';
import 'package:get/get.dart';

import '../widgets/title_text.dart';

class RepliesPage extends StatefulWidget {
  const RepliesPage({super.key});

  @override
  State<RepliesPage> createState() => _RepliesPageState();
}

class _RepliesPageState extends State<RepliesPage> {

  /// Declarations
  final serverUtils = ServerUtils();

  /// GetX Controllers
  final RepliesController repliesController = Get.put(RepliesController());
  final PostListController postListController = Get.put(PostListController());
  final BottomNavController bottomNavController =
      Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        bottomNavController.changeIndex(0);
      },
      child: Scaffold(
        appBar: AppBar(title: const TitleText(pageTitle: 'Replies')),
        body: Stack(
          children: [
            GetBuilder<RepliesController>(
              builder: (_) => repliesController.items.isEmpty
                  ? Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.red.withOpacity(0.1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'No replies yet',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.red.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: repliesController.items.length,
                      itemBuilder: (context, index) {
                        Reply reply = repliesController.items[index];

                        return InkWell(
                          onTap: () {
                            repliesController.isOpened.value = true;
                            final postItems = postListController.items
                                .where((element) => element.id == reply.postId);
                            Post post = postItems.first;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PostViewer(post: post)),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                reply.profilePic != ''
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: CachedNetworkImage(
                                          imageUrl: reply.profilePic,
                                          width: 30,
                                          fit: BoxFit.cover,
                                          height: 30,
                                        ),
                                      )
                                    : ProfilePicture(
                                        name: reply.name,
                                        radius: 15,
                                        fontsize: 14),
                                const SizedBox(width: 7),
                                Flexible(
                                  // Replaced Expanded with Flexible
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '${reply.name} has replied to your post: ',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Flexible(
                                            // Added Flexible here
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                reply.date,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        reply.reply,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
            ),
            NoInternet()
          ],
        ),
      ),
    );
  }
}
