import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tik_tok/view/screens/add_video_screen.dart';
import 'package:tik_tok/view/screens/display_screen.dart';
import 'package:tik_tok/view/screens/profile_screen.dart';
import 'package:tik_tok/view/screens/search_screen.dart';
class HomeController extends GetxController{

  HomeController();




  var pageIndex=0.obs;
  var screens=[
    DisplayScreen(),
    SearchScreen(),
    AddVideoScreen(),
    Center(child: Text('Coming soon in new updates.'),),
    ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid)


  ];
}