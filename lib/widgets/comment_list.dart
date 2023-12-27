import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:lost_flutter/controllers/loading_controller.dart';

import '../globals.dart';
import '../models.dart';
import '../utils/server_utils.dart';
import 'package:get/get.dart';

class CommentList extends StatefulWidget {
  final postId;
  final username;
  // final name;

  const CommentList({super.key, required this.postId, this.username, });

  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  // final List<String> items = List.generate(30, (index) => 'Item ${index + 1}');
  List<Reply> items = []; // Initialize the list

  final serverUtils = ServerUtils();
  bool refresh_var = false;
  final reply = TextEditingController();
  final LoadingController loadingController = Get.put(LoadingController());

  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    List<Reply> replies = await serverUtils
        .getReplies(widget.postId); // Wait for the future to complete

    setState(() {
      items = replies; // Update the state with the fetched data
    });

    // items.forEach((element) {
    //   print(element.name);
    // });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Comments',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color.fromRGBO(0, 0, 0, 1.0)),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    Reply reply = items[index];
                    return InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          ProfilePicture(name: reply.name, radius: 15, fontsize: 12),
                          const SizedBox(width: 7),
                          Flexible( // Replaced Expanded with Flexible
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('${reply.name} ',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Flexible( // Added Flexible here
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(reply.date,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black.withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(reply.reply,
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
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider();
                  },
                ),
              ),
              // Add Comment
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: ProfilePicture(
                          name: '$username', radius: 23, fontsize: 18,)),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 7,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 255, 255, 0.4),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Obx(() {
                            return Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: TextFormField(
                                      controller: reply,
                                      cursorColor: Colors.deepOrange,
                                      maxLines: 1,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        hintText: 'Add a comment',
                                        focusColor: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),

                                loadingController.isLoading.value
                                    ? Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: const CupertinoActivityIndicator(),
                                    )
                                    :
                                IconButton(
                                  onPressed: () async {
                                    loadingController.startLoading();
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    await serverUtils.addReply(roll_no_,
                                        reply.text, widget.postId, context);
                                    setState(() {
                                      reply.text = "";
                                      fetchData();
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.send,
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                  ),
                                )
                              ],
                            );
                          }
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}