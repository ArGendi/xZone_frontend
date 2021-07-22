import 'package:flutter/material.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/screens/login_screen.dart';
import 'package:xzone/screens/tasks_screen.dart';
import 'package:xzone/servcies/web_services.dart';
import 'package:xzone/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xzone/repositories/FireBaseDB.dart';
import 'Neewsfeed.dart';
import 'package:xzone/servcies/helperFunction.dart';

class RegisterScreen extends StatefulWidget {
  static final String id = 'register';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String _fullName;
  bool _showErrorMsg = false;
  bool _loading = false;
  String _errorMsg = '';
  final _auth = FirebaseAuth.instance;
  final firebaseDB = FirestoreDatabase();
  _setFullName(String fullName) {
    _fullName = fullName;
  }

  _setEmail(String email) {
    _email = email;
  }

  _setPass(String password) {
    _password = password;
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
            'http://xzoneapi.azurewebsites.net/api/v1/authentication/register',
            {
              "userName": _fullName.trim(),
              "email": _email.trim(),
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
        final newUser = await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        await HelpFunction.saveuserNamesharedPrefrence(_fullName);
        await HelpFunction.saveuserEmailsharedPrefrence(_email);
        await HelpFunction.saveusersharedPrefrenceUserLoggedInKey(true);
        Map<String, String> mappedData = {"name": _fullName, "email": _email};
        firebaseDB.uploadUserInfo(mappedData);
      } catch (e) {
        print(e);
        setState(() {
          _errorMsg = 'Server Error, please try again later';
        });
      }
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
                    "Let's get started,",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                  Text(
                    "Create Account",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontFamily: "Montserrat-Medium"),
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
                          text: "Full Name",
                          obscureText: false,
                          textInputType: TextInputType.text,
                          setValue: _setFullName,
                          validation: (value) {
                            if (value.isEmpty) return 'Enter an full name';
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
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
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: !_loading
                                ? Text(
                                    "Register",
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
                              "Already have one?",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, LoginScreen.id);
                              },
                              child: Text(
                                " Login now",
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
