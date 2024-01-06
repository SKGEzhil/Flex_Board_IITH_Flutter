import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lost_flutter/controllers/notification_controller.dart';
import 'package:lost_flutter/controllers/post_viewer_controller.dart';
import 'package:lost_flutter/controllers/replies_controller.dart';
import 'package:lost_flutter/pages/image_viewer.dart';
import 'package:lost_flutter/models.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import '../widgets/cab_sharing_container.dart';
import '../widgets/comment_list.dart';
import '../widgets/title_text.dart';

class PostViewer extends StatefulWidget {
  const PostViewer({super.key, required this.post});

  final Post post;

  @override
  State<PostViewer> createState() => _PostViewerState();
}

class _PostViewerState extends State<PostViewer> {

  /// GetX Controllers
  final RepliesController repliesController = RepliesController();
  final PostViewerController postViewerController =
      Get.put(PostViewerController());

  @override
  void initState() {
    super.initState();

    // postViewerController.getProfilePic(widget.post.rollNo);

    if (repliesController.isOpened.value == true) {
      showReplies();
    }
    final NotificationController notificationController =
        Get.put(NotificationController());
    if (notificationController.isNotification.value == true) {
      notificationController.isNotification.value = false;
    }
  }

  void showReplies() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showModalBottomSheet<void>(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                  ),
                ),
                height: MediaQuery.of(context).size.height * 0.75,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 30, 8, 25),
                      child: CommentList(
                        postId: widget.post.id,
                        username: widget.post.name,
                      ),
                    ),
                  ],
                )),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) {
        print('POPPED');
      },
      child: Scaffold(
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 1,
            backgroundColor: const Color.fromRGBO(255, 255, 255, 0.4),
            flexibleSpace: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            title: const TitleText(pageTitle: ''),
          ),
          body: Stack(
            children: [
              Center(
                child: widget.post.image == ''
                    ? Container(
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 0.7),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                                CachedNetworkImageProvider(widget.post.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.7),
                ),
              ),
              Positioned.fill(
                  child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                child: const SizedBox(
                  width: 10,
                  height: 10,
                ),
              )),
              SafeArea(
                child: SingleChildScrollView(
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.post.subject,
                          style: const TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GetBuilder<PostViewerController>(
                          builder: (_) => Row(
                            children: [
                              widget.post.profilePic != ''
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: CachedNetworkImage(
                                        imageUrl: widget.post.profilePic,
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : ProfilePicture(
                                      name: widget.post.name,
                                      radius: 20,
                                      fontsize: 16,
                                    ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  widget.post.name,
                                  style: const TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Expanded(
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(widget.post.date)))
                            ],
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.post.content,
                          style: const TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontSize: 18,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                    widget.post.cabFrom == 'From'
                        ? const SizedBox(
                            height: 0,
                          )
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                            child: CabSharingContainer(
                              cabDate: widget.post.cabDate,
                              cabFrom: widget.post.cabFrom,
                              cabTo: widget.post.cabTo,
                              isCreatePost: false,
                            ),
                          ),
                    widget.post.image == ''
                        ? const SizedBox(
                            height: 0,
                          )
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ImageViewer(
                                            image: widget.post.image,
                                          )),
                                );
                              },
                              child: Card(
                                elevation: 5,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                      imageUrl: widget.post.image,
                                      fit: BoxFit.cover,
                                      width: 400,
                                      height: 200),
                                ),
                              ),
                            ),
                          ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          onTap: () {
                            showReplies();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(0, 0, 0, 0.1),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(Icons.comment),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('Add a reply'),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    )
                  ]),
                ),
              ),
            ],
          )),
    );
  }
}
