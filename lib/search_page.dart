import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lost_flutter/home.dart';
import 'package:lost_flutter/post_viewer.dart';
import 'package:lost_flutter/server_utils.dart';

import 'models.dart';

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SearchField(onTextChanged: filterSearchResults),
      ),
      body: SearchList(
        items: result,
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
    return ListView.separated(
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
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "${post.subject}",
                                        maxLines: null,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                        alignment: Alignment.topRight,
                                        child: Text(
                                          '${post.date}',
                                          style: TextStyle(
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.5),
                                              fontSize: 12),
                                        )),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "${post.content}",
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 8, 0),
                          child: Image.network(
                            '${post.image}', // Placeholder image URL
                            fit: BoxFit
                                .contain, // Ensure the image fits within the space
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
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
