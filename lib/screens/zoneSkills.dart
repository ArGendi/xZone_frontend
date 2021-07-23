import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xzone/servcies/web_services.dart';
import 'package:xzone/widgets/skillSearchTile.dart';

import '../constants.dart';

class zoneSkill extends StatefulWidget {
  final Function(List textInput) setValue;

  const zoneSkill({Key key, this.setValue}) : super(key: key);
  @override
  _zoneSkillState createState() => _zoneSkillState();
}

class _zoneSkillState extends State<zoneSkill> {
  TextEditingController searchtextEditingController = new TextEditingController();
  WebServices webService = WebServices();
  List Temp;
  List skills;
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
  searchList() {
    return skills != null
        ? ListView.builder(
        itemCount: skills.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return searchTile(
             skills[index]["name"],
             skills[index]["id"],
            //userid: 5,
          );
        })
        : Container();
  }
  List skillsID=[];
  searchTile(String name,int id){
    return ListTile(
      title: Text(name, style: TextStyle(color: Colors.white)),
      trailing: IconButton(
        icon: Icon(
          Icons.add,
          color: buttonColor,
        ),
        onPressed: () {
          print(id.toString());
          skillsID.add(id);
          print(skillsID);
        },
      ),
    );
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
                    print("----------"+skillsID.length.toString());
                    widget.setValue(skillsID);
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
