import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String btnText;
  Button({Key? key,required this.btnText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 20),
      color: Color(0xFFFE2C55),
      child: Center(child: Text(btnText,textAlign: TextAlign.center,style: TextStyle(fontSize: 20),)),
    );
  }
}
