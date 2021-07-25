import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xzone/servcies/web_services.dart';

import '../constants.dart';
import 'commentScreen.dart';

class infoComments extends StatefulWidget {
 final int postId;

  const infoComments({Key key, this.postId}) : super(key: key);

  @override
  _infoCommentsState createState() => _infoCommentsState();
}

class _infoCommentsState extends State<infoComments> {

  _getDataFromDb() async{
    try {
      var webService = WebServices();
      int postId = widget.postId;

      var response = await webService.get(
          'http://xzoneapi.azurewebsites.net/api/v1/comment/postComments/$postId');
      var body = json.decode(response.body);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => comments(
            commentList: body,
            postId: widget.postId,

          ),
        ),
      );
      //String writer = body['writer']['userName'];

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
