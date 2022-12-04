import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tik_tok/controller/auth_controller.dart';
import 'package:tik_tok/view/widgets/text_input.dart';
import 'package:tik_tok/view/widgets/buttons.dart';
import 'package:tik_tok/constant.dart';
import 'package:get/get.dart';
import 'dart:io';

class SignupScreen extends StatefulWidget {
  SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {


  TextEditingController _emailController=new TextEditingController();

  TextEditingController _usernameController=new TextEditingController();

  TextEditingController _passwordController=new TextEditingController();

  TextEditingController _confirmPasswordController=new TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    AuthController authController=Get.find();
    authController.imageUploaded.value=false;
  }

  @override
  Widget build(BuildContext context) {
    AuthController authController=Get.put(AuthController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 100),
          // alignment: Alignment.center,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Text('TIK-TOK CLONE',style: TextStyle(color: Colors.red,fontSize: 30,fontWeight: FontWeight.bold),)),
              SizedBox(height: 35,),
              InkWell(
                onTap: () {
                   authController.pickImage();
                },
                child: Center(
                  child: Stack(
                    children:[

                    Obx(() =>   ClipRRect(
                      borderRadius:
                      BorderRadius.circular(20),
                      child: Container(
                          width: 120,
                          height: 120,
                          child: authController.imageUploaded.value?Image.file(authController.proImg,width: 120,height: 120,):Image.network("https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-social-media-user-portrait-176256935.jpg",width: 120,height: 120,)),
                    ),),
                     Positioned(child:  Container(
                       padding: EdgeInsets.all(6),

                         decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.red),
                         child: Icon(Icons.edit)),bottom: 0,right: 0,)
                    ],
                  ),
                ),
              ),
              SizedBox(height: 25,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextInputField(
                  controller: _emailController,
                  myIcon: Icons.email,
                  myLabelText: "Email",
                  isHide: false,
                ),
              ),
              Obx(() => Visibility(
                visible: authController.emailErrorVisibility.value,
                child: Container(
                    margin: EdgeInsets.only(top: 6,left: 60),
                    child: Text(authController.emailErrorText.value,style: TextStyle(color: Colors.red,fontSize: 12),textAlign: TextAlign.start,)),
              ),),
              SizedBox(height: 20),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextInputField(
                  controller: _usernameController,
                  myIcon: Icons.person,
                  myLabelText: "User Name",
                  isHide: false,
                ),
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextInputField(
                  controller: _passwordController,
                  myIcon: Icons.lock,
                  myLabelText: "Password",
                  isHide: true,
                ),
              ),
              Obx(() => Visibility(
                visible: authController.passwordErrorVisibility.value,
                child: Container(
                    margin: EdgeInsets.only(top: 6,left: 60),
                    child: Text(authController.passwordErrorText.value,style: TextStyle(color: Colors.red,fontSize: 12),textAlign: TextAlign.start,)),
              ),),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextInputField(
                  controller: _confirmPasswordController,
                  myIcon: Icons.lock,
                  myLabelText: "Confirm Password",
                  isHide: true,
                ),
              ),
              SizedBox(height: 30,),
              GestureDetector(
                onTap: (){
                  String validEmail=authController.validateEmail(_emailController.text);
                  String validPassword=authController.validatePassword(_passwordController.text);
                  if(validEmail=='' && validPassword=='') {
                    authController.signUp(
                        _usernameController.text, _emailController.text,
                        _passwordController.text, authController.proImg);
                  }
                },
                child: Button(btnText: "SIGN UP",),
              )
            ],
          ),
        ),
      ),
    );
  }
}
