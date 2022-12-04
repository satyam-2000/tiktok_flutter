import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tik_tok/model/comment_model.dart';
class CommentController extends GetxController{

  String _postId='';
  var likedComment=false.obs;
  final Rx<List<CommentModel>> _comment=Rx<List<CommentModel>>([]);
  List<CommentModel> get comments => _comment.value;
  updatePostId(String id){
    _postId=id;
    fetchComment();

  }

  fetchComment() async{
    _comment.bindStream(FirebaseFirestore.instance.collection('videos').doc(_postId).collection('comments').snapshots().map((QuerySnapshot query){

      List<CommentModel> retVal=[];
      for(var element in query.docs) {
        retVal.add(CommentModel.fromSnap(element));
      }
      return retVal;
    }

     ));
  }


  postComment(String commentText) async{

    if(commentText.isNotEmpty) {
      DocumentSnapshot userDoc=await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();

      var allDocs=await FirebaseFirestore.instance.collection("videos").doc(_postId).collection("comments").get();
      int len=allDocs.docs.length;

      CommentModel commentModel=CommentModel(userName: (userDoc.data() as dynamic)["name"], comment: commentText.trim(), datePub: DateTime.now(), likes: [], profilePic: (userDoc.data() as dynamic)['profilePic'], uid: FirebaseAuth.instance.currentUser!.uid,id: 'Comment $len');
      await FirebaseFirestore.instance.collection("videos").doc(_postId).collection("comments").doc("comment $len").set(commentModel.toJson());

      DocumentSnapshot videoDoc=await FirebaseFirestore.instance.collection('videos').doc(_postId).get();

      await FirebaseFirestore.instance.collection('videos').doc(_postId).update({
        'comment_count':(videoDoc.data() as dynamic)['comment_count']+1
      });


    }

  }


  likeComment(String id) async{

    var uid=FirebaseAuth.instance.currentUser!.uid;
    print(_postId);

    DocumentSnapshot doc=await FirebaseFirestore.instance.collection("videos").doc(_postId).collection("comments").doc(id).get();
    print(doc.data());
    if((doc.data() as dynamic)['likes'].contains(uid)){
      await FirebaseFirestore.instance.collection('videos').doc(_postId).collection('comments').doc(id).update({
        'likes' : FieldValue.arrayRemove([uid]),
      });
    }else{
      await FirebaseFirestore.instance.collection('videos').doc(_postId).collection('comments').doc(id).update({
        'likes' : FieldValue.arrayUnion([uid]),
      });
    }



  }

}