// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return _Comment.fromJson(json);
}

/// @nodoc
mixin _$Comment {
  String get id => throw _privateConstructorUsedError;
  String get postId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get parentId => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  int get likeCount => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String? get authorUsername => throw _privateConstructorUsedError;
  String? get authorAvatarUrl => throw _privateConstructorUsedError;
  bool get isLikedByMe => throw _privateConstructorUsedError;

  /// Serializes this Comment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentCopyWith<Comment> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentCopyWith<$Res> {
  factory $CommentCopyWith(Comment value, $Res Function(Comment) then) =
      _$CommentCopyWithImpl<$Res, Comment>;
  @useResult
  $Res call(
      {String id,
      String postId,
      String userId,
      String? parentId,
      String content,
      int likeCount,
      DateTime createdAt,
      String? authorUsername,
      String? authorAvatarUrl,
      bool isLikedByMe});
}

/// @nodoc
class _$CommentCopyWithImpl<$Res, $Val extends Comment>
    implements $CommentCopyWith<$Res> {
  _$CommentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? postId = null,
    Object? userId = null,
    Object? parentId = freezed,
    Object? content = null,
    Object? likeCount = null,
    Object? createdAt = null,
    Object? authorUsername = freezed,
    Object? authorAvatarUrl = freezed,
    Object? isLikedByMe = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      authorUsername: freezed == authorUsername
          ? _value.authorUsername
          : authorUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      authorAvatarUrl: freezed == authorAvatarUrl
          ? _value.authorAvatarUrl
          : authorAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isLikedByMe: null == isLikedByMe
          ? _value.isLikedByMe
          : isLikedByMe // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommentImplCopyWith<$Res> implements $CommentCopyWith<$Res> {
  factory _$$CommentImplCopyWith(
          _$CommentImpl value, $Res Function(_$CommentImpl) then) =
      __$$CommentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String postId,
      String userId,
      String? parentId,
      String content,
      int likeCount,
      DateTime createdAt,
      String? authorUsername,
      String? authorAvatarUrl,
      bool isLikedByMe});
}

/// @nodoc
class __$$CommentImplCopyWithImpl<$Res>
    extends _$CommentCopyWithImpl<$Res, _$CommentImpl>
    implements _$$CommentImplCopyWith<$Res> {
  __$$CommentImplCopyWithImpl(
      _$CommentImpl _value, $Res Function(_$CommentImpl) _then)
      : super(_value, _then);

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? postId = null,
    Object? userId = null,
    Object? parentId = freezed,
    Object? content = null,
    Object? likeCount = null,
    Object? createdAt = null,
    Object? authorUsername = freezed,
    Object? authorAvatarUrl = freezed,
    Object? isLikedByMe = null,
  }) {
    return _then(_$CommentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      authorUsername: freezed == authorUsername
          ? _value.authorUsername
          : authorUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      authorAvatarUrl: freezed == authorAvatarUrl
          ? _value.authorAvatarUrl
          : authorAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isLikedByMe: null == isLikedByMe
          ? _value.isLikedByMe
          : isLikedByMe // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommentImpl implements _Comment {
  const _$CommentImpl(
      {required this.id,
      required this.postId,
      required this.userId,
      this.parentId,
      required this.content,
      this.likeCount = 0,
      required this.createdAt,
      this.authorUsername,
      this.authorAvatarUrl,
      this.isLikedByMe = false});

  factory _$CommentImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommentImplFromJson(json);

  @override
  final String id;
  @override
  final String postId;
  @override
  final String userId;
  @override
  final String? parentId;
  @override
  final String content;
  @override
  @JsonKey()
  final int likeCount;
  @override
  final DateTime createdAt;
  @override
  final String? authorUsername;
  @override
  final String? authorAvatarUrl;
  @override
  @JsonKey()
  final bool isLikedByMe;

  @override
  String toString() {
    return 'Comment(id: $id, postId: $postId, userId: $userId, parentId: $parentId, content: $content, likeCount: $likeCount, createdAt: $createdAt, authorUsername: $authorUsername, authorAvatarUrl: $authorAvatarUrl, isLikedByMe: $isLikedByMe)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.postId, postId) || other.postId == postId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.authorUsername, authorUsername) ||
                other.authorUsername == authorUsername) &&
            (identical(other.authorAvatarUrl, authorAvatarUrl) ||
                other.authorAvatarUrl == authorAvatarUrl) &&
            (identical(other.isLikedByMe, isLikedByMe) ||
                other.isLikedByMe == isLikedByMe));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      postId,
      userId,
      parentId,
      content,
      likeCount,
      createdAt,
      authorUsername,
      authorAvatarUrl,
      isLikedByMe);

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentImplCopyWith<_$CommentImpl> get copyWith =>
      __$$CommentImplCopyWithImpl<_$CommentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommentImplToJson(
      this,
    );
  }
}

abstract class _Comment implements Comment {
  const factory _Comment(
      {required final String id,
      required final String postId,
      required final String userId,
      final String? parentId,
      required final String content,
      final int likeCount,
      required final DateTime createdAt,
      final String? authorUsername,
      final String? authorAvatarUrl,
      final bool isLikedByMe}) = _$CommentImpl;

  factory _Comment.fromJson(Map<String, dynamic> json) = _$CommentImpl.fromJson;

  @override
  String get id;
  @override
  String get postId;
  @override
  String get userId;
  @override
  String? get parentId;
  @override
  String get content;
  @override
  int get likeCount;
  @override
  DateTime get createdAt;
  @override
  String? get authorUsername;
  @override
  String? get authorAvatarUrl;
  @override
  bool get isLikedByMe;

  /// Create a copy of Comment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentImplCopyWith<_$CommentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
