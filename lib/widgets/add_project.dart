import 'package:flutter/material.dart';
import 'package:xzone/models/project.dart';
import 'package:xzone/providers/projects_provider.dart';
import '../constants.dart';
import 'package:provider/provider.dart';

class AddProject extends StatelessWidget {
  final Key tKey;

  const AddProject({Key key, this.tKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Add Project',
          style: TextStyle(
            fontSize: 18,
            color: whiteColor
          ),
        ),
        SizedBox(height: 20,),
        Form(
          key: tKey,
          child: TextFormField(
            autofocus: true,
            cursorColor: Colors.white,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(20),
              fillColor: backgroundColor,
              hintText: 'Project Name',
              hintStyle: TextStyle(
                color: greyColor,
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: greyColor,
                )
              ),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: greyColor,
                  )
              ),
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
            onSaved: (value){
              Project project = Project(value);
              Provider.of<ProjectsProvider>(context, listen: false).addProject(project);
              Navigator.pop(context);
            },
            validator: (value){
              if(value.isEmpty) return 'Enter project name';
              return null;
            },
          ),
        )
      ],
    );
  }
}
