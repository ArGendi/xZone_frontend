import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/helpers/db_helper.dart';
import 'package:xzone/servcies/web_services.dart';
import 'package:xzone/screens/profile.dart';

class info extends StatefulWidget{
  static final String id = 'loading';
  final int userId;
  final bool checkMe;
  final int myId;

  const info({Key key, this.userId, this.checkMe, this.myId}) : super(key: key);
  @override
  infoState createState() => infoState();
}
class infoState extends State<info>{

  //DBHelper _dbHelper = DBHelper();
  //String _email ="sama@gmail.com";
  bool _showErrorMsg = false;
  String userName;
  String bio ;
  int rank;
  //DBHelper _dbHelper = new DBHelper();
  _getDataFromDb() async{
    try {
    var webService = WebServices();

      int userId = widget.userId;
      var response = await webService.get(
          'http://xzoneapi.azurewebsites.net/api/v1/account/profile/$userId');
        var body = json.decode(response.body);
          print(response.statusCode);
         userName = body['userName'];
    print(userName);
         bio = body['bio'];
    print(bio);
         rank  = body['rank'];
    print(rank);
         List badges =body['badges'];
    print(badges);
         List roadMap =body['roadmaps'];
         List zones = body['zones'];
         List friends = body['friends'];
         print("!");
         List skill = body['skills'];
          String email;
         if(skill.isNotEmpty) {
           skill = body['skills'][0]['account']['skills'];
           email = body['skills'][0]['account']['email'];
         }
         //print(skills);
         bool checkFriedns=false;
         for(int i=0;i<friends.length;i++){
           if(friends[i]['id']==widget.myId){
             checkFriedns = true;
           }
         }
         print(email);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => profile(
              checkMe: widget.checkMe,
              userName: userName,
              bio: bio,
              rank: rank,
              badges: badges,
              roadMaps:roadMap,
              zones: zones,
              userId: userId,
              friends: friends,
              checkFriedns: checkFriedns,
              skills: skill,
              email: email,
              //roadMaps: roadMap,
            ),
          ),
        );

    } catch (e) {
      print(e);
      setState(() {
       // _errorMsg = e.toString();
      });
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getDataFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(buttonColor),
        ),
      ),
    );
  }

}