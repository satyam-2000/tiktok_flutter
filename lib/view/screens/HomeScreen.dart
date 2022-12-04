import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tik_tok/constant.dart';
import 'package:tik_tok/view/widgets/custom_add_icon.dart';
import 'package:tik_tok/controller/homeController.dart';
class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  int pageIndex=0;

  @override
  Widget build(BuildContext context) {
    HomeController homeController=Get.put(HomeController());
    return Obx(() => Scaffold(
        body: homeController.screens[homeController.pageIndex.value],
        bottomNavigationBar: Obx(()=>BottomNavigationBar(
          backgroundColor: backgroundColor,
          currentIndex: homeController.pageIndex.value,
          type: BottomNavigationBarType.fixed,
          onTap: (index){
            homeController.pageIndex.value=index;
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home,size: 25,),label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search,size: 25,),label: 'Search'),
            BottomNavigationBarItem(icon: CustomAddIcon(),label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.message,size: 25,),label: 'Messages'),
            BottomNavigationBarItem(icon: Icon(Icons.person,size: 25,),label: 'Profile'),
          ],
        ))
    ));
  }
}
