import 'package:flutter/material.dart';
import 'package:tik_tok/constant.dart';

class TextInputField extends StatelessWidget {

  final TextEditingController controller;
  final IconData myIcon;
  final String myLabelText;
  final bool isHide;
   TextInputField({Key? key,required this.controller,required this.myIcon,required this.myLabelText,required this.isHide}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isHide,
      controller: controller,
      decoration: InputDecoration(
        icon: Icon(myIcon),
        labelText: myLabelText,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: borderColor
          )
        )
      ),
    );
  }
}
