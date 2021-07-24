import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:xzone/screens/zoneSkills.dart';
import 'package:xzone/servcies/helperFunction.dart';
import 'package:xzone/servcies/web_services.dart';
import 'package:xzone/widgets/custom_textfield.dart';
import 'package:xzone/widgets/skillSearchTile.dart';
import '../constants.dart';

class CreateNewZone extends StatefulWidget {
  static String id = "Create zone";
  @override
  _CreateNewZoneState createState() => _CreateNewZoneState();
}

class _CreateNewZoneState extends State<CreateNewZone> {
  final _formKey = GlobalKey<FormState>();
  List skills;
  bool _loading = false;
  String _zonename;
  String _zonecode="0000";
  String _zonedescription;
  bool _showErrorMsg = false;
  String _errorMsg = '';
  List privacy = ["Private", "Public"];
  String dropdownvalue = 'Public';
  int priv=1;
  var items =  ['Public','Private'];
  _setName(String name) {
    _zonename = name;
  }
  _setDesc(String desc) {
    _zonedescription = desc;
  }

  _setCode(String code) {
    _zonecode = code;
  }

  _setList(List skills){
    print(skills);
    this.skills = skills;
  }
  WebServices webServices = WebServices();
  AddSkillToZone(zoneId, skillId) async {
    try {
      var response = await webServices
          .post('http://xzoneapi.azurewebsites.net/api/v1/ZoneSkill', {
        "zoneId": zoneId,
        "skillId": skillId,
      });
      if(response.statusCode==200) skills.remove(skillId);

     // print(id);
    } catch (e) {
      print(e);
    }
  }

  _trySubmit() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      var webService = WebServices();
      setState(() {
        _loading = true;
      });

      HelpFunction.getUserId().then((id) async {
        try {
          var response = await webService.post(
              'http://xzoneapi.azurewebsites.net/api/v1/Zone/createzone/$id', {
            "name": _zonename,
            "description": _zonedescription,
            "privacy": priv,
            "joinCode": _zonecode,
          });
          if(response.statusCode==200){
           var x =  jsonDecode(response.body)['id'];
           skills.forEach((id) async {
            await AddSkillToZone(x,id);
            if(skills.isEmpty)  Navigator.pop(context);
           });

          }
          print(id);
          print(response.statusCode);
          print(_zonecode);
          print(_zonedescription);
          print(_zonename);
          if (response.statusCode >= 400) {
            setState(() {
              _showErrorMsg = true;
              _errorMsg = response.body;
            });
          }
        } catch (e) {
          print(e);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Center(
            child: Text(
          "Create Zone",
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        )),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            CustomTextField(
              text: "Name your zone",
              textInputType: TextInputType.text,
              obscureText: false,
              setValue: _setName,
              validation: (value) {
                if (value.isEmpty) return 'Enter your zone name';
              },
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextField(
              text: "Zone description",
              obscureText: false,
              textInputType: TextInputType.text,
              setValue: _setDesc,
              validation: (value) {
                if (value.isEmpty) return 'Enter your zone zone description';
              },
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context){
                  return zoneSkill(setValue: _setList,);
                }));
              },
              child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius:  BorderRadius.circular(15),
                  border: Border.all(width: 2,color: greyColor),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Skills",
                      style: TextStyle(color: Colors.white),
                    ),
                    /*GestureDetector(
                      onTap: () {
                        beginsearch();
                      },*/
                       Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                  ],
                ),

              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius:  BorderRadius.circular(10),
                border: Border.all(width: 2,color: greyColor),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton(
                  value: dropdownvalue,
                  dropdownColor: backgroundColor,
                  underline: Container() ,
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 18,
                  ),
                  icon: Icon(Icons.keyboard_arrow_down),
                  items:items.map((String items) {
                    return DropdownMenuItem(
                        value: items,
                        child: Text(items)
                    );
                  }
                  ).toList(),
                  onChanged: (String newValue){
                    setState(() {
                      dropdownvalue = newValue;
                      if(newValue == "Public") priv=1;
                      else priv=0;
                      print(priv);
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            priv==0?
            CustomTextField(
              text: "Zone code",
              obscureText: false,
              textInputType: TextInputType.text,
              setValue: _setCode,
              validation: (value) {
                if (value.isEmpty) return 'Enter your zone code';
                if (value.length < 4) return 'Short code';
                return null;
              },
            ):Card(),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: _trySubmit,
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.circular(borderRadiusValue),
                ),
                child: !_loading
                    ? Text(
                        "Create Zone",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: "Montserrat-Medium"),
                      )
                    : CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(whiteColor),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
