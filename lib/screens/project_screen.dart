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

  @override
  Widget build(BuildContext context) {
    var projectsProvider =  Provider.of<ProjectsProvider>(context);
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
        itemCount: projectsProvider.items.length,
        itemBuilder: (BuildContext context, int index, int realIndex) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                    child: Text(
                      'P1',
                      style: TextStyle(
                        fontSize: 20,
                        color: whiteColor,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemBuilder:(context, index){
                      return Container();
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
