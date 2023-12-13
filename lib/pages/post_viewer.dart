import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lost_flutter/globals.dart';
import 'package:lost_flutter/pages/home.dart';
import 'package:lost_flutter/pages/image_viewer.dart';
import 'package:lost_flutter/models.dart';
import 'package:lost_flutter/utils/server_utils.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

class PostViewer extends StatefulWidget {
  const PostViewer(
      {super.key,
      this.subject,
      this.name,
      this.content,
      this.image,
      this.id,
      this.date});

  final subject;
  final name;
  final content;
  final image;
  final id;
  final date;

  @override
  State<PostViewer> createState() => _PostViewerState();
}

class _PostViewerState extends State<PostViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.4),
          flexibleSpace: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          title: TitleText(pageTitle: ''),
        ),
        body: Stack(
          children: [
            Center(
              child: widget.image == '' ? SizedBox(height: 0,)
                  :
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider('${widget.image}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
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
                        '${widget.subject}',
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        ProfilePicture(
                          name: '${widget.name}',
                          radius: 20,
                          fontsize: 16,
                          random: true,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            '${widget.name}',
                            style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Expanded(
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Text('${widget.date}')))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${widget.content}',
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontSize: 18,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                  widget.image == '' ? SizedBox(height: 0,)
                      :
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ImageViewer(
                                    image: widget.image,
                                  )),
                        );
                      },
                      child: Card(
                        elevation: 5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                              imageUrl: '${widget.image}',
                              fit: BoxFit.cover,
                              width: 400,
                              height: 200),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.favorite,
                              color: Color.fromRGBO(0, 0, 0, 1),
                            )),
                        IconButton(
                            onPressed: () {
                              showModalBottomSheet<void>(
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 20, sigmaY: 20),
                                    child: Container(
                                        decoration: new BoxDecoration(
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.5),
                                          borderRadius: new BorderRadius.only(
                                            topLeft:
                                                const Radius.circular(25.0),
                                            topRight:
                                                const Radius.circular(25.0),
                                          ),
                                        ),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.75,
                                        child: Stack(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 30, 8, 25),
                                              child: CommentList(
                                                postId: widget.id,
                                                username: widget.name,),
                                            ),
                                          ],
                                        )),
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              Icons.comment,
                              color: Color.fromRGBO(0, 0, 0, 1),
                            )),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.share,
                            color: Color.fromRGBO(0, 0, 0, 1),
                          ),
                        )
                      ])),
                  SizedBox(
                    height: 50,
                  )
                ]),
              ),
            ),
          ],
        ));
  }
}

class CommentList extends StatefulWidget {
  final postId;
  final username;
  // final name;

  CommentList({super.key, required this.postId, this.username, });

  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  // final List<String> items = List.generate(30, (index) => 'Item ${index + 1}');
  List<Reply> items = []; // Initialize the list

  final serverUtils = ServerUtils();
  bool refresh_var = false;
  final reply = TextEditingController();

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

    items.forEach((element) {
      print(element.name);
    });
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
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
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
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    Reply reply = items[index];
                    return InkWell(
                      onTap: () {},
                      child: Container(
                          child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                    'https://via.placeholder.com/500'),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  '${reply.name}',
                                  style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${reply.reply}',
                                style: TextStyle(
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      )),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
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
                            name: '${widget.username}', radius: 23, fontsize: 18, random: true,)),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 7,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 0.4),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: TextFormField(
                                    controller: reply,
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      hintText: 'Add a comment',
                                      focusColor: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await serverUtils.addReply(roll_no_,
                                      reply.text, widget.postId, context);
                                  setState(() {
                                    reply.text = "";
                                    fetchData();
                                  });
                                },
                                icon: Icon(
                                  Icons.send,
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                ),
                              )
                            ],
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
