// ignore_for_file: avoid_print

import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("Title: ${message.notification?.title}");
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  @pragma('vm:entry-point')
  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    _firebaseMessaging.subscribeToTopic("all_devices");
    // final fCMToken = await _firebaseMessaging.getToken();
    // print(fCMToken);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
