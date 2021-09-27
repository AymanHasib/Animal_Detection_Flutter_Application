import 'package:blsd/camera_screen.dart';
import 'package:blsd/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(BLSDapp());
}

class BLSDapp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        // CameraScreen.id: (context) => CameraScreen(),
        // RegistrationScreen.id: (context) => RegistrationScreen(),
        // ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}
