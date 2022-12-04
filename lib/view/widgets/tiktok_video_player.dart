import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:tik_tok/controller/video_controller.dart';
import 'package:tik_tok/view/screens/profile_screen.dart';

import 'package:video_player/video_player.dart';
import 'package:get/get.dart';

import '../screens/comment_screen.dart';

class TikTokVideoPlayer extends StatefulWidget {

  late String videoUrl;
  late String userName;
  late String caption;
  late String songName;
  late String profilePicURL;
  List  likes;
  late String shareCount;
  late String commentcount;
  late String vid;
  late String uid;

  TikTokVideoPlayer({Key? key,required this.videoUrl,required this.userName,required this.caption,required this.songName,required this.profilePicURL,required this.likes,required this.shareCount,required this.commentcount,required this.vid,required this.uid}) : super(key: key);

  @override
  State<TikTokVideoPlayer> createState() => _TikTokVideoPlayerState();
}

class _TikTokVideoPlayerState extends State<TikTokVideoPlayer> {
  late VideoPlayerController videoPlayerController;
  VideoController videoController=Get.put(VideoController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      videoPlayerController=VideoPlayerController.network(widget.videoUrl)..initialize().then((value){
        videoPlayerController.play();
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: InkWell(
        onDoubleTap: (){
          videoController.likedVideo(widget.vid);
        },
        child: Stack(
          children: [
            VideoPlayer(videoPlayerController),
            Container(
              margin: EdgeInsets.only(left: 8,bottom: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.userName,style: TextStyle(fontWeight: FontWeight.w600),),
                  Text(widget.caption),
                  Text(widget.songName,style: TextStyle(fontWeight: FontWeight.w600),),
                ],
              ),
            ),

            Positioned(
              right: 0,
              child: Container(
                margin: EdgeInsets.only(top: Get.height/4,right: 5),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: (){
                        Get.to(ProfileScreen(uid:widget.uid));
                      },
                      child: Container(
                        child: CircleAvatar(backgroundImage: NetworkImage(widget.profilePicURL),
                        radius: 30,
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    InkWell(
                      onTap: (){
                        videoController.likedVideo(widget.vid);
                      },
                      child: Column(
                        children: [
                          Icon(Icons.favorite,size: 45,color: widget.likes.contains(FirebaseAuth.instance.currentUser!.uid)?Colors.pinkAccent:Colors.white,),
                          Text(widget.likes.length.toString())
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    InkWell(
                      onTap: (){
                        share(widget.vid);
                      },
                      child: Column(
                        children: [
                          Icon(Icons.reply,size: 45,color: Colors.white,),
                          Text(widget.shareCount)
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    InkWell(
                      onTap: (){
                        Get.to(() => CommentScreen(id: widget.vid,) );

                      },
                      child: Column(
                        children: [
                          Icon(Icons.comment,size: 45,color: Colors.white,),
                          Text(widget.commentcount)
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),



          ],
        ),
      ),
    );
  }

  Future<void> share(String vid) async {
    await FlutterShare.share(
        title: 'Download My TikTok Clone App',
        text: 'Watch Interesting Videos',
    );
    videoController.shareVideo(vid);
  }
}
