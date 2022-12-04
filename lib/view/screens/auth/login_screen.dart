import 'package:flutter/material.dart';
import 'package:tik_tok/view/screens/auth/signup_screen.dart';
import 'package:tik_tok/view/widgets/text_input.dart';
import 'package:tik_tok/view/widgets/buttons.dart';
import 'package:get/get.dart';
import 'package:tik_tok/controller/auth_controller.dart';
class LoginScreen extends StatelessWidget {
   LoginScreen({Key? key}) : super(key: key);

  TextEditingController _emailController=new TextEditingController();
   TextEditingController _passwordController=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    AuthController authController=Get.put(AuthController());
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage('assets/splash_logo.png'),width: 110,height: 110,),
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
            SizedBox(height: 30,),
            GestureDetector(
              onTap: (){
                String validEmail=authController.validateEmail(_emailController.text);
                String validPassword=authController.validatePassword(_passwordController.text);
                if(validEmail=='' && validPassword=='') {
                      authController.login(_emailController.text, _passwordController.text);
                }

              },
              child: Button(btnText: "LOGIN",),
            ),
            SizedBox(height: 30,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have account? "),
                GestureDetector(
                    onTap: (){
                      Get.to(SignupScreen());
                    },
                    child: Text('Register Here',style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.w700),))
              ],
            )

          ],
        ),
      ),
    );
  }
}
