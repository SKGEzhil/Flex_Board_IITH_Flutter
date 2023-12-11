import 'package:firebase_messaging/firebase_messaging.dart';


// Firebase notifications
class FirebaseUtils{
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final FCM_token = await _firebaseMessaging.getToken();
    print("FCM Token: $FCM_token");
  }
  static Future<void> onBackgroundMessage(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
    // You can handle the message here
  }
}