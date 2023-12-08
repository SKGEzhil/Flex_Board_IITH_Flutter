import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lost_flutter/create_post.dart';
import 'package:lost_flutter/home.dart';
import 'package:lost_flutter/post_viewer.dart';
import 'package:rive/rive.dart';
import 'get_started.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: <LocalizationsDelegate<dynamic>>[
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromRGBO(
            0, 0, 0, 1.0)),
        useMaterial3: true,
      ),
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        // '/': (context) => const Home(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/create_post': (context) => const CreatePost(),
        '/view_post': (context) => const PostViewer(),
      },
      home: MyRiveAnimation(),
    );
  }
}