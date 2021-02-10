import 'package:flutter/material.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/screens/login_screen.dart';
import 'package:xzone/screens/register_screen.dart';
import 'package:xzone/screens/welcome_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'xZone',
      theme: ThemeData(
        fontFamily: 'Montserrat-Light',
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: AppBarTheme(
          color: backgroundColor,
        )
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
      },
    );
  }
}
