// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Conversation _$ConversationFromJson(Map<String, dynamic> json) {
  return _Conversation.fromJson(json);
}

/// @nodoc
mixin _$Conversation {
  String get id => throw _privateConstructorUsedError;
  bool get isGroup => throw _privateConstructorUsedError;
  String? get groupName => throw _privateConstructorUsedError;
  String? get groupAvatarUrl => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get lastMessageAt =>
      throw _privateConstructorUsedError; // Joined/derived fields for the chat list UI
  String? get otherUserId => throw _privateConstructorUsedError;
  String? get otherUsername => throw _privateConstructorUsedError;
  String? get otherAvatarUrl => throw _privateConstructorUsedError;
  String? get lastMessagePreview => throw _privateConstructorUsedError;
  int get unreadCount => throw _privateConstructorUsedError;

  /// Serializes this Conversation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversationCopyWith<Conversation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationCopyWith<$Res> {
  factory $ConversationCopyWith(
          Conversation value, $Res Function(Conversation) then) =
      _$ConversationCopyWithImpl<$Res, Conversation>;
  @useResult
  $Res call(
      {String id,
      bool isGroup,
      String? groupName,
      String? groupAvatarUrl,
      DateTime createdAt,
      DateTime lastMessageAt,
      String? otherUserId,
      String? otherUsername,
      String? otherAvatarUrl,
      String? lastMessagePreview,
      int unreadCount});
}

/// @nodoc
class _$ConversationCopyWithImpl<$Res, $Val extends Conversation>
    implements $ConversationCopyWith<$Res> {
  _$ConversationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? isGroup = null,
    Object? groupName = freezed,
    Object? groupAvatarUrl = freezed,
    Object? createdAt = null,
    Object? lastMessageAt = null,
    Object? otherUserId = freezed,
    Object? otherUsername = freezed,
    Object? otherAvatarUrl = freezed,
    Object? lastMessagePreview = freezed,
    Object? unreadCount = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      isGroup: null == isGroup
          ? _value.isGroup
          : isGroup // ignore: cast_nullable_to_non_nullable
              as bool,
      groupName: freezed == groupName
          ? _value.groupName
          : groupName // ignore: cast_nullable_to_non_nullable
              as String?,
      groupAvatarUrl: freezed == groupAvatarUrl
          ? _value.groupAvatarUrl
          : groupAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastMessageAt: null == lastMessageAt
          ? _value.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      otherUserId: freezed == otherUserId
          ? _value.otherUserId
          : otherUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      otherUsername: freezed == otherUsername
          ? _value.otherUsername
          : otherUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      otherAvatarUrl: freezed == otherAvatarUrl
          ? _value.otherAvatarUrl
          : otherAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessagePreview: freezed == lastMessagePreview
          ? _value.lastMessagePreview
          : lastMessagePreview // ignore: cast_nullable_to_non_nullable
              as String?,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConversationImplCopyWith<$Res>
    implements $ConversationCopyWith<$Res> {
  factory _$$ConversationImplCopyWith(
          _$ConversationImpl value, $Res Function(_$ConversationImpl) then) =
      __$$ConversationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      bool isGroup,
      String? groupName,
      String? groupAvatarUrl,
      DateTime createdAt,
      DateTime lastMessageAt,
      String? otherUserId,
      String? otherUsername,
      String? otherAvatarUrl,
      String? lastMessagePreview,
      int unreadCount});
}

/// @nodoc
class __$$ConversationImplCopyWithImpl<$Res>
    extends _$ConversationCopyWithImpl<$Res, _$ConversationImpl>
    implements _$$ConversationImplCopyWith<$Res> {
  __$$ConversationImplCopyWithImpl(
      _$ConversationImpl _value, $Res Function(_$ConversationImpl) _then)
      : super(_value, _then);

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? isGroup = null,
    Object? groupName = freezed,
    Object? groupAvatarUrl = freezed,
    Object? createdAt = null,
    Object? lastMessageAt = null,
    Object? otherUserId = freezed,
    Object? otherUsername = freezed,
    Object? otherAvatarUrl = freezed,
    Object? lastMessagePreview = freezed,
    Object? unreadCount = null,
  }) {
    return _then(_$ConversationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      isGroup: null == isGroup
          ? _value.isGroup
          : isGroup // ignore: cast_nullable_to_non_nullable
              as bool,
      groupName: freezed == groupName
          ? _value.groupName
          : groupName // ignore: cast_nullable_to_non_nullable
              as String?,
      groupAvatarUrl: freezed == groupAvatarUrl
          ? _value.groupAvatarUrl
          : groupAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastMessageAt: null == lastMessageAt
          ? _value.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      otherUserId: freezed == otherUserId
          ? _value.otherUserId
          : otherUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      otherUsername: freezed == otherUsername
          ? _value.otherUsername
          : otherUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      otherAvatarUrl: freezed == otherAvatarUrl
          ? _value.otherAvatarUrl
          : otherAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessagePreview: freezed == lastMessagePreview
          ? _value.lastMessagePreview
          : lastMessagePreview // ignore: cast_nullable_to_non_nullable
              as String?,
      unreadCount: null == unreadCount
          ? _value.unreadCount
          : unreadCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationImpl implements _Conversation {
  const _$ConversationImpl(
      {required this.id,
      this.isGroup = false,
      this.groupName,
      this.groupAvatarUrl,
      required this.createdAt,
      required this.lastMessageAt,
      this.otherUserId,
      this.otherUsername,
      this.otherAvatarUrl,
      this.lastMessagePreview,
      this.unreadCount = 0});

  factory _$ConversationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey()
  final bool isGroup;
  @override
  final String? groupName;
  @override
  final String? groupAvatarUrl;
  @override
  final DateTime createdAt;
  @override
  final DateTime lastMessageAt;
// Joined/derived fields for the chat list UI
  @override
  final String? otherUserId;
  @override
  final String? otherUsername;
  @override
  final String? otherAvatarUrl;
  @override
  final String? lastMessagePreview;
  @override
  @JsonKey()
  final int unreadCount;

  @override
  String toString() {
    return 'Conversation(id: $id, isGroup: $isGroup, groupName: $groupName, groupAvatarUrl: $groupAvatarUrl, createdAt: $createdAt, lastMessageAt: $lastMessageAt, otherUserId: $otherUserId, otherUsername: $otherUsername, otherAvatarUrl: $otherAvatarUrl, lastMessagePreview: $lastMessagePreview, unreadCount: $unreadCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.isGroup, isGroup) || other.isGroup == isGroup) &&
            (identical(other.groupName, groupName) ||
                other.groupName == groupName) &&
            (identical(other.groupAvatarUrl, groupAvatarUrl) ||
                other.groupAvatarUrl == groupAvatarUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastMessageAt, lastMessageAt) ||
                other.lastMessageAt == lastMessageAt) &&
            (identical(other.otherUserId, otherUserId) ||
                other.otherUserId == otherUserId) &&
            (identical(other.otherUsername, otherUsername) ||
                other.otherUsername == otherUsername) &&
            (identical(other.otherAvatarUrl, otherAvatarUrl) ||
                other.otherAvatarUrl == otherAvatarUrl) &&
            (identical(other.lastMessagePreview, lastMessagePreview) ||
                other.lastMessagePreview == lastMessagePreview) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      isGroup,
      groupName,
      groupAvatarUrl,
      createdAt,
      lastMessageAt,
      otherUserId,
      otherUsername,
      otherAvatarUrl,
      lastMessagePreview,
      unreadCount);

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationImplCopyWith<_$ConversationImpl> get copyWith =>
      __$$ConversationImplCopyWithImpl<_$ConversationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationImplToJson(
      this,
    );
  }
}

abstract class _Conversation implements Conversation {
  const factory _Conversation(
      {required final String id,
      final bool isGroup,
      final String? groupName,
      final String? groupAvatarUrl,
      required final DateTime createdAt,
      required final DateTime lastMessageAt,
      final String? otherUserId,
      final String? otherUsername,
      final String? otherAvatarUrl,
      final String? lastMessagePreview,
      final int unreadCount}) = _$ConversationImpl;

  factory _Conversation.fromJson(Map<String, dynamic> json) =
      _$ConversationImpl.fromJson;

  @override
  String get id;
  @override
  bool get isGroup;
  @override
  String? get groupName;
  @override
  String? get groupAvatarUrl;
  @override
  DateTime get createdAt;
  @override
  DateTime get lastMessageAt; // Joined/derived fields for the chat list UI
  @override
  String? get otherUserId;
  @override
  String? get otherUsername;
  @override
  String? get otherAvatarUrl;
  @override
  String? get lastMessagePreview;
  @override
  int get unreadCount;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationImplCopyWith<_$ConversationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
