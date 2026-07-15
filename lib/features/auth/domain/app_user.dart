import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    required String id,
    required String username,
    String? fullName,
    String? avatarUrl,
    String? bio,
    String? website,
    @Default(false) bool isPrivate,
    @Default(0) int followerCount,
    @Default(0) int followingCount,
    @Default(0) int postCount,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}