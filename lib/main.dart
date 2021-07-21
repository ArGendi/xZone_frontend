import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/models/task.dart';
import 'package:xzone/providers/projects_provider.dart';
import 'package:xzone/providers/tasks_provider.dart';
import 'package:xzone/screens/days_list.dart';
import 'package:xzone/screens/loading_screen.dart';
import 'package:xzone/screens/login_screen.dart';
import 'package:xzone/screens/profile.dart';
import 'package:xzone/screens/project_screen.dart';
import 'package:xzone/screens/register_screen.dart';
import 'package:xzone/screens/tasks_screen.dart';
import 'package:xzone/screens/welcome_screen.dart';
import 'package:xzone/providers/zones_provider.dart';
import 'package:xzone/screens/Neewsfeed.dart';
import 'package:xzone/screens/chatroom.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:xzone/screens/skills.dart';
import 'package:xzone/servcies/helperFunction.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var email;
  var username;

  username = await HelpFunction.getuserNamesharedPrefrence();
  email = await HelpFunction.getuserEmailsharedPrefrence();
  // print(email);
  runApp(MyApp(email: email, username: username));
}

class MyApp extends StatefulWidget {
  @override
  final email;
  final username;

  const MyApp({this.email, this.username});
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState() {
    // TODO: implement initState

    var androidInitialization = AndroidInitializationSettings('app_icon');
    var iOSInitialization = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: androidInitialization, iOS: iOSInitialization);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) debugPrint('notification payload: ' + payload);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TasksProvider>(
          create: (context) => TasksProvider(),
        ),
        ChangeNotifierProvider<ProjectsProvider>(
          create: (context) => ProjectsProvider(),
        ),
        ChangeNotifierProvider<ZoneProvider>(
          create: (context) => ZoneProvider(),
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
            )),

        ///IsLoggedIn ? Neewsfeed.id : RegisterScreen.id,
        initialRoute: widget.email == null ? RegisterScreen.id : Neewsfeed.id,
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          WelcomeScreen.id: (context) => WelcomeScreen(),
          RegisterScreen.id: (context) => RegisterScreen(),
          Tasks.id: (context) => Tasks(),
          DaysList.id: (context) => DaysList(),
          ProjectScreen.id: (context) => ProjectScreen(),
          Neewsfeed.id: (context) => Neewsfeed(
                email: widget.email == null ? "" : widget.email,
                username: widget.username == null ? "" : widget.username,
              ),
          ChatRoom.id: (context) => ChatRoom(),
          Skills.id: (context) => Skills(),
          LoadingScreen.id: (context) => LoadingScreen(),
          profile.id: (context) => profile(),
        },
      ),
    );
  }
}
