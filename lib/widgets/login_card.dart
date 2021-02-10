import 'package:flutter/material.dart';
import 'package:xzone/constants.dart';

class LoginCard extends StatelessWidget {
  final String text;
  final Widget icon;
  final Color color;
  final Color textColor;
  final Function onClick;

  const LoginCard({Key key, this.text, this.icon, this.color, this.textColor, this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Card(
        elevation: 0,
        color: color,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Row(
            children: <Widget>[
              icon,
              SizedBox(width: 20,),
              Text(
                text,
                style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontFamily: 'Montserrat-Medium'
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
