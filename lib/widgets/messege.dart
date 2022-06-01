import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http ;

class FCM{
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  // String? token="";


  void sendPushMessage(String body,String title)async{
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAAWBSCwas:APA91bGv6yDHbTCKY8KxfTtMBbXMgV5lUui3Bi7Z1cC_vEmjlZlRwS2bHWlnV1918v1E3yP70IcxA-bqJ8Zv2Jf-fGcXqWLlYaxEWBdLn3uy-zXBfEncHPxmD9I5ZIB5nS0Q7_O1IbeX',
        },
        body: jsonEncode(
          <String , dynamic>{
            'notification' : <String, dynamic>{
              'body':'You have Successfully logged into the system',
              'title': 'Welcome to the Genotechies(pvt) Ltd.'
            },
            'Priority': 'high',
            'data':<String, dynamic>{
              'click_action':'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status':'done'
            },
            "to": "/topics/Login",
          },
        ),
      );
    } catch(e){
      print("Error push notification");
    }
  }


  void requestPermission() async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(

      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus== AuthorizationStatus.authorized){
      print('User granted permission');
    }else if (settings.authorizationStatus == AuthorizationStatus.provisional){
      print ('user granted provisional permission');
    }else{
      print('User declined or has not accepted permission');
    }
  }


  void listenFCM()async{

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    });

  }




  void loadFCM() async{
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);


      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }
}