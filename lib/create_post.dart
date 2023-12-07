import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lost_flutter/home.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  void _onWillPop() {
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Subject:",
                  style: TextStyle(
                      fontSize: 16, color: Color.fromRGBO(68, 68, 68, 1.0)),
                )),
            TextFormField(
              maxLines: 2,
              decoration: InputDecoration(
                focusColor: Colors.black,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Body:",
                  style: TextStyle(
                      fontSize: 16, color: Color.fromRGBO(68, 68, 68, 1.0)),
                )),
            TextFormField(
              maxLines: 6,
              decoration: InputDecoration(
                focusColor: Colors.black,
              ),
            ),
            SizedBox(height: 30,),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black,
                  width: 1
                )
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CupertinoButton(
                      color: Colors.black,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(CupertinoIcons.cloud_upload_fill),
                            Text('Attach Image'),
                          ],
                        ),
                        onPressed: () {}),
                    SizedBox(width: 10,),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Image.network(
                          'https://via.placeholder.com/500', // Placeholder image URL
                          fit: BoxFit.contain, // Ensure the image fits within the space
                        ),
                      ),)
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: CupertinoButton(
                    color: Colors.black,
                    child: Text('Submit'),
                    onPressed: () {},
                  ),
                ),
              ),
            ),

          ],
        ),
      ),

    );
  }
}
