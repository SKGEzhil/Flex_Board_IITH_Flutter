import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:lost_flutter/controllers/global_binding.dart';
import 'package:lost_flutter/controllers/notification_controller.dart';
import 'package:lost_flutter/controllers/post_list_controller.dart';
import 'package:lost_flutter/controllers/profile_controller.dart';
import 'package:lost_flutter/controllers/replies_controller.dart';
import 'package:lost_flutter/globals.dart';
import 'package:lost_flutter/page_builder.dart';
import 'package:lost_flutter/pages/create_post.dart';
import 'package:lost_flutter/firebase_options.dart';
import 'package:lost_flutter/pages/post_viewer.dart';
import 'package:lost_flutter/utils/server_utils.dart';
import 'package:lost_flutter/utils/shared_prefs.dart';
import 'pages/get_started.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

Future<void> onNotificationClick(message, notification_type) async {
  final NotificationController notificationController = Get.put(NotificationController());
  final RepliesController repliesController = Get.put(RepliesController());
  final PostListController postListController = Get.put(PostListController());
  final Map<String, dynamic>? data = message?.data;
  final postId = data?['post_id'];
  final type = data?['type'];
  final post = await postListController.notificationHandler(postId, type);
  if(notification_type == 'get_init') {
    print('GET INIT ${message?.data}');
    print('TYPE: $notification_type');
    notificationController.isNotification.value = true;
    notificationController.post = post;
    repliesController.isOpened.value = true;
  } else {
    print('TYPE: $notification_type');
    Get.to(PostViewer(post: post));
  }
}

Future<void> initializations() async {
  // Firebase initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final notificationSettings =
      await FirebaseMessaging.instance.requestPermission();

  print("HELLO WORLD");
  isConnected = true;
  // onMessage: When the app is open and it receives a push notification
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    // await onNotificationClick(message, 'on_message');
  });

  // replacement for onResume: When the app is in the background and opened directly from the push notification.
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    await onNotificationClick(message, 'omoa');
  });

  // Firebase message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.instance.subscribeToTopic("topic");
  FirebaseMessaging.instance
      .getInitialMessage()
      .then((message) async {
      await onNotificationClick(message, 'get_init');
  });

  final token = await FirebaseMessaging.instance.getToken();
  fcmToken = token!;
  print(token);

}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("SKGEzhil Notification");
  final PostListController postListController = Get.put(PostListController());
  final Map<String, dynamic> data = message.data;
  final postId = data['post_id'];
  final type = data['type'];
  final post = await postListController.notificationHandler(postId, type);
  print('Name :${post.name}');
  print('FIREBASE BG HANDLER ${message.data}');
}

Future<int> userInit() async {
  int number = await SharedPrefs().checkFirstLaunch();
  print(number);
  if (number == 0) {
    final roll_no = await SharedPrefs().getRollNo();
    final username = await SharedPrefs().getUsername();
    final token = await SharedPrefs().getAuthToken();
    print('token = $token');
    int isAuthSuccess =
        await ServerUtils().loginWithToken(token, roll_no, username);
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
  // if(Platform.isAndroid){
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // }
  // if (Platform.isIOS) {
  //   FlutterNativeSplash.remove();
  // }

  await initializations();

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  if (Platform.isIOS) {
    String? apnsToken = await _firebaseMessaging.getAPNSToken();
    if (apnsToken != null) {
      // await _firebaseMessaging.subscribeToTopic("notificationChannel");
      try {
        await _firebaseMessaging.subscribeToTopic('topic');
      } on FirebaseException catch (e) {
        debugPrint("George here is the error: $e");
      }
    } else {
      await Future<void>.delayed(const Duration(seconds: 3));
      apnsToken = await _firebaseMessaging.getAPNSToken();
      if (apnsToken != null) {
        try {
          await _firebaseMessaging.subscribeToTopic('topic');
        } on FirebaseException catch (e) {
          debugPrint("George here is the error: $e");
        }
      }
    }
  } else {
    try {
      await _firebaseMessaging.subscribeToTopic('topic');
    } on FirebaseException catch (e) {
      debugPrint("George here is the error: $e");
    }
  }

  isConnected = true;
  isUserLoggedIn = await userInit();
  FlutterNativeSplash.remove();
  if (await SharedPrefs().checkFirstLaunch() == 0) {
    isUserLoggedIn = 1;
    roll_no_ = await SharedPrefs().getRollNo();
    username = await SharedPrefs().getUsername();
  } else {
    isUserLoggedIn = 0;
  }
  FlutterNativeSplash.remove();

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
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
      ],

      initialBinding: GlobalBindings(),

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),

        useMaterial3: true,
      ),

      routes: {
        '/create_post': (context) => const CreatePost(),
        '/get_started': (context) => GetStarted(),
      },
      home: _getScreenId(),
    );
  }
}
