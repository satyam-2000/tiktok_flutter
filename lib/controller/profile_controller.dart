import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController{





  var _uid="".obs;
  bool isFollowing=false;
  final Rx<Map<String,dynamic>> _users=Rx<Map<String,dynamic>>({});

  Map<String,dynamic> get users => _users.value;

  updateUserId(String uid){
    _uid.value=uid;
    getUserData();
  }

  getUserData() async{

    List<String> thumbnails=[];
    var myVideos=await FirebaseFirestore.instance.collection("videos").where("uid",isEqualTo: _uid.value).get();

    for(int i=0;i<myVideos.docs.length;i++){
      thumbnails.add((myVideos.docs[i].data() as dynamic)['thumbnail']);
    }

    DocumentSnapshot userDoc=await FirebaseFirestore.instance.collection("users").doc(_uid.value).get();

    final userData=userDoc.data() as dynamic;

    String name=userData['name'];
    String profilePic=userData['profilePic'];
    int likes=0;
    int followers=0;
    int following=0;

    for(var items in myVideos.docs){
      likes+=(items.data()['likes'] as List).length;
    }

    var followerDoc=await FirebaseFirestore.instance.collection("users").doc(_uid.value).collection("followers").get();
    var followingDoc= await FirebaseFirestore.instance.collection("users").doc(_uid.value).collection("following").get();

    followers=followerDoc.docs.length;
    following=followingDoc.docs.length;

    FirebaseFirestore.instance.collection("users").doc(_uid.value).collection("followers").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value){
      if(value.exists){
        //Follow karta hai
        isFollowing=true;
      }

      else{
        // Follow ni krta hai
        isFollowing=false;
      }
    });

    _users.value={
      'followers':followers.toString(),
      'following':following.toString(),
      'likes':likes.toString(),
      'profilePic':profilePic,
      'name':name,
      'thumbnails':thumbnails,
      'isFollowing':isFollowing
    };

    update();



  }

  followUser() async{

    var doc=await FirebaseFirestore.instance.collection("users").doc(_uid.value).collection("followers").doc(FirebaseAuth.instance.currentUser!.uid).get();

    if(!doc.exists){
      await FirebaseFirestore.instance.collection("users").doc(_uid.value).collection("followers").doc(FirebaseAuth.instance.currentUser!.uid).set({});
      await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("following").doc(_uid.value).set({});

      _users.value.update('followers', (value) => (int.parse(value) + 1).toString());
    }

    else{
      await FirebaseFirestore.instance.collection("users").doc(_uid.value).collection("followers").doc(FirebaseAuth.instance.currentUser!.uid).delete();
      await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("following").doc( _uid.value).delete();

      _users.value.update('followers', (value) => (int.parse(value) - 1).toString());

    }

    _users.value.update('isFollowing', (value) => !value);
    update();



  }

}