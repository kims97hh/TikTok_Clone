import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/playback_config_model.dart';
import 'package:tiktok_clone/features/videos/repos/playback_config_repo.dart';

class PlaybackConfigViewModel extends Notifier<PlaybackConfigModel> {
  final PlaybackConfigRepository _repository;

  PlaybackConfigViewModel(this._repository);

  void setMuted(bool value) {
    _repository.setMuted(value);
    state = PlaybackConfigModel(
      muted: value, // 새로운 값
      autoplay: state.autoplay, // state (PlaybackConfigModel) 에서 가지고 있는 값
    ); // state를 이용하여 현재값을 넣어도 반영되지 않는다. 따라서, PlaybackConfigModel 을 호출하여 반영한다.
  }

  void setAutoplay(bool value) {
    _repository.setAutoplay(value);
    state = PlaybackConfigModel(
      muted: state.muted,
      autoplay: value,
    );
  }

  @override
  PlaybackConfigModel build() {
    return PlaybackConfigModel(
      muted: _repository.isMuted(),
      autoplay: _repository.isAutoplay(),
    );
  }
}

final playbackConfigProvider =
    NotifierProvider<PlaybackConfigViewModel, PlaybackConfigModel>(
  () =>
      throw UnimplementedError(), // 원래는 => PlaybackConfigViewModel() 을 하여야 하나, require된 this._repository 가 필요하고, 그것은 await (SharedPreferences.getInstance()) 되고 있으므로, missing argument Error 가 발생하므로, 지금만 임시로 throw UnimplementedError() (구현되지 않은 에러무시) 를 한다.
);
