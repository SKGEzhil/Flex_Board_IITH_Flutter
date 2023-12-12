import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lost_flutter/pages/post_viewer.dart';
import 'package:lost_flutter/pages/profile.dart';
import 'package:lost_flutter/pages/search_page.dart';
import 'package:lost_flutter/utils/server_utils.dart';
import 'package:lost_flutter/utils/shared_prefs.dart';
import 'package:path_provider/path_provider.dart';
import '../models.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final serverUtils = ServerUtils();
  bool _searchBoolean = false;
  int viewer = 0;
  late Widget currentWidget;
  late Widget appbarWidget;
  int currentWidgetIndex = 0;



  void initState() {
    super.initState();
    currentWidget = MyList();
  }


  @override
  Widget build(BuildContext context) {
    switch (currentWidgetIndex) {
      case 0:
        currentWidget = MyList();
        break;
      case 1:
        currentWidget = SearchPage();
        break;
      case 2:
        currentWidget = Placeholder();
        break;
      case 3:
        currentWidget = Profile();
        break;
    }

    return PopScope(
      canPop: false,
      child: Scaffold(
        bottomNavigationBar: const BottomNavigator(index: 0,),
        extendBodyBehindAppBar: true,
        appBar: buildAppBar(context),
        body: currentWidget,
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: false,
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
        title: _searchBoolean ?
            SearchBar() :
        TitleText(
          pageTitle: 'Home',
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              CupertinoIcons.add,
              color: Color.fromRGBO(0, 0, 0, 1.0),
            ),
            tooltip: 'Create Post',
            onPressed: () {
              Navigator.pushNamed(context, '/create_post');
            },
          )
        ],
      );
  }
}

class BottomNavigator extends StatelessWidget {
  const BottomNavigator({
    super.key, required this.index,
  });

  final index;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(0, 0, 0, 1),
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 6, 15, 15),
        child: GNav(
            backgroundColor: Color.fromRGBO(0, 0, 0, 0),
            color: Color.fromRGBO(255, 255, 255, 1),
            activeColor: Color.fromRGBO(255, 255, 255, 1),
            tabBackgroundColor:
                Color.fromRGBO(100, 100, 100, 0.39215686274509803),
            padding: EdgeInsets.all(16),
            selectedIndex: index,
            gap: 8,
            tabs: [
              GButton(
                icon: Icons.home,
                text: "Home",
                onPressed: () {
                  // setState(() {
                  //   _searchBoolean = false;
                  //   currentWidgetIndex = 0;
                  // });

                  Navigator.push(context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) => Home(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );

                },
              ),
              GButton(
                  icon: Icons.search,
                  text: "Search",
                  onPressed: () {
                    Navigator.push(context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) => SearchPage(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );

                  }),
              GButton(
                icon: Icons.comment,
                text: "Replies",
                onPressed: () {
                  // setState(() {
                  //   _searchBoolean = false;
                  //   currentWidgetIndex = 2;
                  // });

                  Navigator.push(context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) => Home(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );

                },
              ),
              GButton(
                icon: CupertinoIcons.profile_circled,
                text: "Profile",
                onPressed: () {
                  // setState(() {
                  //   _searchBoolean = false;
                  //   currentWidgetIndex = 3;
                  // });

                  Navigator.push(context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) => Profile(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );

                },
              )
            ]),
      ),
    );
  }
}

class TitleText extends StatelessWidget {
  final String pageTitle;

  TitleText({super.key, required this.pageTitle});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        '$pageTitle',
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Color.fromRGBO(0, 0, 0, 1.0)),
      ),
    );
  }
}

class MyList extends StatefulWidget {
  MyList({super.key, this.filter});

  @override
  State<MyList> createState() => _MyListState();
  final filter;
}

class _MyListState extends State<MyList> {

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

    if(await ServerUtils().isConnected()) {
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
      items.forEach((element) async {
        print(element.name);
      });
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
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
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

                            child: Card(
                              elevation: 5,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  height: 75,
                                  fit: BoxFit.cover,
                                  imageUrl: '${post.image}',
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                ),
                              ),
                            )
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
          return SizedBox();
        },
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          hintText: "Search",
          border: InputBorder.none,
          prefixIcon: Icon(CupertinoIcons.search)),
    );
  }
}
