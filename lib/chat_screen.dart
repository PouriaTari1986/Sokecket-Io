

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';
import 'package:flutter_application_1/message_model.dart';
import 'package:flutter_application_1/socket.dart';

String _name= '';
final _socket = AppSocket();
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.name});
final String name;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
final textController = TextEditingController();
List<MessageModel>messages = <MessageModel>[];
  @override
  void initState() {
    super.initState();
    _name= widget.name;
    _socket.init();
    log(_name);
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        shadowColor: Color.fromARGB(90, 0, 0, 0),
        title: Align(
          alignment: Alignment.centerRight,
          child: Text("ورود به چت")),
      ),

      body: Stack(
        children: [

          Positioned.fill(child: Assets.bg.image(fit: BoxFit.fill),),
          StreamBuilder<List<MessageModel>>(stream:
           _socket.streamOfMessage.stream, builder: (context, snapshot) {
            var messages = snapshot.data??[];
            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return getMessageWiget(messages[index]);
            },);
          },)
        ],
      ),
      bottomSheet: TextField(
        controller: textController,
        textInputAction: TextInputAction.send,
        decoration: InputDecoration(hintText: "....متن پیام",
        fillColor: Colors.white,filled: true,
        suffixIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                secd(textController.text);
                textController.clear();
              }
            } , 
            icon: Icon(Icons.send_rounded)),
          
        ),prefixIcon: IconButton(
          onPressed: ()=>showFileBottumSheet(context), 
          icon: Icon(Icons.attachment_rounded,size: 33,))
      )
    )
    )
    );
  }
  void secd(String message,[MessageType type = MessageType.text]){

    _socket.sendMessage(MessageModel(name: _name, message: message, type: type, isSender: true));
  }



  void showFileBottumSheet(BuildContext context){

    showModalBottomSheet(context: context, builder: (context) {

      return Container(
        height: 100,
        color: Colors.black12,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AttachmentIconButtom(icon: Icons.image_outlined, title: "Image",
            onPressed: () {
              secd("url",MessageType.image);
            },),
            AttachmentIconButtom(icon: Icons.document_scanner_outlined, title: 'Document',),
            AttachmentIconButtom(icon: Icons.video_file_outlined, title: 'Video',),
           
            
          ],
        ),
      );
      
    },);
  }
  
Widget getMessageWiget(MessageModel messages){

  switch (messages.type) {
    case MessageType.text:
    return _TextMessage(messageModel: messages);

      
    case MessageType.image:
   return _ImageMessageWidget(messageModel: messages);

      
    case MessageType.video:


      break;
    case MessageType.doc:


     
  
      
 }
 return SizedBox();
 }
}

class _ImageMessageWidget extends StatelessWidget {
  const _ImageMessageWidget({ required this.messageModel});
final MessageModel messageModel;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: messageModel.isSender?Alignment.centerRight:Alignment.centerLeft ,
      child: Container(
        width: MediaQuery.of(context).size.width*.6,
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(left: 8,right: 8,top: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: messageModel.isSender?Color.fromARGB(255, 240, 249, 161):
          Colors.white
        ),
        child: Image.network(messageModel.message),
      ),
    );
  }
}



// ignore: must_be_immutable
class AttachmentIconButtom extends StatelessWidget {
IconData icon;
String title;
Function()? onPressed;
   AttachmentIconButtom({
    super.key, required this.icon, required this.title, this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(onPressed: onPressed, icon: Column(
        children: [
          Icon(icon),
          Text(title),
        ],
      )),
    );
  }
}
class _TextMessage extends StatelessWidget {
  
  const _TextMessage({required this.messageModel});
final MessageModel messageModel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 8),
      child: Align(
        alignment: messageModel.isSender?Alignment.centerRight:Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: messageModel.isSender?const Color.fromARGB(255, 240, 249, 161):Colors.white
          ),
          padding: EdgeInsets.all(8),
          child: Column(
      
            children: [
              if(!messageModel.isSender)...[
                Text(messageModel.name,style: TextStyle(color: Colors.grey),)
              ],
              Text(messageModel.message,style:TextStyle(color: Colors.black) ,)
            ],
          ),
        ),
      ),
    );
  }
}