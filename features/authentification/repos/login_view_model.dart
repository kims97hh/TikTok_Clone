import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentification/repos/authentication_repo.dart';
import 'package:tiktok_clone/utils.dart';

class LoginViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(authRepo);
  }

  Future<void> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async => await _repository.signIn(email, password),
    ); //.guard() 내부에서 async => await 에 주의한다. *.guard 는 에러가 없으면 결과값을 반환, 에러가 있으면 에러를 반환한다.
    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
      //해당 widget 의 contex에 접근할 수 있어야 한다. (SnackBar,팝업창), 따라서 context 매개변수가 필요하다.
    } else {
      context.go("/home");
    }
  }
}

final loginProvider = AsyncNotifierProvider<LoginViewModel, void>(
  () => LoginViewModel(),
);
