import 'package:flutter/material.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/providers/projects_provider.dart';
import 'package:xzone/screens/days_list.dart';
import 'package:xzone/widgets/add_project.dart';
import 'package:provider/provider.dart';
import 'package:xzone/widgets/add_section.dart';

class MoreSectionOptions extends StatefulWidget {
  final int pIndex;
  final int sIndex;

  const MoreSectionOptions({Key key, this.pIndex, this.sIndex}) : super(key: key);

  @override
  _MoreSectionOptionsState createState() => _MoreSectionOptionsState();
}

class _MoreSectionOptionsState extends State<MoreSectionOptions> {
  var gk = GlobalKey<FormState>();

  showEditSectionDialog(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadiusValue))
          ),
          content: AddSection(
            tKey: gk,
            isEdit: true,
            pIndex: widget.pIndex,
            sIndex: widget.sIndex,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                  onPressed: (){
                    bool valid = gk.currentState.validate();
                    if(valid){
                      FocusScope.of(context).unfocus();
                      gk.currentState.save();
                    }
                  },
                  child: Text(
                    'Edit',
                    style: TextStyle(
                        color: buttonColor
                    ),
                  )
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
            onTap: (){
              Navigator.pop(context);
              showEditSectionDialog();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.edit, color: whiteColor,),
                  SizedBox(width: 10,),
                  Text(
                    'Edit',
                    style: TextStyle(
                      color: whiteColor,
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          InkWell(
            onTap: (){
              Navigator.pop(context);
              Provider.of<ProjectsProvider>(context, listen: false)
                  .removeSection(widget.pIndex, widget.sIndex);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red,),
                  SizedBox(width: 10,),
                  Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
