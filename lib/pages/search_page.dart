import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lost_flutter/controllers/bottom_nav_controller.dart';
import 'package:lost_flutter/pages/home.dart';
import 'package:lost_flutter/pages/post_viewer.dart';
import 'package:lost_flutter/utils/server_utils.dart';
import 'package:lost_flutter/widgets/bottom_nav.dart';
import 'package:get/get.dart';
import 'package:lost_flutter/widgets/post_list.dart';

import '../controllers/post_list_controller.dart';
import '../controllers/post_tag_controller.dart';
import '../models.dart';
import 'create_post.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Post> items = []; // Initialize the list
  List<Post> initialItems = [];
  List<Post> result = [];
  final serverUtils = ServerUtils();
  final BottomNavController bottom_nav_controller =
      Get.put(BottomNavController());
  final PostListController postListController =
      Get.put(PostListController());
  final PostTagController postTagController = Get.put(PostTagController());
  final tagSearch = TextEditingController();

  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    List<Post> posts =
        await serverUtils.getPosts(); // Wait for the future to complete
    setState(() {
      items = posts;
      result = posts;
    });
  }

  void filterSearchResults(String query) {
    print(query);

    if(query.isEmpty){
      setState(() {
        result = items;
      });
      return;
    } else {
      setState(() {
        result = items
            .where(
                (post) => post.subject.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) {

      },
      child: Scaffold(
        // bottomNavigationBar: BottomNavigator(
        //   index: 1,
        // ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: SearchField(onTextChanged: postListController.filterSearchResults)
        ),
        body: Stack(
          children: [

            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10)),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Search with Tags',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                      color: Colors.black.withOpacity(0.7),
                                      fontSize: 13),
                              ),

                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    height: 30,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        color: Colors.deepOrange.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(60)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            SizedBox(width: 7,),
                                            Icon(
                                              Icons.search,
                                              color: Colors.black.withOpacity(0.7),
                                              size: 17,
                                            ),
                                            SizedBox(width: 7,),
                                            Expanded(
                                              child: TextFormField(
                                                onChanged: (value) {
                                                  postTagController.searchTags(value);
                                                },
                                                controller: tagSearch,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                ),
                                                decoration: InputDecoration.collapsed(
                                                    hintText: "Search",
                                                    hintStyle: TextStyle(
                                                      fontSize: 13,
                                                        color: Colors.black.withOpacity(0.5)),
                                                    border: InputBorder.none,

                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 7,),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )

                            ],
                          ),
                          Divider(
                            height: 10,
                            color: Colors.black.withOpacity(0.1),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                            child: Obx(() {
                              return Wrap(
                                direction: Axis.horizontal,
                                spacing: 5,
                                runSpacing: 5,
                                children: postTagController.resultTags
                                    .map((tag) => PostTag(tagName: tag, isSearch: true,))
                                    .toList(),
                              );
                            }
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: PostList()
                )

              ],
            ),

            // BottomNav()
          ],
        ),
      ),
    );
  }
}

class SearchList extends StatefulWidget {
  SearchList({super.key, required this.items});
  @override
  State<SearchList> createState() => _SearchListState();
  final List<Post> items;
}

class _SearchListState extends State<SearchList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        Post post = widget.items[index];
        return InkWell(
          onTap: () {
            // Navigator.pushNamed(context, '/view_post');

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
          child: Container(
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
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold
                                ),
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
                                      color:
                                      Color.fromRGBO(0, 0, 0, 0.5),
                                      fontSize: 12),
                                )
                            ),
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
                              ),),
                          ),
                          post.image == ''
                              ? SizedBox(
                            width: 0,
                          )
                              :
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                  height: 70,
                                  width: 70,
                                  child: Card(
                                    elevation: 5,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        height: 75,
                                        fit: BoxFit.cover,
                                        imageUrl: '${post.image}',
                                        // memCacheHeight: 200,
                                        // memCacheWidth: 200,
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                      ),
                                    ),
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        );

      },
    );
  }
}

class SearchField extends StatefulWidget {
  const SearchField({super.key, required this.onTextChanged});

  final Function(String) onTextChanged;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(60)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: Colors.black.withOpacity(0.7),
              size: 23,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextFormField(
                onChanged: (value) {
                  widget.onTextChanged(value);
                },
                decoration: InputDecoration.collapsed(
                    hintText: "Search",
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.6)),
                    border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
