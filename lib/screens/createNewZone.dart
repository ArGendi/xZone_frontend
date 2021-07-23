import 'package:flutter/material.dart';
import 'package:xzone/servcies/helperFunction.dart';
import 'package:xzone/servcies/web_services.dart';
import 'package:xzone/widgets/custom_textfield.dart';
import '../constants.dart';

class CreateNewZone extends StatefulWidget {
  static String id = "Create zone";
  @override
  _CreateNewZoneState createState() => _CreateNewZoneState();
}

class _CreateNewZoneState extends State<CreateNewZone> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String _zonename;
  String _zonecode;
  String _zonedescription;
  bool _showErrorMsg = false;
  String _errorMsg = '';
  List privacy = ["Private", "Public"];
  _setName(String name) {
    _zonename = name;
  }

  _setDesc(String desc) {
    _zonedescription = desc;
  }

  _setCode(String code) {
    _zonecode = code;
  }
  Widget DropDownList(){
    
  }
  _trySubmit() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      var webService = WebServices();
      setState(() {
        _loading = true;
      });

      HelpFunction.getUserId().then((id) async {
        try {
          var response = await webService.post(
              'http://xzoneapi.azurewebsites.net/api/v1/Zone/createzone/$id', {
            "name": _zonename,
            "description": _zonedescription,
            "privacy": 0,
            "joinCode": _zonecode
          });
          print(id);
          print(response.statusCode);
          print(_zonecode);
          print(_zonedescription);
          print(_zonename);
          if (response.statusCode >= 400) {
            setState(() {
              _showErrorMsg = true;
              _errorMsg = response.body;
            });
          }
        } catch (e) {
          print(e);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Center(
            child: Text(
          "Create Zone",
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        )),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            CustomTextField(
              text: "Name your zone",
              textInputType: TextInputType.text,
              obscureText: false,
              setValue: _setName,
              validation: (value) {
                if (value.isEmpty) return 'Enter your zone name';
              },
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextField(
              text: "Zone description",
              obscureText: false,
              textInputType: TextInputType.text,
              setValue: _setDesc,
              validation: (value) {
                if (value.isEmpty) return 'Enter your zone zone description';
              },
            ),
            SizedBox(
              height: 10,
            ),
            CustomTextField(
              text: "Zone code",
              obscureText: false,
              textInputType: TextInputType.text,
              setValue: _setCode,
              validation: (value) {
                if (value.isEmpty) return 'Enter your zone code';
                if (value.length < 4) return 'Short code';
                return null;
              },
            ),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: _trySubmit,
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.circular(borderRadiusValue),
                ),
                child: !_loading
                    ? Text(
                        "Create Zone",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: "Montserrat-Medium"),
                      )
                    : CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(whiteColor),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
