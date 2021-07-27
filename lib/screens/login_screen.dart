import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/helpers/db_helper.dart';
import 'package:xzone/models/project.dart';
import 'package:xzone/models/section.dart';
import 'package:xzone/models/task.dart';
import 'package:xzone/providers/projects_provider.dart';
import 'package:xzone/providers/tasks_provider.dart';
import 'package:xzone/providers/zone_tasks_provider.dart';
import 'package:xzone/screens/register_screen.dart';
import 'package:xzone/screens/tasks_screen.dart';
import 'package:xzone/screens/welcome_screen.dart';
import 'package:xzone/servcies/web_services.dart';
import 'package:xzone/widgets/custom_textfield.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'Neewsfeed.dart';
import 'package:xzone/servcies/helperFunction.dart';
import 'package:xzone/repositories/FireBaseDB.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static final String id = 'login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final firebaseDB = FirestoreDatabase();
  String _email;
  String _password;
  bool _showErrorMsg = false;
  bool _loading = false;
  String _errorMsg = '';
  final _auth = FirebaseAuth.instance;
  DBHelper _dbHelper = new DBHelper();

  _setEmail(String email) {
    _email = email;
  }

  _setPass(String password) {
    _password = password;
  }

  List Temp;
  getusername(String email) async {
    Temp = await firebaseDB.getUserByemail(email);
    String myusername = Temp[0]["name"];
    print(myusername);
    HelpFunction.saveuserNamesharedPrefrence(myusername);
    return myusername;
  }

  _trySubmit() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      var webService = WebServices();
      setState(() {
        _loading = true;
      });
      try {
        var response = await webService.post(
            'http://xzoneapi.azurewebsites.net/api/v1/authentication/login', {
          "email": _email,
          "password": _password,
        });
        if (response.statusCode >= 400) {
          setState(() {
            _showErrorMsg = true;
            _errorMsg = response.body;
          });
        } else {
          List x = [];
          _dbHelper.deleteAllRows(tasksTable);
          _dbHelper.deleteAllRows(sectionsTable);
          _dbHelper.deleteAllRows(projectsTable);
          Provider.of<TasksProvider>(context, listen: false).clearProviderItems();
          Provider.of<ProjectsProvider>(context, listen: false).clearProviderItems();
          Provider.of<ZoneTasksProvider>(context, listen: false).clearProviderItems();
          var body = json.decode(response.body);
          int id = body['id'];
          List tasks = body['tasks'];
          List projects = body['projects'];
          List zoneTasks = body['zoneTasks'];
          _fetchAndSetTasks(tasks);
          _fetchAndSetZoneTasks(zoneTasks);
          _fetchAndSetProjects(projects);
          HelpFunction.saveUserId(id);
          final newUser = await _auth.signInWithEmailAndPassword(
              email: _email, password: _password);
          HelpFunction.saveuserEmailsharedPrefrence(_email);
          HelpFunction.saveuserNamesharedPrefrence(body['userName']);
          getusername(_email).then((value) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Neewsfeed(email: _email, username: value,register: false,)),
                (route) => false);
          });
        }
        setState(() {
          _loading = false;
        });
      } catch (e) {
        print(e);
        setState(() {
          _errorMsg = e.toString();
        });
      }
    }
  }

  _fetchAndSetTasks(List tasks){
    int counter = 1;
    for(var item in tasks){
      if(item['completeDate'] != null) continue;
      Task task = new Task();
      task.id = item['id'];
      task.userId = item['userId'];
      task.name = item['name'];
      task.priority = item['priority'];
      task.parentId = item['parentID'];
      if(item['dueDate'] != null) task.dueDate = DateTime.parse(item['dueDate']);
      else task.dueDate = null;
      if(item['remainder'] != null) task.remainder = DateTime.parse(item['remainder']);
      else task.remainder = null;
      if(item['completeDate'] != null) task.completeDate = DateTime.parse(item['completeDate']);
      else task.completeDate = null;
      print('task name: ' + task.name);
      Provider.of<TasksProvider>(context, listen: false).addTask(task, false);
      print(counter);
      counter+=1;
    }
  }

  _fetchAndSetZoneTasks(tasks){
    for(var item in tasks){
      if(item['completeDate'] != null) continue;
      Task task = new Task();
      task.id = item['zoneTaskID'];
      task.userId = item['accountID'];
      task.name = item['zoneTask']['name'];
      task.priority = item['zoneTask']['priority'] == null ? 100 : item['zoneTask']['priority'];
      task.parentId = item['zoneTask']['parentID'];
      if(item['zoneTask']['dueDate'] != null) task.dueDate = DateTime.parse(item['zoneTask']['dueDate']);
      else task.dueDate = null;
      if(item['zoneTask']['remainder'] != null) task.remainder = DateTime.parse(item['zoneTask']['remainder']);
      else task.remainder = null;
      if(item['completeDate'] != null) task.completeDate = DateTime.parse(item['completeDate']);
      else task.completeDate = null;
      task.projectId = item['zoneTask']['zoneId'] * -1;
      print('zone task name: ' + task.name);
      Provider.of<TasksProvider>(context, listen: false).addTask(task, false);
    }
  }

  _fetchAndSetProjects(List projects) {
    int pCounter = 0;
    for (var item in projects) {
      Project project = new Project(item['name']);
      project.id = item['id'];
      project.userID = 0;
      print('project name: ' + project.name);
      Provider.of<ProjectsProvider>(context, listen: false)
          .addProject(project, false);
      List sections = item['sections'];
      int sCounter = 0;
      for (var sectionItem in sections) {
        Section section = new Section(sectionItem['name']);
        section.id = sectionItem['id'];
        section.parentProjectID = sectionItem['parentProjectID'];
        Provider.of<ProjectsProvider>(context, listen: false)
            .addSection(pCounter, section, false);
        List tasks = sectionItem['projectTasks'];
        for(var taskItem in tasks){
          if(item['completeDate'] != null) continue;
          Task task = new Task();
          task.id = taskItem['id'];
          task.name = taskItem['name'];
          task.priority = taskItem['priority'];
          task.parentId = taskItem['parentID'];
          if (taskItem['dueDate'] != null)
            task.dueDate = DateTime.parse(taskItem['dueDate']);
          else
            task.dueDate = null;
          if (taskItem['remainder'] != null)
            task.remainder = DateTime.parse(taskItem['remainder']);
          else
            task.remainder = null;
          if (taskItem['completeDate'] != null)
            task.completeDate = DateTime.parse(taskItem['completeDate']);
          else
            task.completeDate = null;
          task.projectId = project.id;
          task.sectionId = section.id;
          Provider.of<ProjectsProvider>(context, listen: false).addTaskToSection(pCounter, sCounter, task, false);
        }
        sCounter += 1;
      }
      pCounter += 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Center(
            child: SingleChildScrollView(
              //physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: <Widget>[
                  Text(
                    "Welcome back",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                  Text(
                    "You have been missed!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                  Text(
                    "Login now",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontFamily: 'Montserrat-Medium'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    _errorMsg,
                    style: TextStyle(
                        color: _showErrorMsg ? Colors.red : backgroundColor),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        CustomTextField(
                          text: "Email",
                          obscureText: false,
                          textInputType: TextInputType.emailAddress,
                          setValue: _setEmail,
                          validation: (value) {
                            if (value.isEmpty) return 'Enter an email address';
                            if (!value.contains('@') || !value.contains('.'))
                              return 'Invalid email format';
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        CustomTextField(
                          text: "Password",
                          obscureText: true,
                          textInputType: TextInputType.text,
                          setValue: _setPass,
                          validation: (value) {
                            if (value.isEmpty) return 'Enter a password';
                            if (value.length < 6) return 'Short password';
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          child: Text(
                            "forget password",
                            style: TextStyle(
                              color: buttonColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: _trySubmit,
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                              color: buttonColor,
                              borderRadius:
                                  BorderRadius.circular(borderRadiusValue),
                            ),
                            child: !_loading
                                ? Text(
                                    "Login",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontFamily: "Montserrat-Medium"),
                                  )
                                : CircularProgressIndicator(
                                    strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        whiteColor),
                                  ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, RegisterScreen.id);
                              },
                              child: Text(
                                " Register now",
                                style: TextStyle(
                                  color: buttonColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
