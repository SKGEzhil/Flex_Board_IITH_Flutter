
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:lost_flutter/controllers/network_binding.dart';
import 'package:lost_flutter/globals.dart';
import 'package:lost_flutter/page_builder.dart';
import 'package:lost_flutter/pages/create_post.dart';
import 'package:lost_flutter/pages/home.dart';
import 'package:lost_flutter/pages/profile.dart';
import 'package:lost_flutter/pages/search_page.dart';
import 'package:lost_flutter/themes.dart';
import 'package:lost_flutter/utils/firebase_options.dart';
import 'package:lost_flutter/pages/post_viewer.dart';
import 'package:lost_flutter/utils/server_utils.dart';
import 'package:lost_flutter/utils/shared_prefs.dart';
import 'pages/get_started.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();


Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("SKGEzhil Notification");

  // Extract data from the message
  final Map<String, dynamic> data = message.data;

  // Display a notification
  final AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'your_channel_id', // Change this to a unique channel ID
    'Your channel name',
    importance: Importance.max,
    priority: Priority.high,
  );
  NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0, // Notification ID
    '${data['name']}', // Notification title
    '${data['body']}', // Notification body
    platformChannelSpecifics,
    payload: 'item x', // Optional payload
  );
}

Future<void> initializations() async {
  // Firebase initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

    final notificationSettings =
    await FirebaseMessaging.instance.requestPermission(provisional: true);

    print("HELLO WORLD");
    isConnected = true;

    // Firebase message handler
    FirebaseMessaging.instance.subscribeToTopic("topic");
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((message) => firebaseMessagingBackgroundHandler);
    final token = await FirebaseMessaging.instance.getToken();
    fcmToken = token!;
    print(token);

  // Initialize local notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings initializationSettingsIOS =
  DarwinInitializationSettings();
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

}

Future<int> userInit() async {
  int number = await SharedPrefs().checkFirstLaunch();
  print(number);
  if (number == 0) {
    final roll_no = await SharedPrefs().getRollNo();
    final username = await SharedPrefs().getUsername();
    final token = await SharedPrefs().getAuthToken();
    print('token = $token');
    int isAuthSuccess = await ServerUtils().loginWithToken(token, roll_no, username);
    if (isAuthSuccess == 1) {
      print('roll_no_ = $roll_no_');
      return 1;
    } else {
      return 0;
    }
  } else {
    return 0;
  }
}

var isUserLoggedIn = 0;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    if (await ServerUtils().isConnected()) {
      if(Platform.isAndroid) {
        await initializations();
      }
      isUserLoggedIn = await userInit();
      FlutterNativeSplash.remove();
    } else {
      if (await SharedPrefs().checkFirstLaunch() == 0) {
        isUserLoggedIn = 1;
        roll_no_ = await SharedPrefs().getRollNo();
        username = await SharedPrefs().getUsername();
      } else {
        isUserLoggedIn = 0;
      }
      FlutterNativeSplash.remove();
    }

  GestureBinding.instance.resamplingEnabled = true;
  runApp(MyApp(isUserLoggedIn: isUserLoggedIn));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isUserLoggedIn});

  final int isUserLoggedIn;

  Widget _getScreenId() {
    if (isUserLoggedIn == 1) {
      return const PageBuilder();
    } else {
      return GetStarted();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: <LocalizationsDelegate<dynamic>>[
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
      ],

      initialBinding: NetworkBinding(),

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        //   canvasColor: Colors.transparent,
        // bottomSheetTheme: BottomSheetThemeData(
        //     backgroundColor: Colors.black.withOpacity(0)),
        useMaterial3: true,
      ),

      // theme: ThemeClass.lightTheme,
      // darkTheme: ThemeClass.darkTheme,
      // themeMode: ThemeMode.system,

      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        // '/': (context) => const Home(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/create_post': (context) => const CreatePost(),
        '/get_started': (context) => GetStarted(),
        '/view_post': (context) => const PostViewer(),
      },
      home: _getScreenId(),
    );
  }
}
