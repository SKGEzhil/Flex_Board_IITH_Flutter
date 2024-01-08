import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:lost_flutter/controllers/authentication_controller.dart';
import 'package:lost_flutter/controllers/global_binding.dart';
import 'package:lost_flutter/controllers/network_connectivity_controller.dart';
import 'package:lost_flutter/controllers/notification_controller.dart';
import 'package:lost_flutter/controllers/post_list_controller.dart';
import 'package:lost_flutter/controllers/replies_controller.dart';
import 'package:lost_flutter/globals.dart';
import 'package:lost_flutter/pages/create_post.dart';
import 'package:lost_flutter/firebase_options.dart';
import 'package:lost_flutter/pages/post_viewer.dart';
import 'package:lost_flutter/utils/server_utils.dart';
import 'pages/get_started.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

/// Getting Firebase Messaging Instance
FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

/// Callback for Notification Click
Future<void> onNotificationClick(message, notificationType) async {
  final NotificationController notificationController = Get.put(NotificationController());
  final RepliesController repliesController = Get.put(RepliesController());
  final PostListController postListController = Get.put(PostListController());
  final Map<String, dynamic>? data = message?.data;
  final postId = data?['post_id'];
  final type = data?['type'];
  final post = await postListController.notificationHandler(postId, type);
  if(notificationType == 'get_init') {
    print('GET INIT ${message?.data}');
    print('TYPE: $notificationType');
    notificationController.isNotification.value = true;
    notificationController.post = post;
    repliesController.isOpened.value = true;
  } else {
    print('TYPE: $notificationType');
    Get.to(PostViewer(post: post));
  }
}

/// Firebase initialization
Future<void> initializations() async {

  // Firebase initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMessaging.instance.requestPermission();

  print("HELLO WORLD");

  // onMessage: When the app is open and it receives a push notification
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    // TODO: Handle foreground messages
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

    // Getting the FCM token
    final token = await FirebaseMessaging.instance.getToken();
    fcmToken = token!;
    print(token);


}

/// Callback for handling background messages
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


void main() async {

  // Ensuring the initialization of WidgetsBinding
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Initializing Flutter Native Splash
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  HttpOverrides.global = MyHttpOverrides();

  final NetworkController networkController = Get.put(NetworkController());

  // Checking for network connectivity and initializing the app
  if(await ServerUtils().isConnected()){
    isConnected = true;
    await initializations();
  }

  // Enabling Firebase Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Initializing Firebase Messaging for iOS (Not functional)
  if (Platform.isIOS) {
    String? apnsToken = await _firebaseMessaging.getAPNSToken();
    if (apnsToken != null) {
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

  // Initializing the Authentication Controller
  final AuthenticationController authenticationController = Get.put(AuthenticationController());
  await authenticationController.initialization();

  // Removing the splash screen
  FlutterNativeSplash.remove();

  GestureBinding.instance.resamplingEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key,});

  final AuthenticationController authenticationController = Get.put(AuthenticationController());

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
        '/get_started': (context) => const GetStarted(),
      },
      home: authenticationController.initialPage()
    );
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
