import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/servcies/web_services.dart';
import 'package:xzone/widgets/add_task.dart';
import 'package:intl/intl.dart';
class ZoneTest extends StatefulWidget {
  @override
  final List posts;
  final String zoneName;
  final int zoneID;
  final int userID;
  //final String userName;

  const ZoneTest({Key key, this.posts, this.zoneName, this.zoneID, this.userID}) : super(key: key);
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ZoneStateTest();
  }
}
class ZoneStateTest extends State<ZoneTest>{
  int realIndex;
  var textfieldController = TextEditingController();

  addPostInZone(String content,int writerId,int zoneId)async{
    var webService = WebServices();
    var response = await webService.post(
        'http://xzoneapi.azurewebsites.net/api/v1/post/writepost', {
      "content": content,
      "writerId": writerId,
      "zoneId" : zoneId
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
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              color: buttonColor,
              onPressed: () {},
            ),
          ],
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
          Icon(Icons.lock,color: buttonColor,size: 15,),
          SizedBox(width: 5,),
          Text(
            "Private Zone",
            style: TextStyle(color: whiteColor, fontSize: 15),
          ),
          SizedBox(width: 5,),
          Text(
            "200",
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
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: FlatButton(
                      child: Row(
                        children: [
                          Icon(Icons.people_alt_rounded , color:buttonColor ,),
                          SizedBox(width: 20,),
                          Text(
                            "Joined" ,
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
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: FlatButton(
                      child: Row(
                        children: [
                          Icon(Icons.person_add_alt_1_rounded , color:buttonColor ,),
                          SizedBox(width: 20,),
                          Text(
                            "Invite" ,
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
                  ),
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
                                                  onPressed: (){
                                                    addPostInZone(textfieldController.text,widget.userID,widget.zoneID);
                                                    //print(textfieldController.text);
                                                  },
                                                  ),
                                                ),
                                              ],
                                            ),
                                      ),
                                      Container(
                                        child: ListView.builder(
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

                                          shrinkWrap: true,
                                          physics: ScrollPhysics(),
                                          itemCount: 10,
                                          itemBuilder: (BuildContext context,int index){
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
                                                        Text("Abdelrahman Ayman",style: TextStyle(color: whiteColor),),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 30),
                                                      child: Text("1 min",style: TextStyle(color: greyColor),),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text("Your life does not get better by chance. It gets better by a change",style: TextStyle(color: whiteColor),),
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
                            Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      itemCount: 10,
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
                                                    Text("$realIndex",style: TextStyle(color: buttonColor,fontSize: 20),),
                                                    SizedBox(width: 7,),
                                                    Expanded(child: Text("Abdelrahman Ayman",style: TextStyle(color: whiteColor,fontSize: 15),)),
                                                    Text("230",style: TextStyle(color: buttonColor,fontSize: 20),),

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