import 'package:cloud_firestore/cloud_firestore.dart';

class myUser{
  String name;
  String profilePhoto;
  String email;
  String uid;

  myUser(this.name,this.email,this.uid,this.profilePhoto);


  // It will be called When data transfers from App to Firebase
  Map<String,dynamic> toJson(){
    return {
      "name":name,
      "profilePic":profilePhoto,
      "uid":uid,
      "email":email
    };
  }


  // It will be called When data transfers from Firebase to App
  static myUser fromSnap(DocumentSnapshot snap){
    var snapshot=snap.data() as Map<String,dynamic>;

    return myUser(
      snapshot['name'],
      snapshot['email'],
      snapshot['uid'],
      snapshot['profilePic']

    );


  }

}