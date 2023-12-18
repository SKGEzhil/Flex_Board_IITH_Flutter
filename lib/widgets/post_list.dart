//
//
// import 'dart:io';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
//
// import '../models.dart';
// import '../pages/post_viewer.dart';
// import '../utils/server_utils.dart';
// import '../utils/shared_prefs.dart';
//
// class PostList extends StatefulWidget {
//   PostList({super.key, this.filter});
//
//   @override
//   State<PostList> createState() => _PostListState();
//   final filter;
// }
//
// class _PostListState extends State<PostList> {
//
//   // inits
//   List<Post> items = []; // Initialize the list
//   final serverUtils = ServerUtils();
//   List<Post> filteredItems = [];
//
//
//   void initState() {
//     super.initState();
//     fetchData();
//   }
//
//   // methods
//   Future<void> fetchData() async {
//
//     if(await ServerUtils().isConnected()) {
//       List<Post> posts =
//       await serverUtils.getPosts(); // Wait for the future to complete
//       setState(() {
//         items = posts;
//         if (widget.filter == null) {
//           filteredItems = items;
//         } else {
//           filteredItems =
//               items.where((post) => post.rollNo == '${widget.filter}').toList();
//         } // Update the state with the fetched data
//       });
//       // items.forEach((element) async {
//       //   print(element.name);
//       // });
//       // Store list in shared preferences
//       await SharedPrefs().storePosts(items);
//     } else {
//       items = await SharedPrefs().getPosts();
//       print('NO INTERNET');
//       items.forEach((element) async {
//         print(element.name);
//       });
//       setState(() {
//         if (widget.filter == null) {
//           filteredItems = items;
//         } else {
//           filteredItems =
//               items.where((post) => post.rollNo == '${widget.filter}').toList();
//         }
//       });
//     }
//
//   }
//
//   Future<XFile> getImageXFileByUrl(String url) async {
//     Directory tempDir = await getTemporaryDirectory();
//     String tempPath = tempDir.path;
//     String fileName = "image${DateTime.now().millisecondsSinceEpoch}";
//     File fileWrite = new File("$tempPath/$fileName");
//     Uri uri = Uri.parse(url);
//     final response = await get(uri);
//     fileWrite.writeAsBytesSync(response.bodyBytes);
//     final file = XFile("$tempPath/$fileName");
//     return file;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return RefreshIndicator(
//       onRefresh: () {
//         return Future.delayed(
//           Duration(seconds: 1),
//               () {
//             setState(() {
//               fetchData();
//             });
//           },
//         );
//       },
//       child: ListView.separated(
//         itemCount: filteredItems.length,
//         itemBuilder: (context, index) {
//           Post post = filteredItems[index];
//           return InkWell(
//             onTap: () {
//               // Navigator.pushNamed(context, '/view_post');
//
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => PostViewer(
//                       subject: post.subject,
//                       name: post.name,
//                       content: post.content,
//                       image: post.image,
//                       date: post.date,
//                       id: post.id,
//                     )),
//               );
//
//             },
//             child: Container(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(
//                           flex: 3,
//                           child: Column(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       flex: 2,
//                                       child: Align(
//                                         alignment: Alignment.topLeft,
//                                         child: Text(
//                                           "${post.subject}",
//                                           maxLines: 2,
//                                           overflow: TextOverflow.ellipsis,
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: Align(
//                                           alignment: Alignment.topRight,
//                                           child: Text(
//                                             '${post.date}',
//                                             style: TextStyle(
//                                                 color:
//                                                 Color.fromRGBO(0, 0, 0, 0.5),
//                                                 fontSize: 12),
//                                           )),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
//                                 child: Align(
//                                   alignment: Alignment.topLeft,
//                                   child: Text(
//                                     "${post.content}",
//                                     maxLines: 3,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                         SizedBox(
//                           width: 20,
//                         ),
//                         post.image == '' ? SizedBox(
//                           width: 0,
//                         ) :
//                         Expanded(
//                           flex: 1,
//                           child: Padding(
//                               padding: const EdgeInsets.fromLTRB(0, 10, 8, 0),
//
//                               child: Card(
//                                 elevation: 5,
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(10),
//                                   child: CachedNetworkImage(
//                                     height: 75,
//                                     fit: BoxFit.cover,
//                                     imageUrl: '${post.image}',
//                                     // memCacheHeight: 200,
//                                     // memCacheWidth: 200,
//                                     errorWidget: (context, url, error) => Icon(Icons.error),
//                                   ),
//                                 ),
//                               )
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//         separatorBuilder: (BuildContext context, int index) {
//           return SizedBox();
//         },
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../models.dart';
import '../pages/post_viewer.dart';
import '../utils/server_utils.dart';
import '../utils/shared_prefs.dart';

class PostList extends StatefulWidget {
  PostList({super.key, this.filter});

  @override
  State<PostList> createState() => _PostListState();
  final filter;
}

class _PostListState extends State<PostList> {
  // inits
  List<Post> items = []; // Initialize the list
  final serverUtils = ServerUtils();
  List<Post> filteredItems = [];

  void initState() {
    super.initState();
    fetchData();
  }

  // methods
  Future<void> fetchData() async {
    if (await ServerUtils().isConnected()) {
      List<Post> posts =
          await serverUtils.getPosts(); // Wait for the future to complete
      setState(() {
        items = posts;
        if (widget.filter == null) {
          filteredItems = items;
        } else {
          filteredItems =
              items.where((post) => post.rollNo == '${widget.filter}').toList();
        } // Update the state with the fetched data
      });
      // items.forEach((element) async {
      //   print(element.name);
      // });
      // Store list in shared preferences
      await SharedPrefs().storePosts(items);
    } else {
      items = await SharedPrefs().getPosts();
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

  Future<XFile> getImageXFileByUrl(String url) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String fileName = "image${DateTime.now().millisecondsSinceEpoch}";
    File fileWrite = new File("$tempPath/$fileName");
    Uri uri = Uri.parse(url);
    final response = await get(uri);
    fileWrite.writeAsBytesSync(response.bodyBytes);
    final file = XFile("$tempPath/$fileName");
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(
          Duration(seconds: 1),
          () {
            setState(() {
              fetchData();
            });
          },
        );
      },
      child: ListView.separated(
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          Post post = filteredItems[index];
          return InkWell(
            onTap: () {
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
                            child: Text(
                              "${post.subject}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
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
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "${post.content}",
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
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
                                            // memCacheHeight: 200,
                                            // memCacheWidth: 200,
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
    );
  }
}
