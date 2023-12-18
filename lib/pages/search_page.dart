import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lost_flutter/pages/home.dart';
import 'package:lost_flutter/pages/post_viewer.dart';
import 'package:lost_flutter/utils/server_utils.dart';
import 'package:lost_flutter/widgets/bottom_nav.dart';
import 'package:lost_flutter/widgets/post_list.dart';

import '../models.dart';

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
    return Scaffold(
      // bottomNavigationBar: BottomNavigator(
      //   index: 1,
      // ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SearchField(onTextChanged: filterSearchResults),
      ),
      body: Stack(
        children: [
          SearchList(
            items: result,
          ),

          BottomNav()
        ],
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
    return TextFormField(
      onChanged: (value) {
        widget.onTextChanged(value);
      },
      decoration: InputDecoration(
          hintText: "Search",
          border: InputBorder.none,
          prefixIcon: Icon(CupertinoIcons.search)),
    );
  }
}
