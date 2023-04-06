
import 'package:shared_preferences/shared_preferences.dart';

class PlaybackConfigRepository {
  static const String _autoplay = "autoplay";
  static const String _muted = "muted";
  final SharedPreferences _preferences;

  PlaybackConfigRepository(this._preferences);

  Future<void> setMuted(bool value) async {
    _preferences.setBool(_muted, value);
  }

  Future<void> setAutoplay(bool value) async {
    _preferences.setBool(_autoplay, value);
  }

  bool isMuted() {
    return _preferences.getBool(_muted) ??
        false; // .setBool() 이전일 수 있으므로, null을 반환할 수 있어 ?(null) ? false; 를 반영한다.
  }

  bool isAutoplay() {
    return _preferences.getBool(_autoplay) ?? false;
  }
}
