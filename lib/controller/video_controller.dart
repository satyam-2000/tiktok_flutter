import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tik_tok/controller/auth_controller.dart';
import 'package:tik_tok/model/video_model.dart';

class VideoController extends GetxController{
  final Rx<List<VideoModel>> _videoList=Rx<List<VideoModel>>([]);

  AuthController authController=Get.put(AuthController());

  // Getter
  List<VideoModel> get videoList=>_videoList.value;
  var likedByUser=false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _videoList.bindStream(FirebaseFirestore.instance.collection('videos').snapshots().map((QuerySnapshot query) {
      List<VideoModel> retVal=[];
      for(var element in query.docs){
        retVal.add(VideoModel.fromSnap(element));
      }
      log(retVal.length.toString());
      return retVal;
    }));
  }


  shareVideo(String vid) async{
    DocumentSnapshot doc=await FirebaseFirestore.instance.collection("videos").doc(vid).get();
    int newShareCount=(doc.data() as dynamic)['share_count']+1;
    await FirebaseFirestore.instance.collection("videos").doc(vid).update(
      {
        'share_count': newShareCount
      }
    );
  }

  likedVideo(String vid) async{
    DocumentSnapshot doc=await FirebaseFirestore.instance.collection('videos').doc(vid).get();
    print(doc.data());
    var uid=authController.user.uid;

    if((doc.data()! as dynamic)['likes'].contains(uid) ){
      likedByUser.value=false;
      await FirebaseFirestore.instance.collection('videos').doc(vid).update({
        'likes':FieldValue.arrayRemove([uid])
      });
    }

    else{
      likedByUser.value=true;
      await FirebaseFirestore.instance.collection('videos').doc(vid).update({
        'likes':FieldValue.arrayUnion([uid])
      });
    }
  }
}