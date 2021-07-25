import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xzone/screens/zoneSkills.dart';

import '../constants.dart';

class searchTile extends StatefulWidget {


  @override
   String name;
   int id;
   bool check;
  searchTile({this.name, this.id, this.check});

  _searchTileState createState() => _searchTileState();
}

class _searchTileState extends State<searchTile> {
  @override

  Widget build(BuildContext context) {
    return  ListTile(
      title: Text(widget.name, style: TextStyle(color: Colors.white)),
      trailing: IconButton(
        icon: Icon(
          widget.check?Icons.check: Icons.add,
          color: buttonColor,
        ),
        onPressed: () {
          setState(() {
            //  print(check);
            widget.check = !widget.check;
            print(widget.check);
          });
          print(widget.id.toString());
          zoneSkill.skillsID.add(widget.id);
          print(zoneSkill.skillsID);
        },
      ),
    );
  }
}
