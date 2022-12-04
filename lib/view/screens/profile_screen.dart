import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tik_tok/controller/auth_controller.dart';
import 'package:tik_tok/controller/profile_controller.dart';
import 'package:tik_tok/view/widgets/buttons.dart';
import 'package:get/get.dart';



class ProfileScreen extends StatefulWidget {
  String uid;
  ProfileScreen({Key? key,required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileController profileController=Get.put(ProfileController());
  AuthController authController=Get.put(AuthController());

  @override
  void initState() {
    // TODO: implement initState
    profileController.updateUserId(widget.uid);
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return profileController.users['name']==null ?


        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: CircularProgressIndicator()),
            SizedBox(height: 10,),
            Center(child: Text('Fetching Details. Retry in 10 seconds'),)
          ],
        ) :
    Scaffold(

      appBar: AppBar(
        backgroundColor: Color(0xFFFE2C55),
        title: Obx(() => Text('@${profileController.users['name']}'),),
        centerTitle: true,
        actions: [
          Container(
              margin: EdgeInsets.only(right: 10),
              child: IconButton(
                icon: Icon(Icons.info_outline_rounded),
                onPressed: (){
                  Get.snackbar('TikTok Clone App', 'Current Version is 1.0');
                },
              ))
        ],
      ),
      body:Obx(() =>profileController.users.isEmpty?Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: CircularProgressIndicator()),
          SizedBox(height: 10,),
          Center(child: Text('Fetching Details. Retry in 10 seconds'),)
        ],
      ):SingleChildScrollView(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20,),
            Center(
              child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(profileController.users['profilePic'])
              ),
            ),
            SizedBox(height: 20,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text('Likes',style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    Text(profileController.users['likes']),
                  ],
                ),
                SizedBox(width: 20,),
                Column(
                  children: [
                    Text('Following',style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    Text(profileController.users['following']),
                  ],
                ),
                SizedBox(width: 20,),
                Column(
                  children: [
                    Text('Followers',style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    Text(profileController.users['followers']),
                  ],
                ),

              ],
            ),
            SizedBox(height: 20,),

            InkWell(
              onTap: (){

                if(widget.uid==FirebaseAuth.instance.currentUser!.uid){
                  authController.signout();
                }
                else{
                  profileController.followUser();

                }

              },
              child: Button(btnText: widget.uid == FirebaseAuth.instance.currentUser!.uid ? 'LOG OUT':
              profileController.isFollowing?'UNFOLLOW':'FOLLOW'
              ),
            ),
            SizedBox(height: 20,),

            Divider(indent: 30,endIndent: 30,thickness: 2,),
            SizedBox(height: 20,),

            SizedBox(
              height: 300,
              child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 1
              ),
                  itemCount: profileController.users['thumbnails'].length,
                  itemBuilder: (context,index){
                String thumbUrl=profileController.users['thumbnails'][index];
                return Image(
                    fit: BoxFit.cover,
                    image: NetworkImage(thumbUrl));
                  }),
            )



          ],
        ),
      )) ,
    );
  }
}

