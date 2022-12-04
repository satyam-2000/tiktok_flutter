import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tik_tok/controller/search_controller.dart';
import 'package:tik_tok/model/user_model.dart';
import 'package:tik_tok/view/screens/profile_screen.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);
  TextEditingController searchUser=TextEditingController();

  @override
  Widget build(BuildContext context) {
    SearchController searchController=Get.put(SearchController());
    return Obx(() => Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFE2C55),
          title: Container(
            margin: EdgeInsets.only(bottom: 5),
            child: TextField(
              onChanged: (value){
                searchController.searchUser(value);
              },
              controller: searchUser,
              decoration: InputDecoration(
                border: InputBorder.none,
                  icon: Icon(Icons.search,color: Colors.white,),
                  hintText: 'Search @UserName',
                  hintStyle: TextStyle(color: Colors.white)
              ),
            ),
          ),
        ),
        body: searchController.searchedUser.isEmpty? Center(
          child: Text('Search User'),
        ):
        ListView.builder(
            itemCount:searchController.searchedUser.isNotEmpty? searchController.searchedUser.length:0,
            itemBuilder: (context,index){
              myUser user=searchController.searchedUser[index];

              return ListTile(
                onTap: (){
                  Get.to(ProfileScreen(uid: user.uid));
                },
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.profilePhoto),

                ),
                title: Text(user.name),
              );
            })


    ));
  }
}
