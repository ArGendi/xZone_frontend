import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/models/project.dart';
import 'package:xzone/providers/projects_provider.dart';
import 'package:xzone/widgets/task_card.dart';

class ProjectScreen extends StatelessWidget {
  static final String id = 'project screen';
  final Project project;

  const ProjectScreen({Key key, this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CarouselSlider.builder(
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
        itemCount: project.sections.length,
        itemBuilder: (BuildContext context, int index, int realIndex) {
          return Center(
            child: Text('Hi',style: TextStyle(color: whiteColor),),
          );
        },
      ),
    );
  }
}
