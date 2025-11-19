
import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_application_1/message_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;


class AppSocket{

  socket_io.Socket? socket;

  final List<MessageModel> _messages = <MessageModel>[];

  StreamController<List<MessageModel>>streamOfMessage =StreamController.broadcast();

  void init(){
    String server ='';
    if (Platform.isAndroid) {
      server = 'ws://10.0.2.2:3900';
    } else if(Platform.isIOS){
      server = 'ws://127.0.0.1:3900';
    }
    socket = socket_io.io(server,socket_io.OptionBuilder().setTransports(['websocket']).
    enableReconnection()
    .enableForceNew()
    .enableForceNewConnection()
    .build()
    );
    socket!.connect();
    socket!.onConnect((value){
      log("connect");

    });
    socket!.on('chat', (data){
      log(data.toString());
      var messages =MessageModel.fromJson(data);
      _messages.add(messages);
      streamOfMessage.add(_messages);
    });
  }
  void sendMessage(MessageModel message) {
    _messages.add(message);
    streamOfMessage.add(_messages);

    socket!.emit('chat',message.toJson());
  }
}