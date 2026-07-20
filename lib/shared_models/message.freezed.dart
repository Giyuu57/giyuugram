// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) {
  return _ChatMessage.fromJson(json);
}

/// @nodoc
mixin _$ChatMessage {
  String get id => throw _privateConstructorUsedError;
  String get conversationId => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  String? get content => throw _privateConstructorUsedError;
  String? get mediaUrl => throw _privateConstructorUsedError;
  String get messageType =>
      throw _privateConstructorUsedError; // text | image | video | post_share
  String? get sharedPostId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get senderUsername => throw _privateConstructorUsedError;
  String? get senderAvatarUrl => throw _privateConstructorUsedError;

  /// Serializes this ChatMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatMessageCopyWith<ChatMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageCopyWith<$Res> {
  factory $ChatMessageCopyWith(
          ChatMessage value, $Res Function(ChatMessage) then) =
      _$ChatMessageCopyWithImpl<$Res, ChatMessage>;
  @useResult
  $Res call(
      {String id,
      String conversationId,
      String senderId,
      String? content,
      String? mediaUrl,
      String messageType,
      String? sharedPostId,
      DateTime createdAt,
      String? senderUsername,
      String? senderAvatarUrl});
}

/// @nodoc
class _$ChatMessageCopyWithImpl<$Res, $Val extends ChatMessage>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? senderId = null,
    Object? content = freezed,
    Object? mediaUrl = freezed,
    Object? messageType = null,
    Object? sharedPostId = freezed,
    Object? createdAt = null,
    Object? senderUsername = freezed,
    Object? senderAvatarUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      mediaUrl: freezed == mediaUrl
          ? _value.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      messageType: null == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as String,
      sharedPostId: freezed == sharedPostId
          ? _value.sharedPostId
          : sharedPostId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      senderUsername: freezed == senderUsername
          ? _value.senderUsername
          : senderUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      senderAvatarUrl: freezed == senderAvatarUrl
          ? _value.senderAvatarUrl
          : senderAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatMessageImplCopyWith<$Res>
    implements $ChatMessageCopyWith<$Res> {
  factory _$$ChatMessageImplCopyWith(
          _$ChatMessageImpl value, $Res Function(_$ChatMessageImpl) then) =
      __$$ChatMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String conversationId,
      String senderId,
      String? content,
      String? mediaUrl,
      String messageType,
      String? sharedPostId,
      DateTime createdAt,
      String? senderUsername,
      String? senderAvatarUrl});
}

/// @nodoc
class __$$ChatMessageImplCopyWithImpl<$Res>
    extends _$ChatMessageCopyWithImpl<$Res, _$ChatMessageImpl>
    implements _$$ChatMessageImplCopyWith<$Res> {
  __$$ChatMessageImplCopyWithImpl(
      _$ChatMessageImpl _value, $Res Function(_$ChatMessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? senderId = null,
    Object? content = freezed,
    Object? mediaUrl = freezed,
    Object? messageType = null,
    Object? sharedPostId = freezed,
    Object? createdAt = null,
    Object? senderUsername = freezed,
    Object? senderAvatarUrl = freezed,
  }) {
    return _then(_$ChatMessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      content: freezed == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String?,
      mediaUrl: freezed == mediaUrl
          ? _value.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      messageType: null == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as String,
      sharedPostId: freezed == sharedPostId
          ? _value.sharedPostId
          : sharedPostId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      senderUsername: freezed == senderUsername
          ? _value.senderUsername
          : senderUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      senderAvatarUrl: freezed == senderAvatarUrl
          ? _value.senderAvatarUrl
          : senderAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatMessageImpl implements _ChatMessage {
  const _$ChatMessageImpl(
      {required this.id,
      required this.conversationId,
      required this.senderId,
      this.content,
      this.mediaUrl,
      this.messageType = 'text',
      this.sharedPostId,
      required this.createdAt,
      this.senderUsername,
      this.senderAvatarUrl});

  factory _$ChatMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMessageImplFromJson(json);

  @override
  final String id;
  @override
  final String conversationId;
  @override
  final String senderId;
  @override
  final String? content;
  @override
  final String? mediaUrl;
  @override
  @JsonKey()
  final String messageType;
// text | image | video | post_share
  @override
  final String? sharedPostId;
  @override
  final DateTime createdAt;
  @override
  final String? senderUsername;
  @override
  final String? senderAvatarUrl;

  @override
  String toString() {
    return 'ChatMessage(id: $id, conversationId: $conversationId, senderId: $senderId, content: $content, mediaUrl: $mediaUrl, messageType: $messageType, sharedPostId: $sharedPostId, createdAt: $createdAt, senderUsername: $senderUsername, senderAvatarUrl: $senderAvatarUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.mediaUrl, mediaUrl) ||
                other.mediaUrl == mediaUrl) &&
            (identical(other.messageType, messageType) ||
                other.messageType == messageType) &&
            (identical(other.sharedPostId, sharedPostId) ||
                other.sharedPostId == sharedPostId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.senderUsername, senderUsername) ||
                other.senderUsername == senderUsername) &&
            (identical(other.senderAvatarUrl, senderAvatarUrl) ||
                other.senderAvatarUrl == senderAvatarUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      conversationId,
      senderId,
      content,
      mediaUrl,
      messageType,
      sharedPostId,
      createdAt,
      senderUsername,
      senderAvatarUrl);

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      __$$ChatMessageImplCopyWithImpl<_$ChatMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMessageImplToJson(
      this,
    );
  }
}

abstract class _ChatMessage implements ChatMessage {
  const factory _ChatMessage(
      {required final String id,
      required final String conversationId,
      required final String senderId,
      final String? content,
      final String? mediaUrl,
      final String messageType,
      final String? sharedPostId,
      required final DateTime createdAt,
      final String? senderUsername,
      final String? senderAvatarUrl}) = _$ChatMessageImpl;

  factory _ChatMessage.fromJson(Map<String, dynamic> json) =
      _$ChatMessageImpl.fromJson;

  @override
  String get id;
  @override
  String get conversationId;
  @override
  String get senderId;
  @override
  String? get content;
  @override
  String? get mediaUrl;
  @override
  String get messageType; // text | image | video | post_share
  @override
  String? get sharedPostId;
  @override
  DateTime get createdAt;
  @override
  String? get senderUsername;
  @override
  String? get senderAvatarUrl;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
