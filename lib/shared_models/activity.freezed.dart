// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ActivityItem _$ActivityItemFromJson(Map<String, dynamic> json) {
  return _ActivityItem.fromJson(json);
}

/// @nodoc
mixin _$ActivityItem {
  String get id => throw _privateConstructorUsedError;
  String get recipientId => throw _privateConstructorUsedError;
  String get actorId => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // 'like' | 'comment' | 'follow' | 'mention' | 'reply'
  String? get postId => throw _privateConstructorUsedError;
  String? get commentId => throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get actorUsername => throw _privateConstructorUsedError;
  String? get actorAvatarUrl => throw _privateConstructorUsedError;
  String? get postThumbnailUrl => throw _privateConstructorUsedError;

  /// Serializes this ActivityItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityItemCopyWith<ActivityItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityItemCopyWith<$Res> {
  factory $ActivityItemCopyWith(
          ActivityItem value, $Res Function(ActivityItem) then) =
      _$ActivityItemCopyWithImpl<$Res, ActivityItem>;
  @useResult
  $Res call(
      {String id,
      String recipientId,
      String actorId,
      String type,
      String? postId,
      String? commentId,
      bool isRead,
      DateTime createdAt,
      String? actorUsername,
      String? actorAvatarUrl,
      String? postThumbnailUrl});
}

/// @nodoc
class _$ActivityItemCopyWithImpl<$Res, $Val extends ActivityItem>
    implements $ActivityItemCopyWith<$Res> {
  _$ActivityItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? recipientId = null,
    Object? actorId = null,
    Object? type = null,
    Object? postId = freezed,
    Object? commentId = freezed,
    Object? isRead = null,
    Object? createdAt = null,
    Object? actorUsername = freezed,
    Object? actorAvatarUrl = freezed,
    Object? postThumbnailUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      recipientId: null == recipientId
          ? _value.recipientId
          : recipientId // ignore: cast_nullable_to_non_nullable
              as String,
      actorId: null == actorId
          ? _value.actorId
          : actorId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      postId: freezed == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String?,
      commentId: freezed == commentId
          ? _value.commentId
          : commentId // ignore: cast_nullable_to_non_nullable
              as String?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      actorUsername: freezed == actorUsername
          ? _value.actorUsername
          : actorUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      actorAvatarUrl: freezed == actorAvatarUrl
          ? _value.actorAvatarUrl
          : actorAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      postThumbnailUrl: freezed == postThumbnailUrl
          ? _value.postThumbnailUrl
          : postThumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActivityItemImplCopyWith<$Res>
    implements $ActivityItemCopyWith<$Res> {
  factory _$$ActivityItemImplCopyWith(
          _$ActivityItemImpl value, $Res Function(_$ActivityItemImpl) then) =
      __$$ActivityItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String recipientId,
      String actorId,
      String type,
      String? postId,
      String? commentId,
      bool isRead,
      DateTime createdAt,
      String? actorUsername,
      String? actorAvatarUrl,
      String? postThumbnailUrl});
}

/// @nodoc
class __$$ActivityItemImplCopyWithImpl<$Res>
    extends _$ActivityItemCopyWithImpl<$Res, _$ActivityItemImpl>
    implements _$$ActivityItemImplCopyWith<$Res> {
  __$$ActivityItemImplCopyWithImpl(
      _$ActivityItemImpl _value, $Res Function(_$ActivityItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActivityItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? recipientId = null,
    Object? actorId = null,
    Object? type = null,
    Object? postId = freezed,
    Object? commentId = freezed,
    Object? isRead = null,
    Object? createdAt = null,
    Object? actorUsername = freezed,
    Object? actorAvatarUrl = freezed,
    Object? postThumbnailUrl = freezed,
  }) {
    return _then(_$ActivityItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      recipientId: null == recipientId
          ? _value.recipientId
          : recipientId // ignore: cast_nullable_to_non_nullable
              as String,
      actorId: null == actorId
          ? _value.actorId
          : actorId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      postId: freezed == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String?,
      commentId: freezed == commentId
          ? _value.commentId
          : commentId // ignore: cast_nullable_to_non_nullable
              as String?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      actorUsername: freezed == actorUsername
          ? _value.actorUsername
          : actorUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      actorAvatarUrl: freezed == actorAvatarUrl
          ? _value.actorAvatarUrl
          : actorAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      postThumbnailUrl: freezed == postThumbnailUrl
          ? _value.postThumbnailUrl
          : postThumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityItemImpl implements _ActivityItem {
  const _$ActivityItemImpl(
      {required this.id,
      required this.recipientId,
      required this.actorId,
      required this.type,
      this.postId,
      this.commentId,
      this.isRead = false,
      required this.createdAt,
      this.actorUsername,
      this.actorAvatarUrl,
      this.postThumbnailUrl});

  factory _$ActivityItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityItemImplFromJson(json);

  @override
  final String id;
  @override
  final String recipientId;
  @override
  final String actorId;
  @override
  final String type;
// 'like' | 'comment' | 'follow' | 'mention' | 'reply'
  @override
  final String? postId;
  @override
  final String? commentId;
  @override
  @JsonKey()
  final bool isRead;
  @override
  final DateTime createdAt;
  @override
  final String? actorUsername;
  @override
  final String? actorAvatarUrl;
  @override
  final String? postThumbnailUrl;

  @override
  String toString() {
    return 'ActivityItem(id: $id, recipientId: $recipientId, actorId: $actorId, type: $type, postId: $postId, commentId: $commentId, isRead: $isRead, createdAt: $createdAt, actorUsername: $actorUsername, actorAvatarUrl: $actorAvatarUrl, postThumbnailUrl: $postThumbnailUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.recipientId, recipientId) ||
                other.recipientId == recipientId) &&
            (identical(other.actorId, actorId) || other.actorId == actorId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.commentId, commentId) ||
                other.commentId == commentId) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.actorUsername, actorUsername) ||
                other.actorUsername == actorUsername) &&
            (identical(other.actorAvatarUrl, actorAvatarUrl) ||
                other.actorAvatarUrl == actorAvatarUrl) &&
            (identical(other.postThumbnailUrl, postThumbnailUrl) ||
                other.postThumbnailUrl == postThumbnailUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      recipientId,
      actorId,
      type,
      postId,
      commentId,
      isRead,
      createdAt,
      actorUsername,
      actorAvatarUrl,
      postThumbnailUrl);

  /// Create a copy of ActivityItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityItemImplCopyWith<_$ActivityItemImpl> get copyWith =>
      __$$ActivityItemImplCopyWithImpl<_$ActivityItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityItemImplToJson(
      this,
    );
  }
}

abstract class _ActivityItem implements ActivityItem {
  const factory _ActivityItem(
      {required final String id,
      required final String recipientId,
      required final String actorId,
      required final String type,
      final String? postId,
      final String? commentId,
      final bool isRead,
      required final DateTime createdAt,
      final String? actorUsername,
      final String? actorAvatarUrl,
      final String? postThumbnailUrl}) = _$ActivityItemImpl;

  factory _ActivityItem.fromJson(Map<String, dynamic> json) =
      _$ActivityItemImpl.fromJson;

  @override
  String get id;
  @override
  String get recipientId;
  @override
  String get actorId;
  @override
  String get type; // 'like' | 'comment' | 'follow' | 'mention' | 'reply'
  @override
  String? get postId;
  @override
  String? get commentId;
  @override
  bool get isRead;
  @override
  DateTime get createdAt;
  @override
  String? get actorUsername;
  @override
  String? get actorAvatarUrl;
  @override
  String? get postThumbnailUrl;

  /// Create a copy of ActivityItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityItemImplCopyWith<_$ActivityItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
