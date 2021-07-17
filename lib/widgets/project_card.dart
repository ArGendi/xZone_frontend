import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:xzone/providers/projects_provider.dart';
import '../constants.dart';
import 'package:provider/provider.dart';

class ProjectCard extends StatefulWidget {
  final String text;
  final Function onClick;
  final int pIndex;

  const ProjectCard({Key key, this.text, this.onClick, this.pIndex}) : super(key: key);

  @override
  _ProjectCardState createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  _deleteProject(){
    Provider.of<ProjectsProvider>(context, listen: false).removeProject(widget.pIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.20,
      child: InkWell(
        onTap: widget.onClick,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: buttonColor,
                    ),
                    SizedBox(width: 10,),
                    Text(
                      widget.text,
                      style: TextStyle(
                        fontSize: 16,
                        color: whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: whiteColor,
              )
            ],
          ),
        ),
      ),
      secondaryActions: [
        IconSlideAction(
          color: Colors.red,
          icon: Icons.delete_outline,
          onTap: _deleteProject,
        )
      ],
    );
  }
}
