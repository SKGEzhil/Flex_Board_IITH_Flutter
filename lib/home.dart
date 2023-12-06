import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lost_flutter/user_bloc.dart';

import 'globals.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }

  bool _searchBoolean = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        bottomNavigationBar: Container(
          color: Color.fromRGBO(0, 0, 0, 1),
          child: const Padding(
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
                  GButton(icon: Icons.search, text: "Search",),
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
          title: !_searchBoolean ? TitleText() : SearchBar(),
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
              onPressed: () {},
            ) : SizedBox(width: 0,)
          ],
        ),
        body: MyList(),
      ),
    );
  }
}

class TitleText extends StatelessWidget {
  TitleText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: userBloc.userStream,
      builder: (context, snapshot) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Text('${snapshot.data}',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(0, 0, 0, 1.0)),
          ),
        );
      }
    );
  }
}

class MyList extends StatelessWidget {
  final List<String> items = List.generate(30, (index) => 'Item ${index + 1}');

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Container(
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
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Hello World",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: Text(
                                "Lorem Ipsum is simply dummy text of the printing and"
                                    " typesetting industry. Lorem Ipsum has been the "
                                    "industry's standard dummy text ever since the 1500s, "
                                    "when an unknown printer took a galley of type and scrambled "
                                    "it to make a type specimen book. It has survived not "
                                    "only five centuries, but also the leap into electronic",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,),
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
                        'https://via.placeholder.com/500', // Placeholder image URL
                        fit: BoxFit.contain, // Ensure the image fits within the space
                    ),
                      ),)
                  ],
                ),
              ],
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

