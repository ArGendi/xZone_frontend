import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/models/task.dart';
import 'package:xzone/providers/tasks_provider.dart';
import 'package:xzone/screens/login_screen.dart';
import 'package:xzone/screens/register_screen.dart';
import 'package:xzone/screens/tasks_screen.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TasksProvider>(
          create: (context) => TasksProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'xZone',
        theme: ThemeData(
          fontFamily: 'Montserrat-Medium',
          scaffoldBackgroundColor: backgroundColor,
          appBarTheme: AppBarTheme(
            color: backgroundColor,
          )
        ),
        initialRoute: Tasks.id,
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          WelcomeScreen.id: (context) => WelcomeScreen(),
          RegisterScreen.id: (context) => RegisterScreen(),
          Tasks.id: (context) => Tasks(),
        },
      ),
    );
  }
}
