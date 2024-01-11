import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lost_flutter/controllers/network_connectivity_controller.dart';
import 'package:lost_flutter/controllers/post_list_controller.dart';
import 'package:lost_flutter/controllers/post_seen_controller.dart';
import 'package:lost_flutter/controllers/post_viewer_controller.dart';
import 'package:lost_flutter/globals.dart';
import 'package:lost_flutter/widgets/post_tag.dart';
import '../models/post_model.dart';
import '../pages/post_viewer.dart';
import '../utils/server_utils.dart';
import 'cab_sharing_container.dart';

class PostList extends StatefulWidget {
  const PostList({
    super.key,
    this.filter, this.page,
  });

  @override
  State<PostList> createState() => _PostListState();
  final filter;
  final page;
}

class _PostListState extends State<PostList> {

  /// Declarations
  final serverUtils = ServerUtils();

  /// GetX Controllers
  final PostSeenController postSeenController = Get.put(PostSeenController());
  final NetworkController networkController = Get.find<NetworkController>();
  final PostListController postListController = Get.put(PostListController());
  final PostViewerController postViewerController =
  Get.put(PostViewerController());

  int scrollPosition = 0;

  /// Check if post is seen
  void seenCheck(post) async {
    if (networkController.connectionType != 0) {
      await ServerUtils().setSeenPosts(roll_no_, post);
      postSeenController.getSeenPosts();
    } else {
      postSeenController.getSeenPosts();
    }
  }

  late ScrollController _controller;

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        // scrollPosition = 1;
      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        scrollPosition = 0;
      });
    }
  }


  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () {
          return Future.delayed(
            const Duration(seconds: 1),
                () {
              postListController.fetchData();
            },
          );
        },
        child: GetBuilder<PostListController>(
          builder: (_) =>
              SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      // add this line
                      controller: _controller,
                      itemCount: postListController.result.length,
                      itemBuilder: (context, index) {
                        Post post = postListController.result[index];
                        return InkWell(
                          onTap: () {
                            seenCheck(post.id);
                            postViewerController.getProfilePic(post.rollNo);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PostViewer(
                                        post: post,
                                      )),
                            );
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    post.rollNo == roll_no_ &&
                                        widget.page != 'profile'
                                        ?
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Container(
                                        height: 15,
                                        decoration: BoxDecoration(
                                          color: Colors.deepOrange.withOpacity(
                                              0.5),
                                          borderRadius: BorderRadius.circular(
                                              10),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text('Posted by you',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.black.withOpacity(
                                                    0.7),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ) :
                                    const SizedBox(
                                      height: 0,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8, 4, 8, 8),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Obx(() {
                                                return Text(
                                                  post.subject,
                                                  maxLines: 1,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                  style: TextStyle(
                                                    color: postSeenController
                                                        .seenPosts
                                                        .contains(post.id)
                                                        ? const Color.fromRGBO(
                                                        0, 0, 0, 0.4)
                                                        : const Color.fromRGBO(
                                                        0, 0, 0, 1),

                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15,
                                                    // fontWeight: FontWeight.bold
                                                  ),
                                                );
                                              }),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Align(
                                                alignment: Alignment.topRight,
                                                child: Text(
                                                  post.date,
                                                  style: const TextStyle(
                                                      color: Color.fromRGBO(
                                                          0, 0, 0, 0.5),
                                                      fontSize: 12),
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8, 0, 8, 0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Obx(() {
                                                    return Text(
                                                      post.content,
                                                      style: TextStyle(
                                                        color: postSeenController
                                                            .seenPosts
                                                            .contains(post.id)
                                                            ? const Color
                                                            .fromRGBO(
                                                            0, 0, 0, 0.3)
                                                            : const Color
                                                            .fromRGBO(
                                                            0, 0, 0, 0.7),),
                                                      maxLines: 3,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                    );
                                                  }),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Wrap(
                                                  children: [
                                                    if (post.tags
                                                        .contains(
                                                        'Cab Sharing'))
                                                      CabSharingContainer(
                                                        cabDate: post.cabDate,
                                                        cabFrom: post.cabFrom,
                                                        cabTo: post.cabTo,
                                                        isCreatePost: false,
                                                      )
                                                    else
                                                      for (var tag in post.tags)
                                                        Padding(
                                                          padding: const EdgeInsets
                                                              .fromLTRB(
                                                              0, 8, 8, 0),
                                                          child: InkWell(
                                                              onTap: () {
                                                                null;
                                                              },
                                                              child: PostTag(
                                                                tagName: tag,
                                                                isSearch: true,
                                                              )),
                                                        )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          post.image == ''
                                              ? const SizedBox(
                                            width: 0,
                                          )
                                              : Expanded(
                                            flex: 1,
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: SizedBox(
                                                  height: 70,
                                                  width: 70,
                                                  child: Card(
                                                    elevation: 5,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          10),
                                                      child: CachedNetworkImage(
                                                        height: 75,
                                                        fit: BoxFit.cover,
                                                        imageUrl:
                                                        post.image,
                                                        memCacheHeight: 200,
                                                        memCacheWidth: 200,
                                                        errorWidget: (context,
                                                            url, error) =>
                                                        const Icon(
                                                            Icons.error),
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.black.withOpacity(0.1),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
        ));
  }
}
