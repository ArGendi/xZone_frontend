import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/screens/infoZone.dart';
import 'package:xzone/screens/ZoneTest.dart';
import 'package:xzone/servcies/helperFunction.dart';
import 'package:xzone/servcies/web_services.dart';
class zones_profile extends StatefulWidget {
  final bool checkMe ;
  final int userID;
  final List zones;

  const zones_profile({Key key, this.checkMe, this.userID, this.zones,}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return zonesState_profile();
  }
}
class zonesState_profile extends State<zones_profile> {
  List zonesUserjoined=[];
  @override
  void initState() {
    getuserZones();

  }

  getuserZones() async {
    HelpFunction.getUserId().then((id) async {
      try {
        var response = await webService
            .get('http://xzoneapi.azurewebsites.net/api/v1/ZoneMember/$id');
        setState(() {
          zonesUserjoined =
              response.statusCode != 200 ? [] : jsonDecode(response.body);
        });
        print(zonesUserjoined);

      } catch (e) {
        print(e);
      }
    });
  }
  @override
  leaveZone(int userId,int zoneId)async{
    var webService = WebServices();
    var response = await webService.anotherDelete(
        'http://xzoneapi.azurewebsites.net/api/v1/ZoneMember',{
      "accountId": userId,
      "zoneId" : zoneId
    });
  }
  var webService = WebServices();
  bool pressed = false;
  Join(BuildContext context, userid, zoneid, joinCode) async {
    try {
      var response = await webService.post(
          'http://xzoneapi.azurewebsites.net/api/v1/ZoneMember/$joinCode', {
        "zoneId": zoneid,
        "accountId": userid,
      });
      print(response.statusCode);
      print(joinCode);
      if (response.statusCode != 200) {
        CreateErrorAlertDialog(
            context, true, "Sorry,You Canot Remove From here");
      } else {
        setState(() {
          pressed = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }
  Future<String> CreateErrorAlertDialog(
      BuildContext context, showErrorMessage, errorMessage) {
    TextEditingController codeEntry = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 0,
            backgroundColor: backgroundColor,
            title: Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              MaterialButton(
                  color: buttonColor,
                  elevation: 0,
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }
  Future<String> CreateAlertDialog(BuildContext context) {
    TextEditingController codeEntry = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 0,
            backgroundColor: backgroundColor,
            title: Text(
              "Zone's Code?",
              style: TextStyle(color: Colors.white),
            ),
            content: TextField(
              controller: codeEntry,
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              MaterialButton(
                  color: buttonColor,
                  elevation: 0,
                  child: Text("Submit"),
                  onPressed: () {
                    Navigator.of(context).pop(codeEntry.text.toString());
                  })
            ],
          );
        });
  }
  Widget build(BuildContext context) {
  //  final List<String> items = new List<String>.generate(10, (i) => "item  ${i + 1}");
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Zones",
      home: Scaffold(
        backgroundColor:Color(0xFF191720) ,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xFF191720),
          elevation: 0,
          title: Text('Zones',style: TextStyle(
            color:whiteColor,
            fontSize: 25,
          ),
          ),
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
            color: buttonColor,
          ),
        ),
        body:
        ListView.builder(
          itemCount:widget.zones.length,
          itemBuilder: (context, int index){
            return ListTile(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>infoZone(
                      idUser: widget.userID,
                      idZone: widget.zones[index]['zoneId'],
                    ),
                  ),
                );
              },
              title: Text("${widget.zones[index]['zone']['name']}",
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 20,
                ),
              ),
              trailing://widget.zones[index]['accountId']!=widget.userID?
              FlatButton(
                child: Text(!zonesUserjoined.contains(widget.zones[index]['zoneId'])? "Join":"Leave",style: TextStyle(color: whiteColor,fontSize: 15),),
                onPressed: (){if(widget.checkMe){
                  print( widget.zones[index]['zone']['privacy'].toString());
                  HelpFunction.getUserId().then((userId) {
                    widget.zones[index]['zone']['privacy'] == 1
                        ? Join(context, userId, widget.zones[index]['zoneId'], "0000")
                        : CreateAlertDialog(context).then((value) {
                      Join(context, userId, widget.zones[index]['zoneId'], value);
                    });
                  });
                }else{
                  leaveZone(widget.userID, widget.zones[index]['zoneId']);
                  setState(() {
                    widget.zones.removeAt(index);
                  });
                }},
                shape: RoundedRectangleBorder(side: BorderSide(
                  color:buttonColor,
                    width: 1,
                    style: BorderStyle.solid
                ), borderRadius: BorderRadius.circular(borderRadiusValue)),
              ),/*Card(
                color: backgroundColor,
                shape: RoundedRectangleBorder(side: BorderSide(
                    color:buttonColor,
                    width: 1,
                    style: BorderStyle.solid
                ), borderRadius: BorderRadius.circular(borderRadiusValue)),
                child:FlatButton(
                child: Text("Leave",style: TextStyle(color: whiteColor,fontSize: 15),),
                onPressed: (){
                leaveZone(widget.userID, widget.zones[index]['zoneId']);
                setState(() {
                widget.zones.removeAt(index);
                });
                },
              ),),*/
              leading: CircleAvatar(child: Icon(Icons.add_task),backgroundColor: buttonColor,foregroundColor: backgroundColor,),
            );
          },
        ),
      ),
    );
  }
}