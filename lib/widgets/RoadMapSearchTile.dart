import 'package:flutter/material.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/models/project.dart';
import 'package:xzone/providers/projects_provider.dart';
import 'package:provider/provider.dart';

class RoadmapTile extends StatefulWidget {
  final name;
  final description;
  final jsoncode;

  const RoadmapTile({Key key, this.name, this.description, this.jsoncode})
      : super(key: key);
  @override
  _RoadmapTileState createState() => _RoadmapTileState();
}

class _RoadmapTileState extends State<RoadmapTile> {
  bool pressed = false;
  showAddSectionDialog(
      String name, String Desc, roadMap, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(borderRadiusValue))),
          content: ListTile(
            leading: Icon(
              Icons.add_task,
              color: buttonColor,
            ),
            title: Text(
              name,
              style: TextStyle(color: whiteColor, fontSize: 20),
            ),
            subtitle: Text(
              Desc,
              style: TextStyle(color: whiteColor),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: buttonColor),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                  onPressed: () {
                    Project project = new Project(roadMap['name']);
                    project.description = Desc;
                    project.id = roadMap['id'];
                    project.userID = roadMap['ownerID'];
                    Provider.of(context, Listen: false)
                        .addProject(project, true);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Get',
                    style: TextStyle(color: buttonColor),
                  )),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.list, color: Colors.grey),
          backgroundColor: buttonColor,
        ),
        title: Text(widget.name, style: TextStyle(color: Colors.white)),
        subtitle:
            Text(widget.description, style: TextStyle(color: Colors.grey)),
        trailing: GestureDetector(
          onTap: () {
            showAddSectionDialog(
                widget.name, widget.description, widget.jsoncode, context);
            setState(() {
              pressed = true;
            });
          },
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 11),
              child: Text(pressed ? "Added" : "Add",
                  style: TextStyle(
                    color: Colors.black,
                  )),
              decoration: BoxDecoration(
                  color: buttonColor, borderRadius: BorderRadius.circular(13))),
        ));
  }
}

class Provider {
  static of(BuildContext context, {bool Listen}) {}
}
