import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel{

  String userName;
  String comment;
  final datePub;
  List likes;
  String profilePic;
  String uid;
  String id;

  CommentModel({
    required this.userName,
    required this.comment,
    required this.datePub,
    required this.likes,
    required this.profilePic,
    required this.uid,
    required this.id,
});

   Map<String,dynamic> toJson(){
    return {
      'user_name':userName,
      'comment':comment,
      'date_pub':datePub,
      'likes':likes,
      'profile_pic':profilePic,
      'uid':uid,
      'comment_id':id,
    };
  }

  static CommentModel fromSnap(DocumentSnapshot snapshot){
    var snap=snapshot.data() as Map<String,dynamic>;
    return CommentModel(
      userName: snap['user_name'],
      comment: snap['comment'],
      datePub: snap['date_pub'],
      likes: snap['likes'],
      profilePic: snap['profile_pic'],
      uid: snap['uid'],
      id: snap['comment_id']
    );
  }

}