import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:note_app_fireb/constants/constants.dart';
import 'package:note_app_fireb/screens/add_note_screen.dart';
import 'package:note_app_fireb/screens/home_screen.dart';
import 'package:note_app_fireb/screens/sign_in_screen.dart';

Future notificationBack(RemoteMessage message) async {
  
  print("${message.senderId}");
  print("From background message **********************");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(notificationBack);
  var user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    isLogin = true;
  } else {
    isLogin = false;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isLogin! ? HomeScreen() : LoginScreen(),
    );
  }
}
