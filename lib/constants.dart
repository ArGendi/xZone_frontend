import 'package:flutter/material.dart';
import 'package:xzone/models/ZoneColor.dart';

// Colors
final backgroundColor = Color(0xFF191720);
final buttonColor = Color(0xffffd36a);
final greyColor = Color(0xff3b3941);
final silver = Color(0xffb40202);
final gold = Color(0xffd9a502);
final platinum = Color(0xff2e2e31);
final whiteColor = Colors.white;
List<colorzone> zonescolor = [
  colorzone(
    Color(0xffDA4453),
    Color(0xff89216B),
  ),
  colorzone(
    Color(0xff00467F),
    Color(0xffA5CC82),
  ),
  colorzone(
    Color(0xfff7b733),
    Color(0xfffc4a1a),
  ),
  colorzone(
    Color(0xffED213A),
    Color(0xff93291E),
  ),
];
// Border radius
const borderRadiusValue = 12.0;

class constant {
  static String myname = "";
  static String myemail = "";
}

// priorities colors
final priority1Color = buttonColor;
final priority2Color = whiteColor;
final lowPriority = greyColor;

//DB tables names
const String tasksTable = 'tasks';
const String sectionsTable = 'sections';
const String projectsTable = 'projects';
