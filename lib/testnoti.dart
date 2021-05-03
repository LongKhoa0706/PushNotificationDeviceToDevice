import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:push_notification/pushnotificationservice.dart';

class Testnoti extends StatefulWidget {
  @override
  _TestnotiState createState() => _TestnotiState();
}

class _TestnotiState extends State<Testnoti> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final textController = TextEditingController();

  List listKey = [];

  String userId;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            TextFormField(
              controller: textController,
            ),
            RaisedButton(
              onPressed: () {
                // đăng ký topic trên fcm
                final pushNotification = PushNotificationService(firebaseMessaging, context);
                pushNotification.initial();
              },
              child: Text("DANG KY TOKEN "),
            ),
            RaisedButton(
              onPressed: () async {

                final pushNotification = PushNotificationService(firebaseMessaging, context);

                pushNotification.firebaseDatabase
                    .reference()
                    .child("Notification")
                    .push()
                    .set({
                  'create_at': DateTime.now().toString(),
                  'idUser': userId,
                  'name': textController.text,
                });
              },
              child: Text("GUI"),
            ),
            RaisedButton(
              onPressed: () {
                final pushNotification =
                    PushNotificationService(firebaseMessaging, context);
                pushNotification.firebaseMessaging
                    .unsubscribeFromTopic('push_notification');
              },
              child: Text("huy dang ky"),
            ),
            RaisedButton(
              onPressed: () async {
                final pushNotification =
                    PushNotificationService(firebaseMessaging, context);
                var data = await pushNotification.firebaseDatabase
                    .reference()
                    .child("UserDeviceToken")
                    .once();
                Map<dynamic, dynamic> mapData = data.value;

                listKey.clear();

                for (String a in mapData.keys) {
                  listKey.add(a);
                }
                setState(() {});
              },
              child: Text("Lay tất cả Tokent"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: listKey.length,
                itemBuilder: (_, index) {
                  String ab = listKey[index];
                  return InkWell(
                      onTap: () {
                        userId = ab;
                      },
                      child: Text(
                        ab,
                        style: TextStyle(fontSize: 20),
                      ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PushNotificationMessage {
  final String title;
  final String body;

  PushNotificationMessage({
    @required this.title,
    @required this.body,
  });
}
