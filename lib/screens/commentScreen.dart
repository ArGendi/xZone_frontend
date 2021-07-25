import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xzone/servcies/helperFunction.dart';
import 'package:xzone/servcies/web_services.dart';

import '../constants.dart';

class comments extends StatefulWidget {
final List commentList;
final int postId;

  const comments({Key key, this.commentList, this.postId}) : super(key: key);



  @override
  _commentsState createState() => _commentsState();
}

class _commentsState extends State<comments> {
  var textfieldController = TextEditingController();
  List comments = ['aaaaaaaa','xxxxxxxxxx','zzzzzzzzz'];
  addComment(String content,int userId,int postId)async {
    var webService = WebServices();
    var response = await webService.post(
        'http://xzoneapi.azurewebsites.net/api/v1/comment/WriteComment', {
      "content": content,
      "writerId": userId,
      "postId": postId
    });

  }
  deleteComment(int postId)async {
    var webService = WebServices();
    print("id"+postId.toString());
    var response = await webService.delete(
        'http://xzoneapi.azurewebsites.net/api/v1/comment/Delete/$postId');
    print(response.statusCode);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar:  AppBar(
        backgroundColor: Color(0xFF191720),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
          color: buttonColor,
        ),
        title:  Center(child: Text("Comments",style: TextStyle(color: whiteColor, fontSize: 25),)),
      ),
      body:  Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
               // reverse: true,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: widget.commentList.length,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.comment,color: buttonColor,),
                                  SizedBox(width: 5,),
                                  Text(widget.commentList[index]['writer']['userName'],style: TextStyle(color: whiteColor),
                                  ),
                                ],
                              ),
                              IconButton(onPressed: (){
                               // print(widget.commentList[index]['id']);
                                deleteComment(widget.commentList[index]['id']);
                                setState(() {
                                  widget.commentList.removeAt(index);
                                });

                              },
                                icon:Icon( Icons.delete),
                                color: Colors.red,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.commentList[index]['content'],style: TextStyle(color: whiteColor),),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black45,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: TextStyle(color: Colors.white),
                           controller: textfieldController,
                          decoration: InputDecoration(
                              hintText: "comments",
                              hintStyle: TextStyle(color: Colors.white),
                              border: InputBorder.none),
                        ),
                      ),
                      IconButton(
                        onPressed: () async{
                          await HelpFunction.getuserNamesharedPrefrence().then((name) => {
                             HelpFunction.getUserId().then((value) {
                              setState(() {
                                // comments.add(textfieldController.text);
                                widget.commentList.add({
                                  "content":textfieldController.text,
                                  "writerId":value,
                                  "postId":widget.postId,
                                  "writer":{
                                    "userName": name,
                                  }
                                });
                                print(textfieldController.text);
                                print(value);
                                print(widget.postId);
                                addComment(textfieldController.text,value,widget.postId);
                                textfieldController.clear();
                              });

                            })

                          });

                        },
                        icon:Icon(
                          Icons.send,
                          color: buttonColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
