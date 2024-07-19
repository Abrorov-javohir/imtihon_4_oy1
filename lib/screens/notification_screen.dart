import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<RemoteMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _initializeFirebaseMessaging();
  }

  void _initializeFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        _messages.add(message);
      });
    });

    // Optionally handle background messages
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle the message when the app is opened from a terminated state.
      setState(() {
        _messages.add(message);
      });
    });

    // Request permission for iOS devices
    FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Check for initial message
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        setState(() {
          _messages.add(message);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final message = _messages[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: message.notification?.android?.imageUrl != null
                  ? NetworkImage(message.notification?.android?.imageUrl ?? '')
                  : null,
              child: message.notification?.android?.imageUrl == null
                  ? Icon(Icons.notification_important)
                  : null,
            ),
            title: Text(message.notification?.title ?? 'No Title'),
            subtitle: Text(message.notification?.body ?? 'No Body'),
          );
        },
      ),
    );
  }
}
