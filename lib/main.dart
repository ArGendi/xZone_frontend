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
import 'package:xzone/screens/project_screen.dart';
import 'package:xzone/screens/register_screen.dart';
import 'package:xzone/screens/tasks_screen.dart';
import 'package:xzone/screens/welcome_screen.dart';
import 'package:xzone/servcies/helperFunction.dart';
import 'package:xzone/widgets/add_task.dart';
import 'package:xzone/providers/zones_provider.dart';
import 'package:xzone/screens/Neewsfeed.dart';
import 'package:xzone/screens/chatroom.dart';
import 'package:firebase_core/firebase_core.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin
        = FlutterLocalNotificationsPlugin();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var androidInitialization = AndroidInitializationSettings('app_icon');
    var iOSInitialization = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(android: androidInitialization, iOS: iOSInitialization);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String payload) async{
        if(payload != null)
          debugPrint('notification payload: ' + payload);
      }
    );
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
        initialRoute: LoadingScreen.id,
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          WelcomeScreen.id: (context) => WelcomeScreen(),
          RegisterScreen.id: (context) => RegisterScreen(),
          Tasks.id: (context) => Tasks(),
          DaysList.id: (context) => DaysList(),
          ProjectScreen.id: (context) => ProjectScreen(),
          Neewsfeed.id: (contetx) => Neewsfeed(),
          ChatRoom.id: (context) => ChatRoom(),
          LoadingScreen.id: (context) => LoadingScreen(),

        },
      ),
    );
  }
}
