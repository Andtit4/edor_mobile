// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConversationModelImpl _$$ConversationModelImplFromJson(
  Map<String, dynamic> json,
) => _$ConversationModelImpl(
  id: json['id'] as String,
  clientId: json['clientId'] as String,
  prestataireId: json['prestataireId'] as String,
  serviceRequestId: json['serviceRequestId'] as String?,
  isActive: json['isActive'] as bool? ?? true,
  unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
  lastMessageId: json['lastMessageId'] as String?,
  clientName: json['clientName'] as String?,
  prestataireName: json['prestataireName'] as String?,
  clientAvatar: json['clientAvatar'] as String?,
  prestataireAvatar: json['prestataireAvatar'] as String?,
  lastMessage: json['lastMessage'] as String?,
  lastMessageTime:
      json['lastMessageTime'] == null
          ? null
          : DateTime.parse(json['lastMessageTime'] as String),
  messages:
      (json['messages'] as List<dynamic>?)
          ?.map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$ConversationModelImplToJson(
  _$ConversationModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'clientId': instance.clientId,
  'prestataireId': instance.prestataireId,
  'serviceRequestId': instance.serviceRequestId,
  'isActive': instance.isActive,
  'unreadCount': instance.unreadCount,
  'lastMessageId': instance.lastMessageId,
  'clientName': instance.clientName,
  'prestataireName': instance.prestataireName,
  'clientAvatar': instance.clientAvatar,
  'prestataireAvatar': instance.prestataireAvatar,
  'lastMessage': instance.lastMessage,
  'lastMessageTime': instance.lastMessageTime?.toIso8601String(),
  'messages': instance.messages,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
