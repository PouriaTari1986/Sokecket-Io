

import 'package:flutter/material.dart';
import 'package:flutter_application_1/chat_screen.dart';
import 'package:flutter_application_1/gen/assets.gen.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({super.key});
final nameTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal:30 ),
        children: [

          Assets.logo.image(),
          TextField(
            controller: nameTextController,
            decoration: InputDecoration(hintText: "نام خود را وارد نمایید",hintStyle: TextStyle(color: Colors.black.withAlpha(120))),
          ),SizedBox(height: 20,),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateColor.resolveWith((value){
                if (value.contains(WidgetState.pressed)) {
                  return Color.fromARGB(255, 64, 32, 151);
                }return Color.fromARGB(255, 37, 11, 110);
              })
            ),
            onPressed: () {
              String name = nameTextController.text.trim();
              if (name.isNotEmpty) {
                Navigator.of(context).push(MaterialPageRoute(builder: (c)=>ChatScreen(name: name,)));
              }
            }, 
            child: Text("ورود به چت",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.normal),))
        ],
      ),
    ));
  }
}