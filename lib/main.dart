import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:tik_tok/constant.dart';
import 'package:get/get.dart';
import 'package:tik_tok/controller/auth_controller.dart';
import 'package:tik_tok/view/screens/auth/login_screen.dart';
import 'package:tik_tok/view/screens/auth/signup_screen.dart';
import 'package:tik_tok/view/screens/splash_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value){
    Get.put(AuthController());
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tik Tok App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor
      ),
      home:  SplashScreen(),
    );
  }
}

