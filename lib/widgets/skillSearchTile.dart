import 'package:flutter/material.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/servcies/web_services.dart';

class SearchTile extends StatefulWidget {
  var name;
  var alreadyadded;
  var selected;
  var id;
  var userid;
  SearchTile(
      {this.name, this.alreadyadded, this.selected, this.id, this.userid});
  @override
  _SearchTileState createState() => _SearchTileState();
}

class _SearchTileState extends State<SearchTile> {
  var webService = WebServices();
  AddSkillToAccount(id, userid) async {
    try {
      var response = await webService
          .post('http://xzoneapi.azurewebsites.net/api/v1/AccountSkill', {
        "accountID": userid,
        "skillID": id,
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.name, style: TextStyle(color: Colors.white)),
      trailing: widget.alreadyadded
          ? Icon(
              Icons.check,
              color: buttonColor,
            )
          : IconButton(
              icon: Icon(
                widget.selected ? Icons.check : Icons.add,
                color: buttonColor,
              ),
              onPressed: () {
                AddSkillToAccount(widget.id, widget.userid);
                setState(() {
                  widget.selected = !widget.selected;
                });
              },
            ),
    );
  }
}
