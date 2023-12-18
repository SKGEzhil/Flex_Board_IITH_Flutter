import 'dart:ui';
import 'dart:io';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_flutter/globals.dart';
import 'package:lost_flutter/pages/home.dart';
import 'package:lost_flutter/utils/server_utils.dart';

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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.deepOrangeAccent.withOpacity(0.1)),
              child: Row(
                children: [
                  IconButton(
                      icon: Icon(Icons.attachment_sharp),
                      onPressed: () {
                        getImage(ImageSource.gallery);
                      }),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () async {
                      await serverUtils.uploadImage(image);
                      serverUtils.createPost(roll_no_, subject.text,
                          content.text, post_image_link, context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
        elevation: 1,
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.6784313725490196),
        title: TitleText(
          pageTitle: 'Create new post',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Column(
            children: [
              TextFormField(
                controller: subject,
                maxLines: 1,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Subject',
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
              ),
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: TextFormField(
                    controller: content,
                    maxLines: null,
                    decoration: InputDecoration(
                        hintText: 'Write Something', border: InputBorder.none),
                  ),
                ),
              ),
              image != null
                  ?
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Attachment',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                        color: Colors.black.withOpacity(0.8)),
                  )
              )
              :
              SizedBox(
                height: 0,
              ),
              Divider(
                height: 1,
                thickness: 1,
              ),

              image != null
                  ?

              Expanded(
                flex: 1,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: image != null
                            ? Image.file(
                                File(image!.path), // Placeholder image URL
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
                    Positioned(
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
                    ),
                  ],
                ),
              )
                  :
              SizedBox(
                height: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
