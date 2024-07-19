import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebasePushNotification {
  final _pushNotification = FirebaseMessaging.instance;

  Future<void> init() async {
    // Initialize Firebase
    await Firebase.initializeApp();

    final notificationSettings = await _pushNotification.requestPermission(
      provisional: true,
    );

    print(notificationSettings.authorizationStatus);
    final token = await _pushNotification.getToken();
    print(token);

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        print("Dasturda vaqtimiz keldi");
        print("XABAR: ${message.data}");
        if (message.notification != null) {
          print("Xabardagi Asosiy Ma'lumot: ${message.notification}");
        }
      },
    );
  }

  @pragma("vm:entry-point")
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    print("Orqa fonda xabar keldi: ${message.messageId}");
  }
}
