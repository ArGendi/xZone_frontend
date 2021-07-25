import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/servcies/helperFunction.dart';
import 'package:xzone/servcies/web_services.dart';
import 'package:xzone/widgets/add_task.dart';
import 'package:intl/intl.dart';

import 'commentScreen.dart';
import 'infoComments.dart';
class ZoneTest extends StatefulWidget {
  @override
  final List posts;
  final String zoneName;
  final int zoneID;
  final int userID;
  final List zoneMembers;
  final int privacy;
  final bool userInZone;
  final List tasks;
  //final String userName;

  const ZoneTest({Key key, this.posts, this.zoneName, this.zoneID, this.userID, this.zoneMembers, this.privacy, this.userInZone, this.tasks}) : super(key: key);
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ZoneStateTest();
  }
}
class ZoneStateTest extends State<ZoneTest>{
  int realIndex;
  var textfieldController = TextEditingController();

  addPostInZone(String content,int writerId,int zoneId)async {
    var webService = WebServices();
    var response = await webService.post(
        'http://xzoneapi.azurewebsites.net/api/v1/post/writepost', {
      "content": content,
      "writerId": writerId,
      "zoneId": zoneId
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF191720),
        appBar: AppBar(
          backgroundColor: Color(0xFF191720),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
            color: buttonColor,
          ),

          title:  Center(child: Text(widget.zoneName,style: TextStyle(color: whiteColor, fontSize: 25),)),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
          children: [
          SizedBox(width: 5,),

          Icon(widget.privacy==1? Icons.lock_open_sharp:Icons.lock,color: buttonColor,size: 15,),
          SizedBox(width: 5,),
          Text(
            widget.privacy==1?"Public Zone":"Private Zone",
            style: TextStyle(color: whiteColor, fontSize: 15),
          ),
          SizedBox(width: 5,),
          Text(
            widget.zoneMembers.length.toString(),
            style: TextStyle(color: buttonColor, fontSize: 15),
          ),
          SizedBox(width: 5,),
          Text(
            "members",
            style: TextStyle(color: whiteColor, fontSize: 15),
          ),
          ],
        ),
        ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                children: [
                  if(!widget.userInZone)
                    HelpFunction.getUserId()==widget.userID?
                  Expanded(
                    child: FlatButton(
                      child: Row(
                        children: [
                          SizedBox(width: 50,),
                          Icon(Icons.people_alt_rounded , color:buttonColor ,),
                          SizedBox(width: 50,),
                          Text(
                            "Join" ,
                            style: TextStyle(color: whiteColor, fontSize: 15),
                          ),
                        ],
                      ),
                      onPressed: () {},
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: buttonColor,
                              width: 2,
                              style: BorderStyle.solid),
                          borderRadius:
                          BorderRadius.circular(borderRadiusValue)),
                    ),
                  ):Card(),
                  SizedBox(width: 10,),
                ],
              ),
            ),
            Expanded(
              child: DefaultTabController(length: 3,
              initialIndex: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        child: TabBar(
                          labelColor: buttonColor,
                          unselectedLabelColor: whiteColor,
                          tabs: [
                            Tab(text: 'Posts'),
                            Tab(text: 'Tasks'),
                            Tab(text: 'Leaderboard'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          //height: 400,
                          child: TabBarView(children: <Widget>[
                            ListView(
                              shrinkWrap: true,
                              children: [
                                Container(
                                  child: Column(
                                    children: [
                                      Card(
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: greyColor,
                                              width: 2,
                                              style: BorderStyle.solid),
                                          borderRadius:
                                          BorderRadius.circular(borderRadiusValue),),
                                        color: backgroundColor ,
                                        child: Stack(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 10.0),
                                              child:TextField(
                                                cursorColor: Colors.white,
                                                controller: textfieldController,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.all(20),
                                                  fillColor: backgroundColor,
                                                  hintText: 'Write Post....',
                                                  hintStyle: TextStyle(
                                                    color: greyColor,
                                                  ),
                                                  focusedBorder: InputBorder.none,
                                                  enabledBorder: InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                                Positioned(
                                                  right: 10,
                                                  bottom: 10,
                                                  child: IconButton(
                                                    iconSize: 28,
                                                    icon:Icon( Icons.add_circle , color:buttonColor ,),
                                                  onPressed: ()async{
                                                      String userName =  await HelpFunction.getuserNamesharedPrefrence();
                                                      setState(() {
                                                        widget.posts.add({
                                                          "content": textfieldController.text,
                                                          "writerId": widget.userID,
                                                          "zoneId": widget.zoneID,
                                                          "date": DateTime.now().toString(),
                                                          "writer":{
                                                            "userName": userName,
                                                          }
                                                        });
                                                      });
                                                    addPostInZone(textfieldController.text,widget.userID,widget.zoneID);
                                                    textfieldController.clear();
                                                    //print(textfieldController.text);
                                                  },
                                                  ),
                                                ),
                                              ],
                                            ),
                                      ),
                                      Container(
                                        child: ListView.builder(
                                          reverse: true,
                                          shrinkWrap: true,
                                          physics: ScrollPhysics(),
                                          itemCount: widget.posts.length,
                                          itemBuilder: (BuildContext context,int index){
                                            String date = widget.posts[index]['date'];
                                            DateTime dt = DateTime.parse("$date");
                                            return Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: greyColor,
                                                    width: 2,
                                                    style: BorderStyle.solid),
                                                borderRadius:
                                                BorderRadius.circular(borderRadiusValue),),
                                              color: backgroundColor ,
                                              child: Container(
                                                padding: EdgeInsets.all(16.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(Icons.person,color: buttonColor,),
                                                        SizedBox(width: 5,),
                                                        Text(widget.posts[index]['writer']['userName'],style: TextStyle(color: whiteColor),),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 30),
                                                      child: Text(DateFormat('yyyy-MM-dd – kk:mm').format(dt).toString(),style: TextStyle(color: greyColor),),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(widget.posts[index]['content'],style: TextStyle(color: whiteColor),),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          FlatButton(
                                                              shape: RoundedRectangleBorder(
                                                                side: BorderSide(
                                                                    color: greyColor,
                                                                    width: 2,
                                                                    style: BorderStyle.solid),
                                                                borderRadius:
                                                                BorderRadius.circular(borderRadiusValue),),
                                                            color: buttonColor,
                                                            child: Text("Comment",style: TextStyle(
                                                              color: backgroundColor,
                                                              fontSize: 15,
                                                            ),),
                                                            onPressed: (){
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) =>infoComments(postId: widget.posts[index]['id'],),
                                                                ),
                                                              );
                                                            }
                                                             /* String userName =  await HelpFunction.getuserNamesharedPrefrence();
                                                              setState(() {
                                                                widget.posts.add({
                                                                  "content": textfieldController.text,
                                                                  "writerId": widget.userID,
                                                                  "zoneId": widget.zoneID,
                                                                  "date": DateTime.now().toString(),
                                                                  "writer":{
                                                                    "userName": userName,
                                                                  }
                                                                });
                                                              });
                                                              addPostInZone(textfieldController.text,widget.userID,widget.zoneID);
                                                              textfieldController.clear();
                                                              //print(textfieldController.text);
                                                            },*/
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                            ListView(
                              children: [
                                Container(
                                  child: Column(
                                    children: [
                                      Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: greyColor,
                                                width: 2,
                                                style: BorderStyle.solid),
                                            borderRadius:
                                            BorderRadius.circular(borderRadiusValue),),
                                          color: backgroundColor ,
                                          child: AddTask(isAutoFocus: false,)),
                                      Container(
                                        child: ListView.builder(
                                          reverse: true,
                                          shrinkWrap: true,
                                          physics: ScrollPhysics(),
                                          itemCount: widget.tasks.length,
                                          itemBuilder: (BuildContext context,int index){
                                            String date = widget.tasks[index]['publishDate'];
                                            DateTime dt = DateTime.parse("$date");
                                            return Card(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: greyColor,
                                                    width: 2,
                                                    style: BorderStyle.solid),
                                                borderRadius:
                                                BorderRadius.circular(borderRadiusValue),),
                                              color: backgroundColor ,
                                              child: Container(
                                                padding: EdgeInsets.all(16.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(Icons.task_sharp,color: buttonColor,),
                                                        SizedBox(width: 5,),
                                                        Text(widget.tasks[index]['name'],style: TextStyle(color: whiteColor),),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 30),
                                                      child: Text(DateFormat('yyyy-MM-dd – kk:mm').format(dt).toString(),style: TextStyle(color: greyColor),),
                                                    ),
                                                  /*  Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text("Your life does not get better by chance. It gets better by a change",style: TextStyle(color: whiteColor),),
                                                    ),*/
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: ListView.builder(

                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      itemCount: widget.zoneMembers.length,
                                      itemBuilder: (BuildContext context,int index){
                                        realIndex = index+1;
                                        return Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: greyColor,
                                                width: 2,
                                                style: BorderStyle.solid),
                                            borderRadius:
                                            BorderRadius.circular(borderRadiusValue),),
                                          color: backgroundColor ,
                                          child: Container(
                                            padding: EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    realIndex==1?
                                                    CircleAvatar(
                                                      radius: (30),
                                                      backgroundColor: backgroundColor,
                                                      child: Image.asset('assets/images/first.png'),
                                                    ):realIndex==2?
                                                    CircleAvatar(
                                                      radius: (35),
                                                      backgroundColor: backgroundColor,
                                                      child: Image.asset('assets/images/second.png'),
                                                    ):realIndex==3?
                                                    CircleAvatar(
                                                      radius: (35),
                                                      backgroundColor: backgroundColor,
                                                      child: Image.asset('assets/images/third.png'),
                                                    ):
                                                    Text("$realIndex",style: TextStyle(color: buttonColor,fontSize: 20),),
                                                    SizedBox(width: 10,),
                                                    Expanded(child: Text(widget.zoneMembers[index]['account']['userName'],style: TextStyle(color: whiteColor,fontSize: 15),)),
                                                    Text(widget.zoneMembers[index]['numOfCompletedTasks'].toString(),style: TextStyle(color: whiteColor,fontSize: 25),),

                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ]),
                        ),
                      ),
                    ]),
              ),
            ),
          ]),
          ),
    );
  }


}