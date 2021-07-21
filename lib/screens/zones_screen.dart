import 'package:flutter/material.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/screens/infoZone.dart';
import 'package:xzone/screens/ZoneTest.dart';
import 'package:xzone/servcies/web_services.dart';
class zones_profile extends StatefulWidget {
  final bool checkMe ;
  final int userID;
  final List zones;
  const zones_profile({Key key, this.checkMe, this.userID, this.zones}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return zonesState_profile();
  }
}
class zonesState_profile extends State<zones_profile> {
  @override
  leaveZone(int userId,int zoneId)async{
    var webService = WebServices();
    var response = await webService.delete(
        'http://xzoneapi.azurewebsites.net/api/v1/ZoneMember', {
      "accountId": userId,
      "zoneId" : zoneId
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
              trailing: FlatButton(
                child: Text(widget.checkMe? "Join":"Leave",style: TextStyle(color: whiteColor,fontSize: 15),),
                onPressed: (){if(widget.checkMe){print("Send join zone Request");
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
              ),
              leading: CircleAvatar(child: Icon(Icons.add_task),backgroundColor: buttonColor,foregroundColor: backgroundColor,),
            );
          },
        ),
      ),
    );
  }
}