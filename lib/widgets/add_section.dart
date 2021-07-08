import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xzone/models/section.dart';
import 'package:xzone/providers/projects_provider.dart';
import '../constants.dart';

class AddSection extends StatelessWidget {
  final Key tKey;
  final int pIndex;

  const AddSection({Key key, this.tKey, this.pIndex}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Add Section',
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
              hintText: 'Section Name',
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
              Section section = new Section(value);
              Provider.of<ProjectsProvider>(context, listen: false).addSection(pIndex, section);
              Navigator.pop(context);
            },
            validator: (value){
              if(value.isEmpty) return 'Enter section name';
              return null;
            },
          ),
        )
      ],
    );
  }
}
