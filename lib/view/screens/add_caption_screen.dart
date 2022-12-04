import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tik_tok/controller/upload_video_controller.dart';
import 'package:tik_tok/view/widgets/buttons.dart';
import 'package:tik_tok/view/widgets/text_input.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';

class AddCaptionScreen extends StatefulWidget {

  File videoFile;
  String videoPath;


   AddCaptionScreen({Key? key,required this.videoFile,required this.videoPath}) : super(key: key);

  @override
  State<AddCaptionScreen> createState() => _AddCaptionScreenState();
}

class _AddCaptionScreenState extends State<AddCaptionScreen> {
  late VideoPlayerController videoPlayerController;
  TextEditingController songNameController=TextEditingController();
  TextEditingController captionController=TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      videoPlayerController=VideoPlayerController.file(widget.videoFile);
    });
    videoPlayerController.initialize();
    videoPlayerController.play();
    videoPlayerController.setLooping(true);
    videoPlayerController.setVolume(0.7);
  }

  @override
  Widget build(BuildContext context) {
    VideoUploadController videoUploadController=Get.put(VideoUploadController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/1.5,
              child:VideoPlayer(videoPlayerController),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
              width: MediaQuery.of(context).size.width,
              child:Column(
                children: [
                  TextInputField(
                    controller:songNameController,
                    myIcon: Icons.music_note,
                    myLabelText: 'Song Name',
                    isHide: false,
                  ),
                  SizedBox(height: 20,),
                  TextInputField(
                    isHide: false,
                    controller:captionController ,
                    myIcon: Icons.closed_caption,
                    myLabelText: 'Caption',
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(onPressed: (){
                    videoUploadController.uploaVideo(songNameController.text, captionController.text, widget.videoPath);

                  }, child: Obx(() => Text(videoUploadController.uploadButtonText.value)),style: ElevatedButton.styleFrom(primary: Colors.redAccent),)
                  
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
