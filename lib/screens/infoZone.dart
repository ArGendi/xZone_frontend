import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/helpers/db_helper.dart';
import 'package:xzone/servcies/web_services.dart';
import 'package:xzone/screens/profile.dart';

import 'ZoneTest.dart';

class infoZone extends StatefulWidget{
  static final String id = 'loading';
  final int idUser;
  final int idZone;

  const infoZone({Key key, this.idUser, this.idZone}) : super(key: key);


  @override
  infoZoneState createState() => infoZoneState();
}
class infoZoneState extends State<infoZone>{

  _getDataFromDb() async{
    try {
      var webService = WebServices();
      var webService1 = WebServices();
      int idUser = widget.idUser;
      int idZone = widget.idZone;

      var response = await webService.get(
          'http://xzoneapi.azurewebsites.net/api/v1/Zone/GetZone/$idZone');

      var body = json.decode(response.body);
      String zoneName = body['name'];
      String zoneDes = body['description'];
      List posts = body['posts'];


      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ZoneTest(
            posts: posts,
            zoneName: zoneName,
            zoneID: idZone ,
            userID: idUser,
          ),
        ),
      );

    } catch (e) {
      print(e);
      setState(() {
        // _errorMsg = e.toString();
      });
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDataFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
        ),
      ),
    );
  }

}