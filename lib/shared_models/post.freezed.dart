// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Post _$PostFromJson(Map<String, dynamic> json) {
  return _Post.fromJson(json);
}

/// @nodoc
mixin _$Post {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get caption => throw _privateConstructorUsedError;
  List<String> get mediaUrls => throw _privateConstructorUsedError;
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  int get likeCount => throw _privateConstructorUsedError;
  int get commentCount => throw _privateConstructorUsedError;
  DateTime get createdAt =>
      throw _privateConstructorUsedError; // Joined fields (not columns) — populated by the repository query
  String? get authorUsername => throw _privateConstructorUsedError;
  String? get authorAvatarUrl => throw _privateConstructorUsedError;
  bool get isLikedByMe => throw _privateConstructorUsedError;
  bool get isSavedByMe => throw _privateConstructorUsedError;

  /// Serializes this Post to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostCopyWith<Post> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostCopyWith<$Res> {
  factory $PostCopyWith(Post value, $Res Function(Post) then) =
      _$PostCopyWithImpl<$Res, Post>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String? caption,
      List<String> mediaUrls,
      String? thumbnailUrl,
      String type,
      String? location,
      int likeCount,
      int commentCount,
      DateTime createdAt,
      String? authorUsername,
      String? authorAvatarUrl,
      bool isLikedByMe,
      bool isSavedByMe});
}

/// @nodoc
class _$PostCopyWithImpl<$Res, $Val extends Post>
    implements $PostCopyWith<$Res> {
  _$PostCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? caption = freezed,
    Object? mediaUrls = null,
    Object? thumbnailUrl = freezed,
    Object? type = null,
    Object? location = freezed,
    Object? likeCount = null,
    Object? commentCount = null,
    Object? createdAt = null,
    Object? authorUsername = freezed,
    Object? authorAvatarUrl = freezed,
    Object? isLikedByMe = null,
    Object? isSavedByMe = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      caption: freezed == caption
          ? _value.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as String?,
      mediaUrls: null == mediaUrls
          ? _value.mediaUrls
          : mediaUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentCount: null == commentCount
          ? _value.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
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
      isSavedByMe: null == isSavedByMe
          ? _value.isSavedByMe
          : isSavedByMe // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PostImplCopyWith<$Res> implements $PostCopyWith<$Res> {
  factory _$$PostImplCopyWith(
          _$PostImpl value, $Res Function(_$PostImpl) then) =
      __$$PostImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String? caption,
      List<String> mediaUrls,
      String? thumbnailUrl,
      String type,
      String? location,
      int likeCount,
      int commentCount,
      DateTime createdAt,
      String? authorUsername,
      String? authorAvatarUrl,
      bool isLikedByMe,
      bool isSavedByMe});
}

/// @nodoc
class __$$PostImplCopyWithImpl<$Res>
    extends _$PostCopyWithImpl<$Res, _$PostImpl>
    implements _$$PostImplCopyWith<$Res> {
  __$$PostImplCopyWithImpl(_$PostImpl _value, $Res Function(_$PostImpl) _then)
      : super(_value, _then);

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? caption = freezed,
    Object? mediaUrls = null,
    Object? thumbnailUrl = freezed,
    Object? type = null,
    Object? location = freezed,
    Object? likeCount = null,
    Object? commentCount = null,
    Object? createdAt = null,
    Object? authorUsername = freezed,
    Object? authorAvatarUrl = freezed,
    Object? isLikedByMe = null,
    Object? isSavedByMe = null,
  }) {
    return _then(_$PostImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      caption: freezed == caption
          ? _value.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as String?,
      mediaUrls: null == mediaUrls
          ? _value._mediaUrls
          : mediaUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentCount: null == commentCount
          ? _value.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
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
      isSavedByMe: null == isSavedByMe
          ? _value.isSavedByMe
          : isSavedByMe // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PostImpl implements _Post {
  const _$PostImpl(
      {required this.id,
      required this.userId,
      this.caption,
      required final List<String> mediaUrls,
      this.thumbnailUrl,
      this.type = 'image',
      this.location,
      this.likeCount = 0,
      this.commentCount = 0,
      required this.createdAt,
      this.authorUsername,
      this.authorAvatarUrl,
      this.isLikedByMe = false,
      this.isSavedByMe = false})
      : _mediaUrls = mediaUrls;

  factory _$PostImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String? caption;
  final List<String> _mediaUrls;
  @override
  List<String> get mediaUrls {
    if (_mediaUrls is EqualUnmodifiableListView) return _mediaUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mediaUrls);
  }

  @override
  final String? thumbnailUrl;
  @override
  @JsonKey()
  final String type;
  @override
  final String? location;
  @override
  @JsonKey()
  final int likeCount;
  @override
  @JsonKey()
  final int commentCount;
  @override
  final DateTime createdAt;
// Joined fields (not columns) — populated by the repository query
  @override
  final String? authorUsername;
  @override
  final String? authorAvatarUrl;
  @override
  @JsonKey()
  final bool isLikedByMe;
  @override
  @JsonKey()
  final bool isSavedByMe;

  @override
  String toString() {
    return 'Post(id: $id, userId: $userId, caption: $caption, mediaUrls: $mediaUrls, thumbnailUrl: $thumbnailUrl, type: $type, location: $location, likeCount: $likeCount, commentCount: $commentCount, createdAt: $createdAt, authorUsername: $authorUsername, authorAvatarUrl: $authorAvatarUrl, isLikedByMe: $isLikedByMe, isSavedByMe: $isSavedByMe)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.caption, caption) || other.caption == caption) &&
            const DeepCollectionEquality()
                .equals(other._mediaUrls, _mediaUrls) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.authorUsername, authorUsername) ||
                other.authorUsername == authorUsername) &&
            (identical(other.authorAvatarUrl, authorAvatarUrl) ||
                other.authorAvatarUrl == authorAvatarUrl) &&
            (identical(other.isLikedByMe, isLikedByMe) ||
                other.isLikedByMe == isLikedByMe) &&
            (identical(other.isSavedByMe, isSavedByMe) ||
                other.isSavedByMe == isSavedByMe));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      caption,
      const DeepCollectionEquality().hash(_mediaUrls),
      thumbnailUrl,
      type,
      location,
      likeCount,
      commentCount,
      createdAt,
      authorUsername,
      authorAvatarUrl,
      isLikedByMe,
      isSavedByMe);

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostImplCopyWith<_$PostImpl> get copyWith =>
      __$$PostImplCopyWithImpl<_$PostImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostImplToJson(
      this,
    );
  }
}

abstract class _Post implements Post {
  const factory _Post(
      {required final String id,
      required final String userId,
      final String? caption,
      required final List<String> mediaUrls,
      final String? thumbnailUrl,
      final String type,
      final String? location,
      final int likeCount,
      final int commentCount,
      required final DateTime createdAt,
      final String? authorUsername,
      final String? authorAvatarUrl,
      final bool isLikedByMe,
      final bool isSavedByMe}) = _$PostImpl;

  factory _Post.fromJson(Map<String, dynamic> json) = _$PostImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String? get caption;
  @override
  List<String> get mediaUrls;
  @override
  String? get thumbnailUrl;
  @override
  String get type;
  @override
  String? get location;
  @override
  int get likeCount;
  @override
  int get commentCount;
  @override
  DateTime
      get createdAt; // Joined fields (not columns) — populated by the repository query
  @override
  String? get authorUsername;
  @override
  String? get authorAvatarUrl;
  @override
  bool get isLikedByMe;
  @override
  bool get isSavedByMe;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostImplCopyWith<_$PostImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
