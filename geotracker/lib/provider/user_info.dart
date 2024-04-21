import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geotracker/models/userinfo.dart';

class UserInfoNotifier extends StateNotifier<UserInfo?> {
  UserInfoNotifier() : super(null);

  void setUser(String userName, String userProfileImage) {
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