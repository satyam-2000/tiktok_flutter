
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tik_tok/model/video_model.dart';
import 'package:tik_tok/view/screens/HomeScreen.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';

class VideoUploadController extends GetxController{
  var uuid=const Uuid(); // Generate random id according to time

  var uploadButtonText='Upload'.obs;

  uploaVideo(String songName,String caption,String videoPath) async{

    try{
      uploadButtonText.value='Please Wait';
      String uid=FirebaseAuth.instance.currentUser!.uid;
      String vid=uuid.v1();
      DocumentSnapshot userDoc=await FirebaseFirestore.instance.collection('users').doc(uid).get();
      String videoURL=await _uploadVideoStorage(vid,videoPath);
      String thumbnail=await _uploadVideoThumbToStorage(vid,videoPath);

      VideoModel videoModel=VideoModel(username: (userDoc.data()! as Map<String,dynamic>)['name'], uid: uid, vid: vid, likes: [], commentCount: 0, shareCount: 0, caption: caption, videoUrl: videoURL, thumbnail: thumbnail, profilePic:(userDoc.data()! as Map<String,dynamic>)['profilePic'],songName: songName );
      await FirebaseFirestore.instance.collection('videos').doc(vid).set(videoModel.toJson());
      Get.snackbar('Video Uploaded Successfully', 'Thanku for sharing your content');
      uploadButtonText.value='Upload';
      Get.offAll(()=>HomeScreen());

    }
    catch(e){
      log(e.toString());
      Get.snackbar('Error Occured', e.toString());
    }

    
  }

   Future<String>_uploadVideoStorage(String videoId,String videoPath) async{
    Reference reference=FirebaseStorage.instance.ref().child('videos').child(videoId);
    UploadTask uploadTask=reference.putFile(await _compressVideo(videoPath));
    TaskSnapshot snapshot=await uploadTask;
    String downloadURL=await snapshot.ref.getDownloadURL();
    return downloadURL;
  }

   _compressVideo(String videoPath) async{

    final compressedVideo=await VideoCompress.compressVideo(videoPath,quality: VideoQuality.MediumQuality);
    return compressedVideo!.file;

   }

   Future<String> _uploadVideoThumbToStorage(String videoId,String videoPath) async{
     Reference reference=FirebaseStorage.instance.ref().child('thumbnails').child(videoId);
     UploadTask uploadTask=reference.putFile(await _getThumb(videoPath));
     TaskSnapshot snapshot=await uploadTask;
     String downloadUrl=await snapshot.ref.getDownloadURL();
     return downloadUrl;
   }

   Future<File> _getThumb(String videoPath) async{
    final thumbnail=await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
   }
}