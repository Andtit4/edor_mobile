// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ConversationModel _$ConversationModelFromJson(Map<String, dynamic> json) {
  return _ConversationModel.fromJson(json);
}

/// @nodoc
mixin _$ConversationModel {
  String get id => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get prestataireId => throw _privateConstructorUsedError;
  String? get serviceRequestId => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  int get unreadCount => throw _privateConstructorUsedError;
  String? get lastMessageId =>
      throw _privateConstructorUsedError; // Informations des utilisateurs (pour l'affichage)
  String? get clientName => throw _privateConstructorUsedError;
  String? get prestataireName => throw _privateConstructorUsedError;
  String? get clientAvatar => throw _privateConstructorUsedError;
  String? get prestataireAvatar => throw _privateConstructorUsedError;
  String? get lastMessage => throw _privateConstructorUsedError;
  DateTime? get lastMessageTime => throw _privateConstructorUsedError;
  List<MessageModel> get messages => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ConversationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversationModelCopyWith<ConversationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationModelCopyWith<$Res> {
  factory $ConversationModelCopyWith(
    ConversationModel value,
    $Res Function(ConversationModel) then,
  ) = _$ConversationModelCopyWithImpl<$Res, ConversationModel>;
  @useResult
  $Res call({
    String id,
    String clientId,
    String prestataireId,
    String? serviceRequestId,
    bool isActive,
    int unreadCount,
    String? lastMessageId,
    String? clientName,
    String? prestataireName,
    String? clientAvatar,
    String? prestataireAvatar,
    String? lastMessage,
    DateTime? lastMessageTime,
    List<MessageModel> messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$ConversationModelCopyWithImpl<$Res, $Val extends ConversationModel>
    implements $ConversationModelCopyWith<$Res> {
  _$ConversationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? prestataireId = null,
    Object? serviceRequestId = freezed,
    Object? isActive = null,
    Object? unreadCount = null,
    Object? lastMessageId = freezed,
    Object? clientName = freezed,
    Object? prestataireName = freezed,
    Object? clientAvatar = freezed,
    Object? prestataireAvatar = freezed,
    Object? lastMessage = freezed,
    Object? lastMessageTime = freezed,
    Object? messages = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            clientId:
                null == clientId
                    ? _value.clientId
                    : clientId // ignore: cast_nullable_to_non_nullable
                        as String,
            prestataireId:
                null == prestataireId
                    ? _value.prestataireId
                    : prestataireId // ignore: cast_nullable_to_non_nullable
                        as String,
            serviceRequestId:
                freezed == serviceRequestId
                    ? _value.serviceRequestId
                    : serviceRequestId // ignore: cast_nullable_to_non_nullable
                        as String?,
            isActive:
                null == isActive
                    ? _value.isActive
                    : isActive // ignore: cast_nullable_to_non_nullable
                        as bool,
            unreadCount:
                null == unreadCount
                    ? _value.unreadCount
                    : unreadCount // ignore: cast_nullable_to_non_nullable
                        as int,
            lastMessageId:
                freezed == lastMessageId
                    ? _value.lastMessageId
                    : lastMessageId // ignore: cast_nullable_to_non_nullable
                        as String?,
            clientName:
                freezed == clientName
                    ? _value.clientName
                    : clientName // ignore: cast_nullable_to_non_nullable
                        as String?,
            prestataireName:
                freezed == prestataireName
                    ? _value.prestataireName
                    : prestataireName // ignore: cast_nullable_to_non_nullable
                        as String?,
            clientAvatar:
                freezed == clientAvatar
                    ? _value.clientAvatar
                    : clientAvatar // ignore: cast_nullable_to_non_nullable
                        as String?,
            prestataireAvatar:
                freezed == prestataireAvatar
                    ? _value.prestataireAvatar
                    : prestataireAvatar // ignore: cast_nullable_to_non_nullable
                        as String?,
            lastMessage:
                freezed == lastMessage
                    ? _value.lastMessage
                    : lastMessage // ignore: cast_nullable_to_non_nullable
                        as String?,
            lastMessageTime:
                freezed == lastMessageTime
                    ? _value.lastMessageTime
                    : lastMessageTime // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            messages:
                null == messages
                    ? _value.messages
                    : messages // ignore: cast_nullable_to_non_nullable
                        as List<MessageModel>,
            createdAt:
                freezed == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            updatedAt:
                freezed == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ConversationModelImplCopyWith<$Res>
    implements $ConversationModelCopyWith<$Res> {
  factory _$$ConversationModelImplCopyWith(
    _$ConversationModelImpl value,
    $Res Function(_$ConversationModelImpl) then,
  ) = __$$ConversationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String clientId,
    String prestataireId,
    String? serviceRequestId,
    bool isActive,
    int unreadCount,
    String? lastMessageId,
    String? clientName,
    String? prestataireName,
    String? clientAvatar,
    String? prestataireAvatar,
    String? lastMessage,
    DateTime? lastMessageTime,
    List<MessageModel> messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$ConversationModelImplCopyWithImpl<$Res>
    extends _$ConversationModelCopyWithImpl<$Res, _$ConversationModelImpl>
    implements _$$ConversationModelImplCopyWith<$Res> {
  __$$ConversationModelImplCopyWithImpl(
    _$ConversationModelImpl _value,
    $Res Function(_$ConversationModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clientId = null,
    Object? prestataireId = null,
    Object? serviceRequestId = freezed,
    Object? isActive = null,
    Object? unreadCount = null,
    Object? lastMessageId = freezed,
    Object? clientName = freezed,
    Object? prestataireName = freezed,
    Object? clientAvatar = freezed,
    Object? prestataireAvatar = freezed,
    Object? lastMessage = freezed,
    Object? lastMessageTime = freezed,
    Object? messages = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$ConversationModelImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        clientId:
            null == clientId
                ? _value.clientId
                : clientId // ignore: cast_nullable_to_non_nullable
                    as String,
        prestataireId:
            null == prestataireId
                ? _value.prestataireId
                : prestataireId // ignore: cast_nullable_to_non_nullable
                    as String,
        serviceRequestId:
            freezed == serviceRequestId
                ? _value.serviceRequestId
                : serviceRequestId // ignore: cast_nullable_to_non_nullable
                    as String?,
        isActive:
            null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                    as bool,
        unreadCount:
            null == unreadCount
                ? _value.unreadCount
                : unreadCount // ignore: cast_nullable_to_non_nullable
                    as int,
        lastMessageId:
            freezed == lastMessageId
                ? _value.lastMessageId
                : lastMessageId // ignore: cast_nullable_to_non_nullable
                    as String?,
        clientName:
            freezed == clientName
                ? _value.clientName
                : clientName // ignore: cast_nullable_to_non_nullable
                    as String?,
        prestataireName:
            freezed == prestataireName
                ? _value.prestataireName
                : prestataireName // ignore: cast_nullable_to_non_nullable
                    as String?,
        clientAvatar:
            freezed == clientAvatar
                ? _value.clientAvatar
                : clientAvatar // ignore: cast_nullable_to_non_nullable
                    as String?,
        prestataireAvatar:
            freezed == prestataireAvatar
                ? _value.prestataireAvatar
                : prestataireAvatar // ignore: cast_nullable_to_non_nullable
                    as String?,
        lastMessage:
            freezed == lastMessage
                ? _value.lastMessage
                : lastMessage // ignore: cast_nullable_to_non_nullable
                    as String?,
        lastMessageTime:
            freezed == lastMessageTime
                ? _value.lastMessageTime
                : lastMessageTime // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        messages:
            null == messages
                ? _value._messages
                : messages // ignore: cast_nullable_to_non_nullable
                    as List<MessageModel>,
        createdAt:
            freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        updatedAt:
            freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationModelImpl implements _ConversationModel {
  const _$ConversationModelImpl({
    required this.id,
    required this.clientId,
    required this.prestataireId,
    this.serviceRequestId,
    this.isActive = true,
    this.unreadCount = 0,
    this.lastMessageId,
    this.clientName,
    this.prestataireName,
    this.clientAvatar,
    this.prestataireAvatar,
    this.lastMessage,
    this.lastMessageTime,
    final List<MessageModel> messages = const [],
    this.createdAt,
    this.updatedAt,
  }) : _messages = messages;

  factory _$ConversationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationModelImplFromJson(json);

  @override
  final String id;
  @override
  final String clientId;
  @override
  final String prestataireId;
  @override
  final String? serviceRequestId;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final int unreadCount;
  @override
  final String? lastMessageId;
  // Informations des utilisateurs (pour l'affichage)
  @override
  final String? clientName;
  @override
  final String? prestataireName;
  @override
  final String? clientAvatar;
  @override
  final String? prestataireAvatar;
  @override
  final String? lastMessage;
  @override
  final DateTime? lastMessageTime;
  final List<MessageModel> _messages;
  @override
  @JsonKey()
  List<MessageModel> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ConversationModel(id: $id, clientId: $clientId, prestataireId: $prestataireId, serviceRequestId: $serviceRequestId, isActive: $isActive, unreadCount: $unreadCount, lastMessageId: $lastMessageId, clientName: $clientName, prestataireName: $prestataireName, clientAvatar: $clientAvatar, prestataireAvatar: $prestataireAvatar, lastMessage: $lastMessage, lastMessageTime: $lastMessageTime, messages: $messages, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.prestataireId, prestataireId) ||
                other.prestataireId == prestataireId) &&
            (identical(other.serviceRequestId, serviceRequestId) ||
                other.serviceRequestId == serviceRequestId) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.lastMessageId, lastMessageId) ||
                other.lastMessageId == lastMessageId) &&
            (identical(other.clientName, clientName) ||
                other.clientName == clientName) &&
            (identical(other.prestataireName, prestataireName) ||
                other.prestataireName == prestataireName) &&
            (identical(other.clientAvatar, clientAvatar) ||
                other.clientAvatar == clientAvatar) &&
            (identical(other.prestataireAvatar, prestataireAvatar) ||
                other.prestataireAvatar == prestataireAvatar) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.lastMessageTime, lastMessageTime) ||
                other.lastMessageTime == lastMessageTime) &&
            const DeepCollectionEquality().equals(other._messages, _messages) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    clientId,
    prestataireId,
    serviceRequestId,
    isActive,
    unreadCount,
    lastMessageId,
    clientName,
    prestataireName,
    clientAvatar,
    prestataireAvatar,
    lastMessage,
    lastMessageTime,
    const DeepCollectionEquality().hash(_messages),
    createdAt,
    updatedAt,
  );

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationModelImplCopyWith<_$ConversationModelImpl> get copyWith =>
      __$$ConversationModelImplCopyWithImpl<_$ConversationModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationModelImplToJson(this);
  }
}

abstract class _ConversationModel implements ConversationModel {
  const factory _ConversationModel({
    required final String id,
    required final String clientId,
    required final String prestataireId,
    final String? serviceRequestId,
    final bool isActive,
    final int unreadCount,
    final String? lastMessageId,
    final String? clientName,
    final String? prestataireName,
    final String? clientAvatar,
    final String? prestataireAvatar,
    final String? lastMessage,
    final DateTime? lastMessageTime,
    final List<MessageModel> messages,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$ConversationModelImpl;

  factory _ConversationModel.fromJson(Map<String, dynamic> json) =
      _$ConversationModelImpl.fromJson;

  @override
  String get id;
  @override
  String get clientId;
  @override
  String get prestataireId;
  @override
  String? get serviceRequestId;
  @override
  bool get isActive;
  @override
  int get unreadCount;
  @override
  String? get lastMessageId; // Informations des utilisateurs (pour l'affichage)
  @override
  String? get clientName;
  @override
  String? get prestataireName;
  @override
  String? get clientAvatar;
  @override
  String? get prestataireAvatar;
  @override
  String? get lastMessage;
  @override
  DateTime? get lastMessageTime;
  @override
  List<MessageModel> get messages;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationModelImplCopyWith<_$ConversationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
