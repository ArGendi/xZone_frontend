import 'dart:math';
import 'package:flutter/material.dart';
import 'package:xzone/constants.dart';

class ZoneWidget extends StatelessWidget {
  final String name;
  final String skill;
  final int numberOfmembers;
  final List admins;
  final int index = Random().nextInt(zonescolor.length);
  var styling = TextStyle(
      fontSize: 18, color: whiteColor, fontFamily: 'Montserrat-Light');

  ZoneWidget(
      {Key key, this.name, this.skill, this.numberOfmembers, this.admins})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                      fontSize: 20,
                      color: whiteColor,
                      fontFamily: 'Montserrat-Light'),
                ),
                Text(
                  skill,
                  style: TextStyle(
                      fontSize: 17,
                      color: whiteColor,
                      fontFamily: 'Montserrat-Light'),
                ),
                Text("${numberOfmembers} member",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        fontFamily: 'Montserrat-Light')),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    for (int i = 0; i < admins.length; i++)
                      CircleAvatar(
                        backgroundColor: Colors.black,
                      ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ],
            ),
            FlatButton(
                onPressed: null,
                child: Row(
                  children: [
                    Icon(
                      Icons.add,
                      color: Color(0xff000C40),
                    ),
                    Text("Join",
                        style: TextStyle(
                            color: Color(0xff000C40),
                            fontFamily: 'Montserrat-Light',
                            fontWeight: FontWeight.bold))
                  ],
                ))
          ],
        ),
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  zonescolor[index].firstColor,
                  zonescolor[index].secondColor,
                ]),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey, offset: Offset(0.0, 1.0), blurRadius: 3.0)
            ]),
      ),
    );
  }
}
