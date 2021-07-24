import 'dart:math';
import 'package:flutter/material.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/servcies/helperFunction.dart';
import 'package:xzone/servcies/web_services.dart';

class ZoneWidget extends StatefulWidget {
  final String name;
  final String description;
  final int numberOfmembers;
  final zoneId;
  final alreadyfound;
  ZoneWidget(
      {Key key,
      this.name,
      this.description,
      this.numberOfmembers,
      this.zoneId,
      this.alreadyfound})
      : super(key: key);
  @override
  _ZoneWidgetState createState() => _ZoneWidgetState();
}

class _ZoneWidgetState extends State<ZoneWidget> {
  static var tempcolor = 0;
  var webService = WebServices();
  int index;
  bool pressed = false;

  var styling = TextStyle(
      fontSize: 18, color: whiteColor, fontFamily: 'Montserrat-Light');
  Join(userid, zoneid, joinCode) async {
    try {
      var response = await webService
          .post('http://xzoneapi.azurewebsites.net/api/v1/ZoneMember/0000', {
        "zoneId": zoneid,
        "accountId": userid,
      });
      print(response.statusCode);
      if (response.statusCode == 200) {
        setState(() {
          pressed = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  getindex() {
    index = Random().nextInt(zonescolor.length);
    while (tempcolor == index) {
      index = Random().nextInt(zonescolor.length);
    }
    tempcolor = index;
  }

  @override
  void initState() {
    getindex();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.alreadyfound
        ? Container()
        : Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                              //fontFamily: 'Montserrat-Light'
                              ),
                        ),
                        Text(
                          widget.description,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text("${widget.numberOfmembers} member",
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ),
                  FlatButton(
                      onPressed: () {
                        HelpFunction.getUserId().then((userId) {
                          Join(userId, widget.zoneId, "0000");
                        });
                      },
                      child: Row(
                        children: [
                          Icon(
                            pressed ? Icons.check : Icons.add,
                            color: buttonColor,
                          ),
                          Text(pressed ? "joined" : "join",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: buttonColor,
                              ))
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
                  /*  image: DecorationImage(
                      image: AssetImage("assets/images/image1.png"),
                      fit: BoxFit.fill),*/
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0),
                        blurRadius: 3.0)
                  ]),
            ),
          );
  }
}
