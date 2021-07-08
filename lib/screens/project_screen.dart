import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/models/project.dart';
import 'package:xzone/models/task.dart';
import 'package:xzone/providers/projects_provider.dart';
import 'package:xzone/providers/tasks_provider.dart';
import 'package:xzone/widgets/add_section.dart';
import 'package:xzone/widgets/add_task.dart';
import 'package:xzone/widgets/task_card.dart';

class ProjectScreen extends StatefulWidget {
  static final String id = 'project screen';
  final int pIndex;

  const ProjectScreen({Key key, this.pIndex}) : super(key: key);

  @override
  _ProjectScreenState createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  var globalKey = GlobalKey<FormState>();

  addTaskBottomSheet(int index) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusValue),
        ),
        context: context,
        builder: (context){
          return AddTask(
            inSection: true,
            pIndex: widget.pIndex,
            sIndex: index,
          );
        });
  }

  showAddSectionDialog(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadiusValue))
          ),
          content: AddSection(
            tKey: globalKey,
            pIndex: widget.pIndex,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                  onPressed: (){
                    bool valid = globalKey.currentState.validate();
                    if(valid){
                      FocusScope.of(context).unfocus();
                      globalKey.currentState.save();
                    }
                  },
                  child: Text(
                    'Create',
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
    Project project = Provider.of<ProjectsProvider>(context).items[widget.pIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: CarouselSlider.builder(
            options: CarouselOptions(
              height: double.infinity,
              viewportFraction: 0.9,
              enableInfiniteScroll: false,
              reverse: false,
              autoPlay: false,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: false,
            ),
            itemCount: project.sections.length + 1,
            itemBuilder: (BuildContext context, int index, int realIndex) {
              if(index < project.sections.length)
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.sections[index].name,
                    style: TextStyle(
                      fontSize: 18,
                      color: whiteColor,
                    ),
                  ),
                  SizedBox(height: 10,),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: project.sections[index].tasks.length,
                    itemBuilder: (ctx, lvIndex){
                      return TaskCard(task: project.sections[index].tasks[lvIndex],);
                    },
                  ),
                  SizedBox(height: 10,),
                  InkWell(
                    onTap: (){
                      Provider.of<TasksProvider>(context, listen: false).setActiveTaskDueDate(DateTime.now());
                      addTaskBottomSheet(index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: whiteColor,
                          ),
                          SizedBox(width: 5,),
                          Text(
                            'Add task',
                            style: TextStyle(
                              fontSize: 16,
                              color: whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
              else return InkWell(
                onTap: showAddSectionDialog,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: whiteColor,
                      ),
                      SizedBox(width: 5,),
                      Text(
                        'Add section',
                        style: TextStyle(
                          fontSize: 16,
                          color: whiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
