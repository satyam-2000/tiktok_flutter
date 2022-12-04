import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tik_tok/controller/video_controller.dart';

import '../widgets/tiktok_video_player.dart';

class DisplayScreen extends StatelessWidget {

  const DisplayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VideoController videoController=Get.put(VideoController());
    print('hii ${videoController.videoList.length}');
    return Scaffold(
      body: Obx(() => PageView.builder(
          scrollDirection: Axis.vertical,
          controller: PageController(initialPage: 0,viewportFraction: 1),
          itemCount: videoController.videoList.length,
          itemBuilder:(context,index){
            var data=videoController.videoList[index];
            return TikTokVideoPlayer(videoUrl: data.videoUrl, userName: data.username, caption: data.caption, songName: data.songName, profilePicURL:data.profilePic,likes: data.likes,shareCount: data.shareCount.toString(),commentcount: data.commentCount.toString(),vid: data.vid,uid: data.uid,);
          } ),)
    );
  }
}
