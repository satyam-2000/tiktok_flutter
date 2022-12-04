import 'dart:developer';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tik_tok/controller/comment_controller.dart';
import 'package:tik_tok/view/widgets/text_input.dart';

class CommentScreen extends StatelessWidget {

  String id;

   CommentScreen({Key? key,required this.id}) : super(key: key);

  TextEditingController _commentController=TextEditingController();
  CommentController controller=Get.put(CommentController());

  @override
  Widget build(BuildContext context) {
    controller.updatePostId(id);
    controller.fetchComment();
    log('items are ${controller.comments.length}');
    return Scaffold(

      body: SingleChildScrollView(
        child: SizedBox(
          width: Get.width,
          height: Get.height,
          child: Column(
            children: [
              Expanded(
                child: Obx(() => ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.comments.length,
                    itemBuilder: (context,index){
                      return ListTile(
                        leading: CircleAvatar(backgroundImage: NetworkImage(controller.comments[index].profilePic),
                          // backgroundColor: Colors.grey,
                        ),
                        title: Row(
                          children: [
                            Text(controller.comments[index].userName,style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.w600,fontSize: 13),),
                            SizedBox(width: 5,),
                            Text(controller.comments[index].comment),
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            Text(timeago.format(controller.comments[index].datePub.toDate())),
                            SizedBox(width: 5,),
                            // Text('${controller.comments[index].likes.length} likes'),
                          ],
                        ),
                        // trailing: InkWell(
                        //     onTap: (){
                        //       log(controller.comments[index].id);
                        //       controller.likeComment(controller.comments[index].id);
                        //     },
                        //     child: Icon(Icons.favorite,
                        //     color: controller.likedComment.value?Colors.pinkAccent:Colors.white,
                        //     )),
                      );
                    }),)
              ),

              ListView.builder(
                  itemCount: 1,
                  shrinkWrap: true,
                  itemBuilder: (context,index){
                    return ListTile(

                        title: TextInputField(controller:_commentController , myIcon: Icons.comment, myLabelText: 'Comment', isHide: false),
                        trailing: TextButton(
                          onPressed: (){
                            controller.postComment(_commentController.text);
                            _commentController.text='';
                          },
                          child: Text('Send',style: TextStyle(color: Colors.redAccent),),
                        )                );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
