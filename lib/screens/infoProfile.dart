import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/helpers/db_helper.dart';
import 'package:xzone/servcies/web_services.dart';
import 'package:xzone/screens/profile.dart';

class info extends StatefulWidget{
  static final String id = 'loading';
  final int userId;

  const info({Key key, this.userId}) : super(key: key);
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

         userName = body['userName'];
         bio = body['bio'];
         rank  = body['rank'];
         List badges =body['badges'];
         List roadMap =body['roadmaps'];
         List zones = body['zones'];
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => profile(
              checkMe: false,
              userName: userName,
              bio: bio,
              rank: rank,
              badges: badges,
              roadMaps:roadMap,
              zones: zones,
              userId: userId,
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