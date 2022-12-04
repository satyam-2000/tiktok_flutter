import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tik_tok/model/user_model.dart';

class SearchController extends GetxController{

  final Rx<List<myUser>> _searchUsers= Rx<List<myUser>>([]);

  List<myUser> get searchedUser => _searchUsers.value;

  searchUser(String query) async{

    _searchUsers.bindStream(
      FirebaseFirestore.instance.collection("users").where("name",isGreaterThanOrEqualTo: query).snapshots().map((QuerySnapshot querySnapshot){

        List<myUser> retVal=[];
        for(var element in querySnapshot.docs ){
          retVal.add(myUser.fromSnap(element));
        }

        return retVal;

      } )
    );

  }


}