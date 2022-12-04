import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tik_tok/model/user_model.dart';
import 'package:tik_tok/view/screens/auth/login_screen.dart';
import 'package:tik_tok/view/screens/splash_screen.dart';

import '../view/screens/HomeScreen.dart';

class AuthController extends GetxController{



  var emailErrorText=''.obs;
  var emailErrorVisibility=false.obs;
  var passwordErrorText=''.obs;
  var passwordErrorVisibility=false.obs;
  var imageUploaded=false.obs;


  String validateEmail(String email){
    if(email.isEmpty || !email.isEmail){
      emailErrorText.value='Please enter valid email.';
      emailErrorVisibility.value=true;
    }
    else{
      emailErrorText.value='';
      emailErrorVisibility.value=false;
    }
    return emailErrorText.value.toString();
  }

  String validatePassword(String password){
  if(password.isEmpty){
    passwordErrorText.value='Password is required';
    passwordErrorVisibility.value=true;
  }
  else if(password.length<6){
    passwordErrorText.value='Minimum 6 characters required';
    passwordErrorVisibility.value=true;
  }
  else{
    passwordErrorText.value='';
    passwordErrorVisibility.value=false;
  }
  return passwordErrorText.value.toString();
  }

  late File proImg;
   pickImage() async{
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(image==null){
    }
    else{
      final img=File(image.path);
      print(image.path);
      this.proImg=img;
      imageUploaded.value=true;
    }

  }

  // User State Persistence

  late Rx<User?> _user;
  //
  User get user => _user.value!;
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    _user=Rx<User?>(FirebaseAuth.instance.currentUser);
    _user.bindStream(FirebaseAuth.instance.authStateChanges());
    ever(_user, _setInitialView);
  }

  _setInitialView(User? user){
    if(user==null){
      Get.offAll(()=>SplashScreen());
    }
    else{
      Get.offAll(()=>HomeScreen());
    }
  }
  // YHA TAK


  // User Register

  void signUp(
      String userName,
      String email,
      String password,
      File? image
      ) async {
    try{
      if(userName.isNotEmpty && email.isNotEmpty && password.isNotEmpty && image!=null){
        UserCredential credential=await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        String downloadUrl=await _uploadProfilePic(image);
        myUser user=myUser(userName, email, credential.user!.uid, downloadUrl);
        await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set(user.toJson());
        Get.to(LoginScreen());
        Get.snackbar('Successfully Registered','Login to continue');
      }
      else{
        Get.snackbar("Error Creating Account", "Please enter all the required fields");
      }
    }
    on FirebaseAuthException catch(e){
      if ( e.code == 'email-already-in-use') {
        emailErrorText.value='Email already registered';
        emailErrorVisibility.value=true;
      }
    }

  }

  void login(String email,String password) async{
    try{
      if(email.isNotEmpty && password.isNotEmpty){
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        Get.to(HomeScreen());
      }
      else{
        Get.snackbar('Error Occured', 'Please fill all the fields');
      }
    }
    catch(e){
      Get.snackbar('Error occured', e.toString());
    }
  }

  Future<String> _uploadProfilePic(File image) async{
    Reference ref=FirebaseStorage.instance.ref().child('profilePics').child(FirebaseAuth.instance.currentUser!.uid);
    UploadTask uploadTask=ref.putFile(image);
    TaskSnapshot snapshot=await uploadTask;
    String imageDownUrl=await snapshot.ref.getDownloadURL();
    return imageDownUrl;
  }


  // User Login

signout(){
    FirebaseAuth.instance.signOut();
    Get.to(LoginScreen());
}

}