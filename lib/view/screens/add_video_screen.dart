import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tik_tok/constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tik_tok/view/screens/add_caption_screen.dart';

class AddVideoScreen extends StatelessWidget {
  const AddVideoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          Image(image: AssetImage('assets/splash_logo.png'),width: 150,height: 150,),
          
          
          Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: buttonColor,
              borderRadius: BorderRadius.circular(10)
            ),

            child: InkWell(
              onTap: (){
                showDialogOpt(context);
              },
              child: Text('Upload Video',style: TextStyle(fontSize: 25),),
            ),
          ),
        ],
      )
    );
  }

  pickVideo(ImageSource source,BuildContext context) async {
    final video=await ImagePicker().pickVideo(source: source);
    if(video!=null){
      Get.snackbar('Video Upload', video.path);
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return AddCaptionScreen(videoFile: File(video.path), videoPath: video.path);
      }));
    }
    else{
      Get.snackbar('Error Ocuured', 'Please choose different video');
    }
  }

  showDialogOpt(BuildContext context){
    return showDialog(context: context, builder: (context)=>
        SimpleDialog(
          title: Center(child: Text('Choose Options',style: TextStyle(color: Colors.black),)),
          backgroundColor: Colors.white,
          children: [
            SimpleDialogOption(
              onPressed: ()=>pickVideo(ImageSource.gallery,context),
              child: Center(child: const Text("Gallery",style: TextStyle(color: Colors.blue,fontSize: 17),)),
            ),
            SimpleDialogOption(
              onPressed: ()=>pickVideo(ImageSource.camera,context),
              child: Center(child: const Text("Camera",style: TextStyle(color: Colors.blue,fontSize: 17))),
            ),
            SimpleDialogOption(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Center(child: Container(
                  padding: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.red
                  ),
                  child:const Text("Close",style: TextStyle(color: Colors.white)))),
            )
          ],
        ));
  }
}
