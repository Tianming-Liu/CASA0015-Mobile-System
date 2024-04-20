import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geotracker/models/userinfo.dart';
import 'dart:io';

class UserInfoNotifier extends StateNotifier<UserInfo?> {
  UserInfoNotifier() : super(null);

  void setUser(String userName, File userProfileImage) {
    state = UserInfo(
      userName: userName,
      userProfileImage: userProfileImage,
    );
  }

  void clearUser() {
    state = null;
  }
}

final userInfoProvider = StateNotifierProvider<UserInfoNotifier, UserInfo?>((ref) {
  return UserInfoNotifier();
});