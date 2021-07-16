import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:xzone/constants.dart';
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
        } else
          Navigator.pushNamedAndRemoveUntil(
              context, Neewsfeed.id, (route) => false);
        setState(() {
          _loading = false;
        });
        final newUser = await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
        HelpFunction.saveuserEmailsharedPrefrence(_email);
        getusername(_email);
        HelpFunction.saveusersharedPrefrenceUserLoggedInKey(true);
      } catch (e) {
        print(e);
        setState(() {
          _errorMsg = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
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
                                Navigator.pop(context);
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
