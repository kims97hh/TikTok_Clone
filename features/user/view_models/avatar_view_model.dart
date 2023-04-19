import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentification/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/user/repos/user_repo.dart';
import 'package:tiktok_clone/features/user/view_models/users_view_model.dart';

class AvatarViewModel extends AsyncNotifier<void> {
  late final UserRepository _repository;

  @override
  FutureOr<void> build() async {
    _repository = ref.read(userRepo);
  }

  Future<void> uploadAvatar(File file) async {
    state = const AsyncValue.loading();
    // uid를 읽어와 파일이름으로 하여 찾기 쉽게 한다.
    final fileName = ref.read(authRepo).user!.uid;
    state = await AsyncValue.guard(
      () async {
        await _repository.uploadAvatar(file, fileName);
        await ref.read(usersProvider.notifier).onAvatarUpload();
      },
    ); // repository의 upload 호출
  }
}

// AsyncNotifirerProvider<expose할것,넘길데이터> => 리턴값
final avatarProvider = AsyncNotifierProvider<AvatarViewModel, void>(
  () => AvatarViewModel(),
);


/*
(MVVM 아키텍쳐구성을 위한 folder 설명)
model : 데이터(외/내부) 오가는 변수, 형식 정의

[widgets] : 메인 프레임, 기본적인 App의 화면 UI, 사용자화면, view등의 데이터를 오가지 않는 대부분의 widget들
view : widgets중 데이터를 조작하는 widget, 해당 파트에 대한 UI, 사용자화면(즉 데이터 변경시 전체를 rebuild 하지 않고 해당 부분만 rebuild 하여 효율성 극대화)

viewmodel : view 에서 받은 데이터를 model을 이용하여 외부로 전달을 위한 사전작업(repository 전달전), 외부1에서 받은 데이터를 model을 이용하여 view 로 전달 (firebase등, 또는 API 정보전달등), 즉 로딩 상태를 거쳐 성공 또는 실패(err) 상태로 변경하는 것
[repository(repos)] : 외부(firebase등)에 실제 데이터를 전송(저장), 읽기등

*상관관계도*
[widgets <> view] <-> [viewmodel <> repository(repos)] <-> model

이런 구조의 아키텍쳐는 향후 유지보수성, 성능에 유리하다.
유지보수성 => data 처리 부분만 수정 하여 전체적으로 반영 가능 (riverpod, provider)
성능 => 데이터 처리부분만 rebuild 한다. (widget에 있다면 전체 app 을 rebuild 하게 된다.)
*/