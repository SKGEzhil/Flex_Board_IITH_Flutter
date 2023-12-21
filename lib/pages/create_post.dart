// import 'dart:ui';
// import 'dart:io';
// import 'dart:async';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:lost_flutter/globals.dart';
// import 'package:lost_flutter/pages/home.dart';
// import 'package:lost_flutter/utils/server_utils.dart';
//
// class CreatePost extends StatefulWidget {
//   const CreatePost({super.key});
//
//   @override
//   State<CreatePost> createState() => _CreatePostState();
// }
//
// class _CreatePostState extends State<CreatePost> {
//   XFile? image;
//
//   final ImagePicker picker = ImagePicker();
//   final serverUtils = ServerUtils();
//   final subject = TextEditingController();
//   final content = TextEditingController();
//
//   //we can upload image from camera or from gallery based on parameter
//   Future getImage(ImageSource media) async {
//     try {
//       var img = await picker.pickImage(source: media);
//       if (img != null) {
//         setState(() {
//           image = img;
//         });
//       }
//     } catch (e) {
//       print("Error picking image: $e");
//       // Handle the error as needed
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       appBar: AppBar(
//         flexibleSpace: ClipRRect(
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//             child: Container(
//               color: Colors.transparent,
//             ),
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(50),
//                   color: Colors.deepOrangeAccent.withOpacity(0.1)),
//               child: Row(
//                 children: [
//                   IconButton(
//                       icon: Icon(Icons.attachment_sharp),
//                       onPressed: () {
//                         getImage(ImageSource.gallery);
//                       }),
//                   IconButton(
//                     icon: Icon(Icons.send),
//                     onPressed: () async {
//                       await serverUtils.uploadImage(image);
//                       serverUtils.createPost(roll_no_, subject.text,
//                           content.text, post_image_link, context);
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//         elevation: 1,
//         backgroundColor: Color.fromRGBO(255, 255, 255, 0.6784313725490196),
//         title: TitleText(
//           pageTitle: 'Create new post',
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Scaffold(
//           resizeToAvoidBottomInset: true,
//           body: Column(
//             children: [
//               TextFormField(
//                 controller: subject,
//                 maxLines: 1,
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   hintText: 'Subject',
//                 ),
//               ),
//               Divider(
//                 height: 1,
//                 thickness: 1,
//               ),
//               Expanded(
//                 flex: 3,
//                 child: SingleChildScrollView(
//                   child: TextFormField(
//                     controller: content,
//                     maxLines: null,
//                     decoration: InputDecoration(
//                         hintText: 'Write Something', border: InputBorder.none),
//                   ),
//                 ),
//               ),
//               image != null
//                   ?
//               Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     'Attachment',
//                     style: TextStyle(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 17,
//                         color: Colors.black.withOpacity(0.8)),
//                   )
//               )
//               :
//               SizedBox(
//                 height: 0,
//               ),
//               Divider(
//                 height: 1,
//                 thickness: 1,
//               ),
//
//               image != null
//                   ?
//
//               Expanded(
//                 flex: 1,
//                 child: Stack(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(10),
//                         child: image != null
//                             ? Image.file(
//                                 File(image!.path), // Placeholder image URL
//                                 fit: BoxFit
//                                     .contain, // Ensure the image fits within the space
//                               )
//                             : CachedNetworkImage(
//                                 imageUrl:
//                                     'https://via.placeholder.com/500', // Placeholder image URL
//                                 fit: BoxFit
//                                     .contain, // Ensure the image fits within the space
//                               ),
//                       ),
//                     ),
//                     Positioned(
//                       right: 0.0,
//                       child: GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             image = null;
//                           });
//                         },
//                         child: Align(
//                           alignment: Alignment.topRight,
//                           child: CircleAvatar(
//                             radius: 10.0,
//                             backgroundColor: Colors.black,
//                             child: Icon(
//                               Icons.close,
//                               color: Colors.white,
//                               size: 15.0,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//                   :
//               SizedBox(
//                 height: 0,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:ui';
import 'dart:io';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_flutter/controllers/post_tag_controller.dart';
import 'package:lost_flutter/globals.dart';
import 'package:lost_flutter/pages/home.dart';
import 'package:lost_flutter/utils/server_utils.dart';
import 'package:get/get.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  XFile? image;

  final ImagePicker picker = ImagePicker();
  final serverUtils = ServerUtils();
  final subject = TextEditingController();
  final content = TextEditingController();
  final dataKey = new GlobalKey();
  final PostTagController postTagController = Get.put(PostTagController());

  ScrollController _scrollController = ScrollController();

  _scrollToBottom() {}

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    try {
      var img = await picker.pickImage(source: media);
      if (img != null) {
        setState(() {
          image = img;
        });
      }
    } catch (e) {
      print("Error picking image: $e");
      // Handle the error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        elevation: 1,
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.6784313725490196),
        title: TitleText(
          pageTitle: 'Create new post',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Subject:",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(68, 68, 68, 1.0)),
                        )),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: subject,
                      maxLines: 1,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.deepOrangeAccent,
                            width: 1.5,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                        focusColor: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                        key: dataKey,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Body:",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color.fromRGBO(68, 68, 68, 1.0)),
                        )),
                    SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      onTap: () {
                        _scrollToBottom();
                      },
                      child: TextFormField(
                        onTap: () {
                          Scrollable.ensureVisible(dataKey.currentContext!);
                        },
                        controller: content,
                        maxLines: 4,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.deepOrangeAccent,
                              width: 1.5,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          focusColor: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black.withOpacity(0.1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('Add a tag'),
                                Expanded(
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child:
                                          PostTag(tagName: 'Create new tag')),
                                )
                              ],
                            ),
                            Divider(
                              height: 10,
                              thickness: 1,
                            ),
                            Obx(() {
                              return SingleChildScrollView(
                                child: Wrap(
                                  spacing: 5,
                                  runSpacing: 5,
                                  children: postTagController.allTags
                                      .map((tag) => PostTag(tagName: tag))
                                      .toList(),
                                ),
                              );
                            })
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    getImage(ImageSource.gallery);
                  },
                  child: Container(
                    height: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromRGBO(255, 114, 33, 0.5),
                      // border: Border.all(
                      //     color: Colors.black,
                      //     width: 1
                      // )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Attachment:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                      color: Color.fromRGBO(68, 68, 68, 1.0)),
                                ),
                                Text(
                                  "Click here to attach image",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Color.fromRGBO(68, 68, 68, 1.0)),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: image != null
                                          ? Image.file(
                                              File(image!
                                                  .path), // Placeholder image URL
                                              fit: BoxFit
                                                  .contain, // Ensure the image fits within the space
                                            )
                                          : CachedNetworkImage(
                                              imageUrl:
                                                  'https://via.placeholder.com/500', // Placeholder image URL
                                              fit: BoxFit
                                                  .contain, // Ensure the image fits within the space
                                            ),
                                    ),
                                  ),
                                  image != null
                                      ? Positioned(
                                          right: 0.0,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                image = null;
                                              });
                                            },
                                            child: Align(
                                              alignment: Alignment.topRight,
                                              child: CircleAvatar(
                                                radius: 10.0,
                                                backgroundColor: Colors.black,
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 15.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CupertinoButton(
                  color: Colors.black,
                  child: Text('Post'),
                  onPressed: () async {
                    final tags = postTagController.selectedTags;
                    await serverUtils.uploadImage(image);
                    serverUtils.createPost(roll_no_, subject.text, content.text,
                        post_image_link, tags, context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostTag extends StatelessWidget {
  PostTag({
    super.key,
    required this.tagName,
  });

  final PostTagController postTagController = Get.put(PostTagController());
  final createTagController = TextEditingController();
  final tagName;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      onTap: () {
        if (tagName == 'Create new tag') {
          showCupertinoDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Text('Create new tag'),
                  content: CupertinoTextField(
                    controller: createTagController,
                    placeholder: 'Enter tag name',
                  ),
                  actions: [
                    CupertinoDialogAction(
                      child: Text('Cancel',
                          style: TextStyle(color: Colors.deepOrangeAccent)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    CupertinoDialogAction(
                      child: Text('Create',
                          style: TextStyle(color: Colors.deepOrangeAccent)),
                      onPressed: () {
                        postTagController.allTags
                            .add(createTagController.text);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              });

        } else {
          if (postTagController.selectedTags.contains(tagName)) {
            postTagController.selectedTags.remove(tagName);
          } else {
            postTagController.selectedTags.add(tagName);
          }
        }
      },
      child: Obx(() {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.black.withOpacity(0.1),
              border: postTagController.selectedTags.contains(tagName)
                  ? Border.all(color: Colors.deepOrangeAccent, width: 1)
                  : null
              // color: Color.fromRGBO(255, 114, 33, 0.3),
              ),
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 5,
                ),
                Icon(
                  tagName == 'Create new tag' ? Icons.add : Icons.sell,
                  color: Color.fromRGBO(0, 0, 0, 0.7),
                  size: 15,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  '${tagName}',
                  style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 0.7), fontSize: 12),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
