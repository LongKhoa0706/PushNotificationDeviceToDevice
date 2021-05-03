import 'dart:io';
import 'dart:math';

import 'package:device_info/device_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:push_notification/testnoti.dart';


//Create a service that communicates with the Firebase messaging plugin.

class PushNotificationService {
  final FirebaseMessaging firebaseMessaging;
  final BuildContext ctx;
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  PushNotificationService(this.firebaseMessaging,this.ctx);

  Future initial() async {
    if (Platform.isIOS) {
      firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(sound: true,alert: true,badge: true,provisional: false));
    }

    String token = await firebaseMessaging.getToken();
    print('FIREBASEMESSAGE token: $token');

    // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    Random random = Random();
    firebaseDatabase.reference().child("UserDeviceToken").push().set({
      'create_at':DateTime.now().toString(),
      'tokent':token,
      'id': random.nextInt(2),
    });


    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        if (Platform.isAndroid) {
          PushNotificationMessage pushNotificationMessage = PushNotificationMessage(
            title: message['notification']['title'],
            body: message['notification']['body'],
          );
          // showToast.displayToast(pushNotificationMessage.body, Colors.red);
        }
        print('on message:  $message ');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        print('ON onLaunch NE');
        // serilizeAndNavigate(message, this.ctx);
      },
      onResume: (Map<String, dynamic> message)async {
        print("onResume: $message");
        print('ON RESUM NE');
        // serilizeAndNavigate(message, this.ctx);
      },
    );
  }
}

void serilizeAndNavigate(Map<String, dynamic> message,BuildContext context){
  var notification = message['data'];
  var view = notification['view'];
  if (view != null) {
    if (view == 'listData') {
      // Navigator.push(context, MaterialPageRoute(builder: (_)=>SplashScreen()));
    }
  }
}

