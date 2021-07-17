import 'package:flutter/material.dart';
import 'package:xzone/constants.dart';
import 'package:xzone/screens/ZoneTest.dart';
import 'package:xzone/screens/friends_screen.dart';
import 'package:xzone/screens/zones_screen.dart';



class profile extends StatefulWidget {
  final bool checkMe;

  const profile({Key key, this.checkMe}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return profileState();
  }
}

class profileState extends State<profile> {
  List<Color> colors1 = [
    Color(0xFFE8CBC0),
    Color(0xFFFDC830),
    Color(0xFF373B44),
    Color(0xFF3E5151)
  ];
  List<Color> colors2 = [
    Color(0xFF636FA4),
    Color(0xFFF37335),
    Color(0xFF4286f4),
    Color(0xFFDECBA4)
  ];
  int indeex = 0;
  showAddSectionDialog(String name,String Desc){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadiusValue))
          ),
          content:ListTile(
              leading:Icon(Icons.add_task,color: buttonColor,),
              title:Text(name,style:TextStyle(color: whiteColor,fontSize: 20),),
              subtitle:Text('The airplane is only in Act II.',style:TextStyle(color: whiteColor),),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        color: buttonColor
                    ),
                  )
              ),
            ),Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                  onPressed: (){
/*                    bool valid = globalKey.currentState.validate();
                    if(valid){
                      FocusScope.of(context).unfocus();
                      globalKey.currentState.save();
                    }*/
                  },
                  child: Text(
                    'Get',
                    style: TextStyle(
                        color: buttonColor
                    ),
                  )
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profile',
      home: Scaffold(
        backgroundColor: Color(0xFF191720),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xFF191720),
          elevation: 0,
          title: Text(
            'Profile',
            style: TextStyle(
              color: whiteColor,
              fontSize: 25,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
            color: buttonColor,
          ),
        ),
        body: ListView(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => friends(
                                    checkMe: widget.checkMe,
                                  ),),
                        );
                      },
                      child: Column(
                        children: [
                          Text(
                            'Friends',
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Text(
                            '20',
                            style: TextStyle(
                              color: buttonColor,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 150,
                    width: 150,
                    child: Card(
                      color: backgroundColor,
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Image.asset("assets/images/boy.png"),
                      ),
                    ),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: gold,
                          blurRadius: 5.0,
                          offset: Offset(0, 10),
                          spreadRadius: 0.5,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => zones_profile(
                                    checkMe: widget.checkMe,
                                  ),),
                        );
                      },
                      child: Column(
                        children: [
                          Text(
                            'Zones',
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Text(
                            '10',
                            style: TextStyle(
                              color: buttonColor,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              // padding:const EdgeInsets.symmetric(vertical: 10, horizontal: 80),
              child: Container(
                child: Text(
                  'Abdelrahman Ayman',
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Text(
                "Your life does not get better by chance. It gets better by a change",
                style: TextStyle(color: whiteColor, fontSize: 15),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            if (widget.checkMe)
              Container(
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: FlatButton(
                        child: Text(
                           "Add Friend" ,
                          style: TextStyle(color: whiteColor, fontSize: 15),
                        ),
                        onPressed: () {
                        },
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: buttonColor,
                                width: 2,
                                style: BorderStyle.solid),
                            borderRadius:
                                BorderRadius.circular(borderRadiusValue)),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child:  FlatButton(
                        child: Text(
                          "Chat" ,
                          style: TextStyle(color: whiteColor, fontSize: 15),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ZoneTest(),
                            ),
                          );
                        },
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: buttonColor,
                                width: 2,
                                style: BorderStyle.solid),
                            borderRadius:
                            BorderRadius.circular(borderRadiusValue)),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            SizedBox(
              height: 10,
            ),
            Divider(
              color: greyColor,
              thickness: 2,
              height: 30,
            ),
            Center(
              child: Container(
                child: Text(
                  'Badges',
                  style: TextStyle(
                    color: buttonColor,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 150,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: (50),
                            backgroundColor: buttonColor,
                            child: Image.asset("assets/images/badge.png"),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Medal',
                            style: TextStyle(
                              fontSize: 20,
                              color: whiteColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            Divider(
              color: greyColor,
              thickness: 2,
              height: 30,
            ),
            Center(
              child: Container(
                child: Text(
                  'RoadMap',
                  style: TextStyle(
                    color: buttonColor,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: 6,
              itemBuilder: (BuildContext context, int index) {
                indeex = index;
                if (indeex >= colors1.length) {
                  indeex = indeex % colors1.length;
                }
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: GestureDetector(
                    child: Card(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              colors1[indeex],
                              colors2[indeex],
                            ],
                          ),
                        ),
                        child: Center(
                            child: Text(
                          'C++',
                          style: TextStyle(
                            fontSize: 25,
                            color: whiteColor,
                          ),
                        ),
                        ),
                      ),
                    ),
                    onTap: (){
                        showAddSectionDialog("c++", "The best ways");
                    },
                  ),
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      (orientation == Orientation.portrait) ? 2 : 3),
            ),
          ],
        ),
      ),
    );

  }
}

