
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lost_flutter/controllers/network_connectivity_controller.dart';
import 'package:lost_flutter/controllers/post_list_controller.dart';
import 'package:lost_flutter/controllers/post_seen_controller.dart';
import 'package:lost_flutter/globals.dart';
import 'package:lost_flutter/widgets/post_tag.dart';
import '../models.dart';
import '../pages/post_viewer.dart';
import '../utils/server_utils.dart';
import 'cab_sharing_container.dart';

class PostList extends StatefulWidget {
  PostList({super.key, this.filter,});

  @override
  State<PostList> createState() => _PostListState();
  final filter;
}

class _PostListState extends State<PostList> {
  // inits
  List<Post> items = [];
  List<String> seenPosts = [];
  final serverUtils = ServerUtils();
  List<Post> filteredItems = [];
  final PostSeenController postSeenController = Get.put(PostSeenController());
  final NetworkController networkController = Get.find<NetworkController>();
  final PostListController postListController = Get.put(PostListController());

  void seenCheck(post) async {
    if(networkController.connectionType != 0){
      await ServerUtils().setSeenPosts(roll_no_, post);
      postSeenController.getSeenPosts();
    } else {
      postSeenController.getSeenPosts();
    }

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
      ListView.separated(
          itemCount: postListController.result.length,
          itemBuilder: (context, index) {
             Post post = postListController.result[index];
            return InkWell(
              onTap: () {
                seenCheck(post.id);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PostViewer(
                            post: post,
                          )),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Obx((){
                                return Text(
                                  post.subject,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(

                                      color: postSeenController.seenPosts.contains(post.id)
                                          ? const Color.fromRGBO(0, 0, 0, 0.6)
                                          : const Color.fromRGBO(0, 0, 0, 1),

                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      // fontWeight: FontWeight.bold
                                  ),
                                );
                              }
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Align(
                                alignment: Alignment.topRight,
                                child: Text(
                                  post.date,
                                  style: const TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 0.5),
                                      fontSize: 12),
                                )),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    post.content,
                                    style: const TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 0.7)
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Wrap(
                                  children: [
                                    if(post.tags.contains('Cab Sharing'))
                                         CabSharingContainer(cabDate: post.cabDate, cabFrom: post.cabFrom, cabTo: post.cabTo, isCreatePost: false,)
                                        else
                                    for (var tag in post.tags)
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 8, 8, 0),
                                        child: InkWell(
                                          onTap: () {null;},
                                            child: PostTag(tagName: tag, isSearch: true,)
                                        ),
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
                                    child: Container(
                                        height: 70,
                                        width: 70,
                                        child: Card(
                                          elevation: 5,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                              height: 75,
                                              fit: BoxFit.cover,
                                              imageUrl: '${post.image}',
                                              memCacheHeight: 200,
                                              memCacheWidth: 200,
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
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
      )
    );
  }
}

