import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/screens/login_screen.dart';
import 'package:xzone/screens/register_screen.dart';
import 'package:xzone/widgets/login_card.dart';

class WelcomeScreen extends StatelessWidget {
  static final String id = 'welcome';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Welcome to ',
                        style: TextStyle(
                          fontSize: 26,
                          color: whiteColor,
                        ),
                      ),
                      Text(
                        'xZone',
                        style: TextStyle(
                          fontSize: 26,
                          fontFamily: 'Montserrat-Medium',
                          color: whiteColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Image.asset(
                    "assets/images/wel2.png",
                    width: 450 ,
                  ),
                  SizedBox(height: 60,),
                  LoginCard(
                    text: 'Continue with email',
                    textColor: whiteColor,
                    icon: Icon(
                      Icons.email,
                      color: whiteColor,
                    ),
                    color: buttonColor,
                    onClick: (){
                      Navigator.pushNamed(context, RegisterScreen.id);
                    },
                  ),
                  LoginCard(
                    text: 'Continue with google',
                    textColor: backgroundColor,
                    icon: Image.asset(
                      "assets/images/google_logo.png",
                      width: 22,
                    ),
                    color: whiteColor,
                  ),
                  LoginCard(
                    text: 'Continue with facebook',
                    textColor: backgroundColor,
                    icon: Image.asset(
                      "assets/images/facebook_logo.png",
                      width: 22,
                    ),
                    color: whiteColor,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
