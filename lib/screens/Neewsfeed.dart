import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/widgets/ZoneWidget.dart';
import 'package:xzone/widgets/drawer.dart';
import 'package:xzone/providers/zones_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:xzone/screens/generalSearch.dart';

class Neewsfeed extends StatelessWidget {
  final email;
  final username;
  static String id = 'newsfeed';

  const Neewsfeed({this.email, this.username});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(
        email: email,
        username: username,
      ),
      appBar: AppBar(
        elevation: 0,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: whiteColor,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (contetx) => generalSearch()));
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.notifications,
                  color: whiteColor,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.facebookMessenger,
                  color: whiteColor,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'chatroom');
                },
              ),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ZoneWidget(
                  name: Provider.of<ZoneProvider>(context).zones[index].name,
                  numberOfmembers: Provider.of<ZoneProvider>(context)
                      .zones[index]
                      .numberOfmembers,
                  skill: Provider.of<ZoneProvider>(context).zones[index].skill,
                  admins:
                      Provider.of<ZoneProvider>(context).zones[index].admins,
                );
              },
              itemCount: Provider.of<ZoneProvider>(context).zones.length,
            ),
          ),
        ],
      ),
    );
  }
}
