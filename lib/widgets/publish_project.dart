import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xzone/providers/projects_provider.dart';
import '../constants.dart';

class PublishProject extends StatelessWidget {
  final Key tKey;
  final int pIndex;

  const PublishProject({Key key, this.tKey, this.pIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Project Description',
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
                ),
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
              Provider.of<ProjectsProvider>(context, listen: false)
                  .addProjectDescription(pIndex, value);
            },
            validator: (value){
              if(value.isEmpty) return 'Enter project Description';
              return null;
            },
          ),
        )
      ],
    );
  }
}
