import 'package:flutter/material.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/servcies/helperFunction.dart';
import 'package:xzone/servcies/web_services.dart';

class ZoneSearchTile extends StatefulWidget {
  final name;
  final description;
  final privacy;
  final zoneId;
  final alreadyYourzone;
  const ZoneSearchTile(
      {this.name,
      this.description,
      this.privacy,
      this.zoneId,
      this.alreadyYourzone});
  @override
  _ZoneSearchTileState createState() => _ZoneSearchTileState();
}

class _ZoneSearchTileState extends State<ZoneSearchTile> {
  var webService = WebServices();
  bool pressed = false;
  Future<String> CreateAlertDialog(BuildContext context) {
    TextEditingController codeEntry = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 0,
            backgroundColor: backgroundColor,
            title: Text(
              "Zone's Code?",
              style: TextStyle(color: Colors.white),
            ),
            content: TextField(
                controller: codeEntry,
                decoration: InputDecoration(fillColor: Colors.white)),
            actions: [
              MaterialButton(
                  color: buttonColor,
                  elevation: 0,
                  child: Text("Submit"),
                  onPressed: () {
                    Navigator.of(context).pop(codeEntry.text.toString());
                  })
            ],
          );
        });
  }

  Join(userid, zoneid, joinCode) async {
    try {
      var response = await webService.post(
          'http://xzoneapi.azurewebsites.net/api/v1/ZoneMember/$joinCode', {
        "zoneId": zoneid,
        "accountId": userid,
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.group, color: Colors.grey),
          backgroundColor: buttonColor,
        ),
        title: Row(
          children: [
            Text(widget.name, style: TextStyle(color: Colors.white)),
            SizedBox(
              width: 8,
            ),
            widget.privacy == 1
                ? Icon(
                    Icons.lock,
                    color: Colors.white,
                    size: 18,
                  )
                : Icon(
                    Icons.public,
                    color: Colors.white,
                    size: 18,
                  ),
          ],
        ),
        subtitle: widget.alreadyYourzone
            ? Text("your zone", style: TextStyle(color: Colors.grey))
            : Text(widget.description, style: TextStyle(color: Colors.grey)),
        trailing: widget.alreadyYourzone
            ? Icon(
                Icons.check,
                color: buttonColor,
              )
            : GestureDetector(
                onTap: () {
                  HelpFunction.getUserId().then((userId) {
                    widget.privacy == 0
                        ? Join(userId, widget.zoneId, 0000)
                        : CreateAlertDialog(context).then((value) {
                            Join(userId, widget.zoneId, value);
                          });
                  });
                },
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 7, horizontal: 11),
                    child: Text(pressed ? "joined" : "join",
                        style: TextStyle(
                          color: Colors.black,
                        )),
                    decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.circular(13))),
              ));
  }
}
