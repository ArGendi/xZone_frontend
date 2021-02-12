import 'package:flutter/material.dart';
import 'package:xzone/constants.dart';

class CustomTextField extends StatefulWidget {
  final String text;
  final bool obscureText;
  final TextInputType textInputType;
  final Function(String textInput) setValue;
  final Function(String value) validation;

  CustomTextField({Key key, this.text, this.obscureText, this.textInputType, this.setValue, this.validation}) : super(key: key);

  @override
  _CustomTextFieldState createState() =>
      _CustomTextFieldState(obscureText: obscureText);
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _visibility = false;
  bool obscureText;

  _CustomTextFieldState({this.obscureText});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.white,
      keyboardType: widget.textInputType,
      style: TextStyle(color: Colors.white),
      obscureText: obscureText,
      decoration: InputDecoration(
          suffixIcon: widget.obscureText ? IconButton(
            icon: Icon(!_visibility ? Icons.visibility_off : Icons.visibility),
            color: greyColor,
            onPressed: () {
              setState(() {
                _visibility = !_visibility;
                obscureText = !obscureText;
              });
            },
          ) : null,
          labelText: widget.text,
          labelStyle: TextStyle(color: Colors.white),
          fillColor: backgroundColor,
          contentPadding: EdgeInsets.all(20),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadiusValue),
            borderSide: BorderSide(
              color: greyColor,
              width: 2.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadiusValue),
            borderSide: BorderSide(
              color: greyColor,
              width: 2.0,
            ),
          ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusValue),
          borderSide: BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadiusValue),
          borderSide: BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
      ),
      onChanged: (value){
        widget.setValue(value);
      },
      validator: (value){
        return widget.validation(value);
      },
    );
  }
}
