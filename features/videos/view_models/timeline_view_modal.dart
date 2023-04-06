import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';

class TimelineViewModel extends AsyncNotifier<List<VideoModel>> {
  List<VideoModel> _list = [
    VideoModel(title: "First Video"),
    VideoModel(title: "Second Video"),
  ];

  void uploadVideo() async {
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(seconds: 2));
    // Firebase에 업로드 하는 대기시간을 예상하여 임의 대기, loading state를 다시 trigger 하는 테스트용, AsyncValue.loading();
    final newVideo = VideoModel(title: "${DateTime.now()}"); // Firbase 업로드 로직
    _list = [..._list, newVideo];
    // "...변수" 변수 의 List 값 전부를 뜻한다, 여기선 _list 변수의 모든 값 + newVideo 를 말한다.
    //Notifier 에서는 state 를 변경(.add()등)을 할 수 없기 때문에 해당 변수 전체를 바꿔주어 반영하도록 한다.
    state = AsyncValue.data(_list);
    // "state = _list" 로 표시불가하다. AsyncValue.date() 를 통하여 반영하여야 한다.
  }

  @override
  FutureOr<List<VideoModel>> build() async {
    await Future.delayed(
        const Duration(seconds: 5)); // API 에서 받을 경우를 예상하여 기다리는 시간
    /* throw Exception("OMG cant fatch"); */ //에러 테스트용,
    return _list;
  }
}

final timelineProvider =
    AsyncNotifierProvider<TimelineViewModel, List<VideoModel>>(
  () => TimelineViewModel(),
);
