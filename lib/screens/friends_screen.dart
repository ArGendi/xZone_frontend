import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:xzone/constants.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:xzone/servcies/helperFunction.dart';
import 'package:xzone/servcies/web_services.dart';

import 'infoProfile.dart';
class friends extends StatefulWidget {
  final bool checkMe;
  final List FriendList;
  final int userId;
  final int myId;
  const friends({Key key, this.checkMe, this.FriendList, this.userId, this.myId}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return friendsState();
  }
}
class friendsState extends State<friends> {
  List zonesUserjoined=[];
  List listOfIds=[];
  @override
  void initState() {
    getuserZones();
  }
  getuserZones() async {
    HelpFunction.getUserId().then((id) async {
      try {
        var webService = WebServices();
        var response = await webService
            .get('http://xzoneapi.azurewebsites.net/api/v1/Friend/$id');
        setState(() {
          zonesUserjoined =
              response.statusCode != 200 ? [] : jsonDecode(response.body);
        });
        zonesUserjoined.forEach((element) { 
          listOfIds.add(element['firstId']);
          listOfIds.add(element['secondId']);
        });
        listOfIds.removeWhere((item) => item == id,);
        print(id);
        print(listOfIds);
      } catch (e) {
        print(e);
      }
    });
  }
  @override
  unfriend(int firstUserId,int secondUserID)async{
    var webService = WebServices();
    var response = await webService.delete(
        'http://xzoneapi.azurewebsites.net/api/v1/Friend/$firstUserId/$secondUserID');
  }
  Addfriend(int firstUserId,int secondUserID)async{
    var webService = WebServices();
    var response = await webService.post(
        'http://xzoneapi.azurewebsites.net/api/v1/FriendRequest',{
      "senderId": firstUserId,
      "receiverId" : secondUserID
    });
    print(response.statusCode);
  }
  int basicUserId;
  getuserId(int secondUserID)async{
    basicUserId = await HelpFunction.getUserId();
    Addfriend(basicUserId, secondUserID);
  }
  
  List<int> sendRequest=[];
  
  Widget build(BuildContext context) {
    final List<String> items =
    new List<String>.generate(10, (i) => "item  ${i + 1}");
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Friends",
      home: Scaffold(
        backgroundColor:Color(0xFF191720) ,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xFF191720),
          elevation: 0,
          title: Text('Friends',style: TextStyle(
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
        body: ListView.builder(
            itemCount: widget.FriendList.length,
            itemBuilder: (context, int index){
            return InkWell(
              onTap: ()async{
                int id = await HelpFunction.getUserId();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => info(
                      userId: widget.FriendList[index]['id'],
                      checkMe: true,
                      myId: id,
                    ),),
                );
              },
              child: ListTile(
                title: Text(widget.FriendList[index]['userName'],
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 20,
                ),
                ),
                trailing:widget.FriendList[index]['id']!= widget.myId?
                FlatButton(
                child: Text(!listOfIds.contains(widget.FriendList[index]['id'])?(sendRequest.contains(index)?"Request Sent":"Add Friend"):"Unfriend",style: TextStyle(color: whiteColor,fontSize: 15),),
                onPressed: (){if(widget.checkMe){
                  setState(() {
                    sendRequest.add(index);
                  });
                  getuserId(widget.FriendList[index]['id']);
                }else{
                  unfriend(widget.userId, widget.FriendList[index]['id']);
                  setState(() {
                    widget.FriendList.removeAt(index);
                  });
                }},
                  shape: RoundedRectangleBorder(side: BorderSide(
                      color: buttonColor,
                      width: 1,
                      style: BorderStyle.solid
                  ), borderRadius: BorderRadius.circular(borderRadiusValue)),
                ):Card(),
                leading: CircleAvatar(child: Icon(Icons.person),backgroundColor: buttonColor, foregroundColor: backgroundColor,),
              ),
            );
       },
      ),),
    );
  }
}