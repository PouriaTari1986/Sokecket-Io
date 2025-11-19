

class MessageModel{

  final String name;
  final String message;
  final MessageType type;
  final bool isSender;
 const MessageModel({required this.name,required this.message,required this.type,required this.isSender,});

factory MessageModel.fromJson(Map<String, dynamic> json){
  return MessageModel(
  name: json['name'] as String, 
  message: json['message'] as String, 
  type: MessageType.values[json ['type'] as int], 
  isSender: json['isSender'] as bool
  );
}

Map<String,dynamic> toJson(){
  return{
    'name': name ,
    'message': message ,
    'type':  type.index,
    'isSender':  isSender,
  };
}
}
enum MessageType{text,image,doc,video}