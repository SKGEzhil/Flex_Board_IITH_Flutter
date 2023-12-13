import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:lost_flutter/pages/create_post.dart';
import 'package:lost_flutter/utils/firebase_options.dart';
import 'package:lost_flutter/pages/post_viewer.dart';
import 'package:lost_flutter/utils/server_utils.dart';
import 'pages/get_started.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("SKGEzhil Notification");

  // Extract data from the message
  final Map<String, dynamic> data = message.data;

  // // Your JSON data as a string
  // String jsonString = data as String;
  //
  // // Decode the JSON string into a List of maps
  // List<dynamic> jsonList = jsonDecode(jsonString);
  //
  // // Convert each map to a Post object
  // List<Post> posts = jsonList.map((json) => Post.fromJson(json)).toList();

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

  // Firebase message handler
  await FirebaseMessaging.instance.subscribeToTopic("topic");
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance
      .getInitialMessage()
      .then((message) => firebaseMessagingBackgroundHandler);
  final token = await FirebaseMessaging.instance.getToken();
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

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  if(await ServerUtils().isConnected()) {
    await initializations();
    FlutterNativeSplash.remove();
  }
  FlutterNativeSplash.remove();

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        //   canvasColor: Colors.transparent,
        // bottomSheetTheme: BottomSheetThemeData(
        //     backgroundColor: Colors.black.withOpacity(0)),
        useMaterial3: true,
      ),
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        // '/': (context) => const Home(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/create_post': (context) => const CreatePost(),
        '/get_started': (context) => GetStarted(),
        '/view_post': (context) => const PostViewer(),
      },
      home: GetStarted(),
    );
  }
}
