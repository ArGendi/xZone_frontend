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
import 'package:xzone/servcies/helperFunction.dart';
import 'package:xzone/servcies/web_services.dart';
import 'package:xzone/widgets/add_project.dart';
import 'package:xzone/widgets/add_section.dart';
import 'package:xzone/widgets/add_task.dart';
import 'package:xzone/widgets/more_section_options.dart';
import 'package:xzone/widgets/publish_project.dart';
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
  WebServices _webServices = new WebServices();

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

  moreOptionsBottomSheet(int sIndex) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusValue),
        ),
        context: context,
        builder: (context){
          return MoreSectionOptions(
            pIndex: widget.pIndex,
            sIndex: sIndex,
          );
        });
  }

  showEditProjectDialog(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadiusValue))
          ),
          content: AddProject(
            tKey: globalKey,
            isEdit: true,
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

  showWriteProjectDescriptionDialog(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool published = false;
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(borderRadiusValue))
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if(published)
                Icon(
                  Icons.check_circle,
                  size: 40,
                  color: Colors.green,
                ),
                SizedBox(height: 10,),
                PublishProject(
                  tKey: globalKey,
                  pIndex: widget.pIndex,
                ),
              ],
            ),
            actions: [
              if(!published)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextButton(
                    onPressed: () async{
                      bool valid = globalKey.currentState.validate();
                      if(valid){
                        FocusScope.of(context).unfocus();
                        globalKey.currentState.save();
                        List projects = Provider.of<ProjectsProvider>(context, listen: false).items;
                        bool temp = await publishProject(projects[widget.pIndex]);
                        if(temp){
                          setState(() {
                            published = true;
                          });
                        }
                      }
                    },
                    child: Text(
                      'Publish',
                      style: TextStyle(
                          color: buttonColor
                      ),
                    )
                ),
              )
              else
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Close',
                        style: TextStyle(
                            color: buttonColor
                        ),
                      )
                  ),
                )
            ],
          ),
        );
      },
    );
  }

  publishProject(Project project) async{
    int userId = await HelpFunction.getUserId();
    var response = await _webServices.post('http://xzoneapi.azurewebsites.net/api/Roadmap?api-version=1',
        {
          "name": project.name,
          "ownerID": userId,
          "description": project.description,
          "projectId": project.id
        });
    if(response.statusCode == 200){
      print('Project published');
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Project project = Provider.of<ProjectsProvider>(context).items[widget.pIndex];
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: Text(project.name),
        actions: [
          IconButton(
              icon: Icon(Icons.edit, color: buttonColor,),
              onPressed: showEditProjectDialog,
          ),
          IconButton(
            icon: Icon(Icons.cloud_upload, color: buttonColor,),
            onPressed: showWriteProjectDescriptionDialog,
          ),
        ],
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            project.sections[index].name,
                            style: TextStyle(
                              fontSize: 18,
                              color: whiteColor,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.more_vert, color: buttonColor,),
                            onPressed: (){
                              moreOptionsBottomSheet(index);
                            },
                          )
                        ],
                      ),
                      SizedBox(height: 10,),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: project.sections[index].tasks.length,
                        itemBuilder: (ctx, lvIndex){
                          return TaskCard(
                            task: project.sections[index].tasks[lvIndex],
                            bgColor: Colors.grey[800],
                            pIndex: widget.pIndex,
                            sIndex: index,
                          );
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
                                color: buttonColor,
                              ),
                              SizedBox(width: 5,),
                              Text(
                                'Add task',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: buttonColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for(int i=0; i<project.sections.length + 1; i++)
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: i != project.sections.length? CircleAvatar(
                            radius: 4,
                            backgroundColor: i == index ? whiteColor : greyColor,
                          ) : Icon(Icons.add, color: greyColor, size: 20,),
                        )
                    ],
                  )
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
                        color: buttonColor,
                      ),
                      SizedBox(width: 5,),
                      Text(
                        'Add section',
                        style: TextStyle(
                          fontSize: 16,
                          color: buttonColor,
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
