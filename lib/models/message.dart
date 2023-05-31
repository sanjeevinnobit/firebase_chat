import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  String? id;
  String? message;
  String? sender;
  String? receiver;
  DateTime? time;

  Message({
    this.id,
    this.message,
    this.receiver,
    this.sender,
    this.time,
  });

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}
