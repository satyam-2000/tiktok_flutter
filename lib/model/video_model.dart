import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class VideoModel{
  String username;
  String uid;
  String vid;
  List likes;
  int commentCount;
  int shareCount;
  String caption;
  String videoUrl;
  String thumbnail;
  String profilePic;
  String songName;

  VideoModel({
    required this.username,
    required this.uid,
    required this.vid,
    required this.likes,
    required this.commentCount,
    required this.shareCount,
    required this.caption,
    required this.videoUrl,
    required this.thumbnail,
    required this.profilePic,
    required this.songName
});

  Map<String,dynamic> toJson(){
    return {
      'name':username,
      'uid':uid,
      'video id':vid,
      'likes':likes,
      'comment_count':commentCount,
      'share_count':shareCount,
      'caption':caption,
      'video_url':videoUrl,
      'thumbnail':thumbnail,
      'profile_pic':profilePic,
      'song_name':songName
    };
  }

  static VideoModel fromSnap(DocumentSnapshot snap){
    var snapshot=snap.data() as Map<String,dynamic>;

    return VideoModel(
        username:snapshot['name'],
        uid:snapshot['uid'],
        vid:snapshot['video id'],
        likes:snapshot['likes'],
        commentCount:snapshot['comment_count'],
        shareCount:snapshot['share_count'],
        caption:snapshot['caption'],
        videoUrl:snapshot['video_url'],
        thumbnail:snapshot['thumbnail'],
        profilePic:snapshot['profile_pic'],
        songName: snapshot['song_name']

    );


  }

}


