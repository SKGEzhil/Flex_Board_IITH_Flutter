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
import 'package:intl/intl.dart';
import 'package:lost_flutter/controllers/cab_sharing_controller.dart';
import 'package:lost_flutter/controllers/post_tag_controller.dart';
import 'package:lost_flutter/globals.dart';
import 'package:lost_flutter/pages/home.dart';
import 'package:lost_flutter/utils/server_utils.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';

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
  final cabSharingFrom = TextEditingController();
  final cabSharingTo = TextEditingController();
  final CabSharingController cabSharingController = Get.put(CabSharingController());

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
    return PopScope(
      onPopInvoked: (bool didPop) async {
        cabSharingController.fromLocation.value = 'From';
        cabSharingController.toLocation.value = 'To';
      },
      child: Scaffold(
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
                flex: 5,
                child: SingleChildScrollView(
                  child: Obx(() {
                    return Column(
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
                        TextFormField(
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
                        postTagController.isCabSharing.value ?

                        // CabSharingContainer2(cabSharingFrom: cabSharingFrom, cabSharingController: cabSharingController, cabSharingTo: cabSharingTo)
                        Wrap(
                          children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0, 8, 8, 0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(10),
                                      color: Colors.black.withOpacity(0.1)
                                  ),
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(
                                        8, 4, 8, 4),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Cab Sharing',
                                              style: TextStyle(
                                                  color: Colors.black.withOpacity(0.7),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14),
                                            ),
                                            Expanded(
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: TimeTag(),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: (){
                                                showCupertinoDialog(context: context, barrierDismissible: true, builder: (context) {
                                                  return CupertinoAlertDialog(
                                                    title: Text('From Location'),
                                                    content: CupertinoTextField(
                                                      controller: cabSharingFrom,
                                                      placeholder: 'Enter location',
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
                                                        child: Text('Select',
                                                            style: TextStyle(color: Colors.deepOrangeAccent)),
                                                        onPressed: () {
                                                          cabSharingController.fromLocation.value = cabSharingFrom.text;
                                                          Navigator.pop(context);
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(50),
                                                    color: cabSharingController.fromLocation.value == 'From' ? Colors.deepOrange.withOpacity(0.1) : Colors.green.withOpacity(0.1)
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(3.0),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      SizedBox(width: 5,),
                                                      Text(
                                                        'From : ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 14),
                                                      ),

                                                      Text(
                                                        cabSharingController.fromLocation.value == 'From' ? 'Select' : cabSharingController.fromLocation.value,
                                                        style: TextStyle(
                                                            color: cabSharingController.fromLocation.value == 'From' ? Colors.deepOrangeAccent : Colors.green,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 14),
                                                      ),
                                                      SizedBox(width: 5,),


                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 5,),
                                            InkWell(
                                              onTap: (){
                                                showCupertinoDialog(context: context, barrierDismissible: true, builder: (context) {
                                                  return CupertinoAlertDialog(
                                                    title: Text('To Location'),
                                                    content: CupertinoTextField(
                                                      controller: cabSharingTo,
                                                      placeholder: 'Enter location',
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
                                                        child: Text('Select',
                                                            style: TextStyle(color: Colors.deepOrangeAccent)),
                                                        onPressed: () {
                                                          cabSharingController.toLocation.value = cabSharingTo.text;
                                                          Navigator.pop(context);
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(50),
                                                  color: cabSharingController.toLocation.value == 'To' ? Colors.deepOrange.withOpacity(0.1) : Colors.redAccent.withOpacity(0.1),                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(3.0),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      SizedBox(width: 5,),
                                                      Text(
                                                        'To : ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 14),
                                                      ),

                                                      Text(
                                                        cabSharingController.toLocation.value == 'To' ? 'Select' : cabSharingController.toLocation.value,
                                                        style: TextStyle(
                                                            color: cabSharingController.toLocation.value == 'To' ? Colors.deepOrange : Colors.redAccent,
                                                            fontSize: 14),
                                                      ),
                                                      SizedBox(width: 5,),


                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                          ],
                        )

                            : SizedBox(),

                      ],
                    );
                  }
                  ),
                ),
              ),
              Expanded(
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
                      var cabDetails = {
                        'from': cabSharingController.fromLocation.value,
                        'to': cabSharingController.toLocation.value,
                        'time': cabSharingController.dateTime.value
                      };
                      final tags = postTagController.selectedTags;
                      await serverUtils.uploadImage(image);
                      serverUtils.createPost(roll_no_, subject.text, content.text,
                          post_image_link, tags, cabDetails, context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CabSharingContainer2 extends StatelessWidget {
  const CabSharingContainer2({
    super.key,
    required this.cabSharingFrom,
    required this.cabSharingController,
    required this.cabSharingTo,
  });

  final TextEditingController cabSharingFrom;
  final CabSharingController cabSharingController;
  final TextEditingController cabSharingTo;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                Text('Cab Sharing'),
                Expanded(
                  child: Align(
                      alignment: Alignment.centerRight,
                      child:
                      TimeTag()
                  ),
                )
              ],
            ),
            Divider(
              height: 10,
              thickness: 1,
            ),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black.withOpacity(0.1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text('From',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500
                              )
                            ),
                            SizedBox(height: 5,),
                            InkWell(
                              onTap: () {
                                showCupertinoDialog(context: context, barrierDismissible: true, builder: (context) {
                                  return CupertinoAlertDialog(
                                    title: Text('From Location'),
                                    content: CupertinoTextField(
                                      controller: cabSharingFrom,
                                      placeholder: 'Enter location',
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
                                        child: Text('Select',
                                            style: TextStyle(color: Colors.deepOrangeAccent)),
                                        onPressed: () {
                                          cabSharingController.fromLocation.value = cabSharingFrom.text;
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                });
                              },
                              customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: cabSharingController.fromLocation.value == 'From' ? Colors.deepOrangeAccent.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 5,),
                                      Expanded(
                                        child: Text( cabSharingController.fromLocation.value == 'From' ? 'Select' : cabSharingController.fromLocation.value,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                          style: TextStyle(
                                            color: cabSharingController.fromLocation.value == 'From' ? Colors.deepOrangeAccent : Colors.green,
                                          fontWeight: FontWeight.w500
                                        ),),
                                      ),
                                      SizedBox(width: 5,),

                                    ],
                                  ),
                                )
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 20,),
                    Image.asset('assets/cab2.png', width: 100,),
                    SizedBox(width: 20,),
                    Container(
                      width: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black.withOpacity(0.1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text('To',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500
                                )
                            ),
                            SizedBox(height: 5,),
                            InkWell(
                              onTap: () {
                                showCupertinoDialog(context: context, barrierDismissible: true, builder: (context) {
                                  return CupertinoAlertDialog(
                                    title: Text('To Location'),
                                    content: CupertinoTextField(
                                      controller: cabSharingTo,
                                      placeholder: 'Enter location',
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
                                        child: Text('Select',
                                            style: TextStyle(color: Colors.deepOrangeAccent)),
                                        onPressed: () {
                                          cabSharingController.toLocation.value = cabSharingTo.text;
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                });
                              },
                              customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: cabSharingController.toLocation.value == 'To' ? Colors.deepOrangeAccent.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: [
                                        SizedBox(width: 5,),
                                        Text( cabSharingController.toLocation.value == 'To' ? 'Select' : cabSharingController.toLocation.value, style: TextStyle(
                                            color: cabSharingController.toLocation.value == 'To' ? Colors.deepOrangeAccent : Colors.redAccent,
                                            fontWeight: FontWeight.w500
                                        ),),
                                        SizedBox(width: 5,),

                                      ],
                                    ),
                                  )
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
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
        if(tagName == 'Time') {
          showCupertinoModalPopup(
            context: context,
            builder: (_) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white
              ),
              height: 300,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                    ),
                    height: 200,
                    child: CupertinoDatePicker(
                      initialDateTime: DateTime.now(),
                      onDateTimeChanged: (DateTime newDateTime) {
                        print(newDateTime);
                      },
                      mode: CupertinoDatePickerMode.dateAndTime,
                    ),
                  ),

                  // Close the modal
                  CupertinoButton(
                    child: Text('Done'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
            ),
          );        }
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
            if(tagName == 'Cab Sharing') {
              postTagController.isCabSharing.value = false;
            }
          } else {
            postTagController.selectedTags.add(tagName);
            if(tagName == 'Cab Sharing') {
              postTagController.isCabSharing.value = true;
            }
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
                  tagName == 'Create new tag' ? Icons.add :
                  tagName == 'Time' ? Icons.time_to_leave :
                  Icons.sell,
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

class TimeTag extends StatefulWidget {
  TimeTag({
    super.key,
  });

  @override
  State<TimeTag> createState() => _TimeTagState();
}

class _TimeTagState extends State<TimeTag> {
  String time = 'Time';

  final CabSharingController cabSharingController = Get.put(CabSharingController());

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      onTap: () {
          showCupertinoModalPopup(
            context: context,
            builder: (_) => Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white
              ),
              height: 300,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                    ),
                    height: 200,
                    child: CupertinoDatePicker(
                      initialDateTime: DateTime.now(),
                      onDateTimeChanged: (DateTime newDateTime) {
                        print(newDateTime);
                        setState(() {
                          String formattedDateTime = DateFormat('dd MMM HH:mm').format(newDateTime);
                          time = formattedDateTime;
                          cabSharingController.dateTime.value = formattedDateTime;
                        });
                      },
                      mode: CupertinoDatePickerMode.dateAndTime,
                    ),
                  ),

                  // Close the modal
                  CupertinoButton(
                    child: Text('Done'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
            ),
          );
      },
      child:
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.black.withOpacity(0.1),
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
                  Icons.time_to_leave,
                  color: Color.fromRGBO(0, 0, 0, 0.7),
                  size: 15,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  '${time}',
                  style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 0.7), fontSize: 12),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
        )
    );

  }
}

