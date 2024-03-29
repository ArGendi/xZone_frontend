import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/helpers/db_helper.dart';
import 'package:xzone/providers/zone_tasks_provider.dart';
import 'package:xzone/servcies/web_services.dart';
import 'package:xzone/screens/profile.dart';
import 'package:provider/provider.dart';
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
      String zoneName = body['name'] == null ? '' : body['name'];
      String zoneDes = body['description'] == null ? '' : body['description'];
      List posts = body['posts'] == null ? [] : body['posts'];
      List zoneMembers = body['zoneMembers'] == null ? [] : body['zoneMembers'];
      print(zoneMembers);
      int privacy = body['privacy'] == null ? 1 : body['privacy'];
      List tasks = body['tasks'];
      Provider.of<ZoneTasksProvider>(context, listen: false).addListOfTasks(tasks);
      zoneMembers.sort((a, b) => b['numOfCompletedTasks'].compareTo(a['numOfCompletedTasks']));
      bool userInZone=false;
      for(int i=0;i<zoneMembers.length;i++){
        if(idUser == zoneMembers[i]['accountId'])
          {
            userInZone = true;
          }
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ZoneTest(
            posts: posts,
            zoneName: zoneName,
            zoneID: idZone ,
            userID: idUser,
            zoneMembers: zoneMembers ,
            privacy: privacy,
            userInZone: userInZone,
            tasks: tasks,
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