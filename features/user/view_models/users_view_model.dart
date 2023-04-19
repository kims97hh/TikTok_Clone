import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentification/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/authentification/view_models/signup_view_model.dart';
import 'package:tiktok_clone/features/user/model/user_profile_model.dart';
import 'package:tiktok_clone/features/user/repos/user_repo.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _usersRepository;
  late final AuthenticationRepository _authenticationRepository;

  @override
  FutureOr<UserProfileModel> build() async {
    _usersRepository = ref.read(userRepo);
    _authenticationRepository = ref.read(authRepo);

    if (_authenticationRepository.isLoggedIn) {
      final profile = await _usersRepository
          .findProfile(_authenticationRepository.user!.uid);
      if (profile != null) {
        return UserProfileModel.fromJson(profile);
      }
    }

    return UserProfileModel.empty();
  }

  Future<void> createProfile(UserCredential credential) async {
    if (credential.user == null) {
      throw Exception("Account not created");
    } // "!" 를 사용하지 않으려면 사전애 "null" 검증을하여 throw err 한다 => 사전 error 대응 필수
    state = const AsyncValue.loading();

    final form = ref.read(signUpForm);

    // await credential.user!.updateDisplayName(form["name"]); // Why isn't it working? Why? Why?

    final profile = UserProfileModel(
      hasAvatar: false,
      bio: form["bio"] ?? "undefined",
      link: form["link"] ?? "http://undefined",
      email: credential.user!.email ?? "anon@anon.com",
      uid: credential.user!.uid,
      name: form["name"] ?? // .updateDisplayName 이 작동되지 않아 어쩔수 없다
          credential.user!.displayName ??
          "Anon",

      birth: form["birth"] ?? "undefined",

    );
    await _usersRepository.createProfile(profile);
    // await credential.user!.updateDisplayName(form["name"]); // 프로파일 생성후 업데이트 인데도 작동 안한다!
    state = AsyncValue.data(profile);
  }

  Future<void> onAvatarUpload() async {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(hasAvatar: true));

    // 데이터를 수정할 수 없으므로 기존 데이터를 복사한후 새로 만들어야 한다.
    await _usersRepository.updateUser(state.value!.uid, {"hasAvatar": true});
  }

  Future<void> onProfileUpdate(Map<String, dynamic> data) async {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith());
    // copyWith()전체 불러와서 state 에 넣는다
    await _usersRepository.updateUser(state.value!.uid, data);
    // 이곳 구현(setInputValue() 에서 데이터를 수신받아 넣는다. 형태는 list? map? {})
  }

}

final usersProvider = AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
  () => UsersViewModel(),
);
