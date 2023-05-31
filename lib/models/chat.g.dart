// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
      name: json['name'] as String?,
      id: json['id'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    )..email = json['email'] as String?;

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'id': instance.id,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
