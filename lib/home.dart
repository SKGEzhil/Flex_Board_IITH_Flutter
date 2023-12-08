import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lost_flutter/create_post.dart';
import 'package:lost_flutter/server_utils.dart';
import 'package:lost_flutter/user_bloc.dart';

import 'globals.dart';
import 'models.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }

  final serverUtils = ServerUtils();
  bool _searchBoolean = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        bottomNavigationBar: Container(
          color: Color.fromRGBO(0, 0, 0, 1),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: GNav(
              backgroundColor: Color.fromRGBO(0, 0, 0, 0),
              color: Color.fromRGBO(255, 255, 255, 1),
              activeColor: Color.fromRGBO(255, 255, 255, 1),
              tabBackgroundColor: Color.fromRGBO(
                  100, 100, 100, 0.39215686274509803),
              padding: EdgeInsets.all(16),
              gap: 8,
                tabs: [
                  GButton(icon: Icons.home, text: "Home",),
                  GButton(icon: Icons.search, text: "Search",onPressed: (){
                    serverUtils.getPosts();
                  }),
                  GButton(icon: Icons.comment, text: "Replies",),
                  GButton(icon: CupertinoIcons.profile_circled, text: "Profile",)
                ]
            ),
          ),
        ),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
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
          title: !_searchBoolean ? TitleText(pageTitle: 'Losties',) : SearchBar(),
          actions: <Widget>[
            !_searchBoolean?
            IconButton(
              icon: const Icon(
                CupertinoIcons.search,
                color: Color.fromRGBO(0, 0, 0, 1.0),
              ),
              tooltip: 'Search',
              onPressed: () {
                setState(() { //add
                  _searchBoolean = true;
                });
              },
            ) : IconButton(
              icon: const Icon(
                CupertinoIcons.xmark,
                color: Color.fromRGBO(0, 0, 0, 1.0),
              ),
              tooltip: 'close',
              onPressed: () {
                setState(() { //add
                  _searchBoolean = false;
                });
              },
            ),
            !_searchBoolean?
            IconButton(
              icon: const Icon(
                CupertinoIcons.add,
                color: Color.fromRGBO(0, 0, 0, 1.0),
              ),
              tooltip: 'Create Post',
              onPressed: () {

                // showGeneralDialog(
                //     barrierDismissible: true,
                //     barrierLabel: "SignIn",
                //     context: context,
                //     pageBuilder: (context, _, __) => Center(
                //       child: Container(
                //         height: 500,
                //         decoration: BoxDecoration(
                //             color: Colors.white.withOpacity(0.94),
                //             borderRadius:
                //             BorderRadius.all(Radius.circular(40))),
                //         margin: EdgeInsets.symmetric(horizontal: 16),
                //         padding: EdgeInsets.symmetric(
                //             horizontal: 24, vertical: 32),
                //         child: Scaffold(
                //           resizeToAvoidBottomInset : false,
                //           backgroundColor: Colors.transparent,
                //           body: CreatePost(),
                //         ),
                //       ),
                //     ));
                
                Navigator.pushNamed(context, '/create_post');

              },
            ) : SizedBox(width: 0,)
          ],
        ),
        body: MyList(),
      ),
    );
  }
}

class TitleText extends StatelessWidget {
  final String pageTitle;

  TitleText({
    super.key, required this.pageTitle
  });


  @override
  Widget build(BuildContext context) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Text('$pageTitle',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(0, 0, 0, 1.0)),
            ),
          );
  }
}

class MyList extends StatefulWidget {
  @override
  State<MyList> createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  // final List<String> items = List.generate(30, (index) => 'Item ${index + 1}');
  List<Post> items = []; // Initialize the list
  final serverUtils = ServerUtils();
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    List<Post> posts = await serverUtils.getPosts(); // Wait for the future to complete

    setState(() {
      items = posts; // Update the state with the fetched data
    });

    items.forEach((element) {
      print(element.name);
    });
  }


  // final List<Post> items = ServerUtils().getPosts() as List<Post>;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, index) {
        Post post = items[index];
        return InkWell(
          onTap: (){
            Navigator.pushNamed(context, '/view_post');
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
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "${post.subject}",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.topRight,
                                        child: Text('01/01/2024',
                                        style: TextStyle(
                                          color: Color.fromRGBO(0, 0, 0, 0.5),
                                          fontSize: 12
                                        ),)),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text("${post.content}",
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,),
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
                          fit: BoxFit.contain, // Ensure the image fits within the space
                      ),
                        ),)
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }, separatorBuilder: (BuildContext context, int index) {
        return Divider();
    },
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

