import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class comments extends StatefulWidget {
final int postId;

  const comments({Key key, this.postId}) : super(key: key);

  @override
  _commentsState createState() => _commentsState();
}

class _commentsState extends State<comments> {
  var textfieldController = TextEditingController();
  List comments = ['aaaaaaaa','xxxxxxxxxx','zzzzzzzzz'];
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
                itemCount: comments.length,
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
                                  Text("bebo",style: TextStyle(color: whiteColor),
                                  ),
                                ],
                              ),
                              IconButton(onPressed: (){},
                                icon:Icon( Icons.delete),
                                color: Colors.red,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(comments[index],style: TextStyle(color: whiteColor),),
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
                        onPressed: () {
                          setState(() {
                            comments.add(textfieldController.text);
                            textfieldController.clear();
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
