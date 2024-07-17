import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:imtihon_4_oy1/screens/splash_screen.dart';
import 'package:imtihon_4_oy1/services/event_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EventService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Firestore Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
