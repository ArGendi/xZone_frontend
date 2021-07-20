import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:xzone/repositories/FireBaseDB.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/screens/conversation.dart';
import 'package:xzone/servcies/helperFunction.dart';
import 'package:xzone/servcies/web_services.dart';
import 'package:xzone/widgets/searchTile.dart';

class Skills extends StatefulWidget {
  static String id = "skills";
  @override
  _SkillsState createState() => _SkillsState();
}

class _SkillsState extends State<Skills> {
  TextEditingController searchtextEditingController =
      new TextEditingController();
  List skills;
  String _errorMsg = '';
  bool alreadyadded = false;
  var webService = WebServices();
  List Temp;
  beginsearch() async {
    try {
      var input = searchtextEditingController.text;
      var response = await webService
          .get('http://xzoneapi.azurewebsites.net/api/v1/Skill/$input');

      Temp = jsonDecode(response.body);
      setState(() {
        skills = Temp;
      });
    } catch (e) {
      print(e);
    }
  }

  bool selected;
  Widget searchList() {
    return skills != null
        ? ListView.builder(
            itemCount: skills.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                  name: skills[index]["name"],
                  alreadyadded: alreadyadded,
                  selected: false,
                  id: skills[index]["id"]);
            })
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 20),
      child: ListView(
        children: [
          Row(children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
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
                      controller: searchtextEditingController,
                      decoration: InputDecoration(
                          hintText: "What is your skill?..",
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none),
                    )),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          beginsearch();
                        });
                      },
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ]),
          searchList()
        ],
      ),
    ));
  }
}
