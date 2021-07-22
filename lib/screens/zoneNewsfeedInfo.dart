import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/screens/zones_screen.dart';
import 'package:xzone/servcies/web_services.dart';
import 'package:xzone/screens/profile.dart';

class infoZoneNewsfeed extends StatefulWidget{
  static final String id = 'loading';
  final int userId;

  const infoZoneNewsfeed({Key key, this.userId}) : super(key: key);
  @override
  infoZoneNewsfeedState createState() => infoZoneNewsfeedState();
}
class infoZoneNewsfeedState extends State<infoZoneNewsfeed>{

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
      List zones = body['zones'];
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => zones_profile(
            checkMe: false,
            zones: zones,
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