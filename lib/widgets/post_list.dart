
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_flutter/controllers/network_connectivity_controller.dart';
import 'package:lost_flutter/controllers/post_list_controller.dart';
import 'package:lost_flutter/controllers/post_seen_controller.dart';
import 'package:lost_flutter/globals.dart';
import 'package:lost_flutter/pages/create_post.dart';
import 'package:lost_flutter/widgets/post_tag.dart';
import 'package:path_provider/path_provider.dart';

import '../models.dart';
import '../pages/post_viewer.dart';
import '../utils/server_utils.dart';
import '../utils/shared_prefs.dart';
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

  void initState() {
    super.initState();
    // fetchData();
  }

  // methods
  Future<void> fetchData() async {
    if (networkController.connectionType != 0) {

      List<Post> posts =
          await serverUtils.getPosts();

      await postSeenController.getSeenPosts();

      // List<String> seen_posts = await serverUtils.getSeenPosts(roll_no_);

      setState(() {
        // seenPosts = seen_posts;
        items = posts;
        if (widget.filter == null) {
          filteredItems = items;
        } else {
          filteredItems =
              items.where((post) => post.rollNo == '${widget.filter}').toList();
        } // Update the state with the fetched data
      });


      // Store list in shared preferences
      await SharedPrefs().storePosts(items);
    } else {
      items = await SharedPrefs().getPosts();
      await postSeenController.getSeenPosts();

      print('NO INTERNET');
      items.forEach((element) async {
        print(element.name);
      });
      setState(() {
        if (widget.filter == null) {
          filteredItems = items;
        } else {
          filteredItems =
              items.where((post) => post.rollNo == '${widget.filter}').toList();
        }
      });
    }
  }


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

    // debugInvertOversizedImages = true;

    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(
          Duration(seconds: 1),
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
                            subject: post.subject,
                            name: post.name,
                            content: post.content,
                            image: post.image,
                            date: post.date,
                            id: post.id,
                        cabFrom: post.cabFrom,
                        cabTo: post.cabTo,
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
                                  "${post.subject}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(

                                      color: postSeenController.seenPosts.value.contains(post.id)
                                          ? Color.fromRGBO(0, 0, 0, 0.6)
                                          : Color.fromRGBO(0, 0, 0, 1),

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
                                  '${post.date}',
                                  style: TextStyle(
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
                                    "${post.content}",
                                    style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 0.7)
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
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
                              ? SizedBox(
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
                                                      Icon(Icons.error),
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

