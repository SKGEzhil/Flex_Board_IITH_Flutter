import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lost_flutter/pages/profile.dart';
import 'package:lost_flutter/pages/search_page.dart';
import 'package:lost_flutter/utils/server_utils.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/post_list.dart';

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
    currentWidget = PostList();
  }
  int currentIndex = 0;

  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;
    });
    print(currentIndex);
  }

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;


    switch (currentWidgetIndex) {
      case 0:
        currentWidget = PostList();
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
        // bottomNavigationBar: const BottomNavigator(index: 0,),
        extendBodyBehindAppBar: true,
        appBar: buildAppBar(context),
        body: Stack(
          children: [
            PostList(),
            BottomNav()
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              // color: Colors.deepOrange.shade500.withOpacity(0.5),
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

