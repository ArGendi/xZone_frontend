import 'package:flutter/material.dart';
import 'package:xzone/constants.dart';
class zones_profile extends StatefulWidget {
  final bool checkMe ;

  const zones_profile({Key key, this.checkMe}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return zonesState_profile();
  }
}
class zonesState_profile extends State<zones_profile> {
  @override
  Widget build(BuildContext context) {
    final List<String> items =
    new List<String>.generate(10, (i) => "item  ${i + 1}");
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Zones",
      home: Scaffold(
        backgroundColor:Color(0xFF191720) ,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xFF191720),
          elevation: 0,
          title: Text('Zones',style: TextStyle(
            color:whiteColor,
            fontSize: 25,
          ),
          ),
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
            color: buttonColor,
          ),
        ),
        body:
        ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, int index){
            return ListTile(
              title: Text("${items[index]}",
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 20,
                ),
              ),
              trailing: FlatButton(
                child: Text(widget.checkMe? "Join":"Leave",style: TextStyle(color: whiteColor,fontSize: 15),),
                onPressed: (){if(widget.checkMe){print("Send join zone Request");}else{print("leave");}},
                shape: RoundedRectangleBorder(side: BorderSide(
                  color:buttonColor,
                    width: 1,
                    style: BorderStyle.solid
                ), borderRadius: BorderRadius.circular(borderRadiusValue)),
              ),
              leading: CircleAvatar(child: Icon(Icons.add_task),backgroundColor: buttonColor,foregroundColor: backgroundColor,),
            );
          },
        ),
      ),
    );
  }
}