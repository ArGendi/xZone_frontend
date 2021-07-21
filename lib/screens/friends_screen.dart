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
  const friends({Key key, this.checkMe, this.FriendList, this.userId}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return friendsState();
  }
}
class friendsState extends State<friends> {
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
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => info(
                      userId: widget.FriendList[index]['id'],
                      checkMe: true,
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
                trailing:FlatButton(
                child: Text(widget.checkMe?"Add Friend":"Unfriend",style: TextStyle(color: whiteColor,fontSize: 15),),
                onPressed: (){if(widget.checkMe){
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
                ),
                leading: CircleAvatar(child: Icon(Icons.person),backgroundColor: buttonColor, foregroundColor: backgroundColor,),
              ),
            );
       },
      ),),
    );
  }
}