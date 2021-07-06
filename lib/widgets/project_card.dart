import 'package:flutter/material.dart';

import '../constants.dart';

class ProjectCard extends StatelessWidget {
  final String text;
  final Function onClick;

  const ProjectCard({Key key, this.text, this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    text,
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
    );
  }
}
