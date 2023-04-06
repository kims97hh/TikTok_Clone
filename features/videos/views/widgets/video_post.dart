import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/view_models/playback_config_vm.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_button.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_comments.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPost extends ConsumerStatefulWidget {
  final Function onVideoFinished;
  final int index;

  const VideoPost({
    super.key,
    required this.onVideoFinished,
    required this.index,
  });

  @override
  VideoPostState createState() => VideoPostState();
}

class VideoPostState extends ConsumerState<VideoPost>
    with TickerProviderStateMixin {
  //"vsync:" 를 하나만 사용하기위한 with Single~~Mixin ,두개이상은 TickerProviderStateMixin (with는 메소드 전체를 불러옴) , 더불어 리소스 절약을 위해 위젯이 화면에 보일때만 tick, ticker를 제공해줌. (ticker는 매 에니메이션 프레임마다 callback, 결과적으로 부드러운 에니메이션 표현)
  late final VideoPlayerController _videoPlayerController;
  final Duration _animationDuration = const Duration(milliseconds: 200);

  late final AnimationController _animationController;

  bool _isPaused = false;
  late bool _isCurrentMuted; // 코드 챌린지

  void _onVideoChange() {
    if (_videoPlayerController.value.duration ==
        _videoPlayerController.value.position) {
      widget.onVideoFinished();
    }
  }

  void _initVideoPlayer() async {
    _videoPlayerController =
        VideoPlayerController.asset("assets/videos/video.mp4");
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    final muted = ref.read(playbackConfigProvider).muted;
    if (kIsWeb || muted) {
      await _videoPlayerController.setVolume(0);
    } else {
      await _videoPlayerController.setVolume(1);
    }
    _videoPlayerController.addListener(_onVideoChange);
    if (_isCurrentMuted != muted) {
      setState(() {
        _isCurrentMuted = ref.read(playbackConfigProvider).muted;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
    _animationController = AnimationController(
      vsync:
          this, //에니메이션의 매프레임마다 Ticker 가 실행, (ex, 초당 60프레임), this => 현재속한 class
      lowerBound: 1.0,
      upperBound: 1.5,
      value: 1.5,
      duration: _animationDuration,
    );

    _isCurrentMuted = ref.read(playbackConfigProvider).muted;
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();

    super.dispose();
  }

  /* void _onPlaybackConfigChanged() {  // provider 사용할때 코드 (riverpod에선 불필요)
    if (!mounted) return;
    if (ref.read(playbackConfigProvider).muted) {
      _videoPlayerController.setVolume(0);
    } else {
      _videoPlayerController.setVolume(1);
    }
  } */

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!mounted) return;
    if (info.visibleFraction == 1 &&
        !_isPaused &&
        !_videoPlayerController.value.isPlaying) {
      if (ref.read(playbackConfigProvider).autoplay) {
        _videoPlayerController.play();
      }
    }
    if (_videoPlayerController.value.isPlaying && info.visibleFraction == 0) {
      _onTogglePause();
    }
  }

  void _onTogglePause() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
      _animationController.reverse();
    } else {
      _videoPlayerController.play();
      _animationController.forward();
    }
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _onCommentsTap(BuildContext context) async {
    if (_videoPlayerController.value.isPlaying) {
      _onTogglePause();
      await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) => const VideoCommnets(),
      );
      _onTogglePause();
    } else {
      await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled:
            true, // BottomSheet 안에서 [Listview] 를 사용하려면 true 설정하여야 사이즈 변경이 가능해진다.
        context: context,
        builder: (context) => const VideoCommnets(),
      );
    }
  }

  void _onToggleMuted() {
    setState(() {
      _isCurrentMuted = !_isCurrentMuted;
    });
    final muted = ref.read(playbackConfigProvider).muted;
    if (muted && _isCurrentMuted) {
      _videoPlayerController.setVolume(0);
    } else if (_isCurrentMuted) {
      _videoPlayerController.setVolume(0);
    } else {
      _videoPlayerController.setVolume(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key("${widget.index}"),
      onVisibilityChanged: _onVisibilityChanged,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Breakpoints.sm),
        child: Stack(
          children: [
            Positioned.fill(
              child: _videoPlayerController.value.isInitialized
                  ? VideoPlayer(_videoPlayerController)
                  : Container(
                      color: Colors.black,
                    ),
            ),
            Positioned.fill(
              child: GestureDetector(
                onTap: _onTogglePause,
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _animationController.value,
                        child: child,
                      );
                    },
                    child: AnimatedOpacity(
                      opacity: _isPaused ? 1 : 0,
                      duration: _animationDuration,
                      child: const FaIcon(
                        FontAwesomeIcons.play,
                        color: Colors.white,
                        size: Sizes.size52,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              top: 20,
              child: Column(
                children: [
                  IconButton(
                    onPressed: _onToggleMuted, // MVVM
                    icon: FaIcon(
                      _isCurrentMuted // MVVM
                          ? FontAwesomeIcons.volumeOff
                          : FontAwesomeIcons.volumeHigh,
                      color: Colors.white,
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: _isCurrentMuted ? 1 : 0,
                    duration: _isCurrentMuted
                        ? _animationDuration
                        : const Duration(milliseconds: 2500),
                    child: Text(
                      _isCurrentMuted ? "Mute" : "Sound On",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 30,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "@kims98hh",
                    style: TextStyle(
                      fontSize: Sizes.size20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Gaps.v10,
                  Text(
                    "This is actually the place😂",
                    style: TextStyle(
                      fontSize: Sizes.size16,
                      color: Colors.white,
                    ),
                  ),
                  Gaps.v10,
                  SizedBox(
                    width: 300,
                    child: Text(
                      "#google1 #google2 #google3 #google4 #여긴넘어감",
                      style: TextStyle(
                          fontSize: Sizes.size16,
                          color: Colors.white,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              right: 10,
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    foregroundImage: NetworkImage(
                        "https://avatars.githubusercontent.com/u/42740714"),
                    child: Text("hhk"),
                  ),
                  Gaps.v24,
                  VideoButton(
                    icon: FontAwesomeIcons.solidHeart,
                    text: S.of(context).likeCount(
                        8839), // {변수} 만 받아서 "compact" format 형식으로 번역 표시 int
                  ),
                  Gaps.v24,
                  GestureDetector(
                    onTap: () => _onCommentsTap(context),
                    child: VideoButton(
                      icon: FontAwesomeIcons.solidComment,
                      text: S.of(context).commentCount(234512348),
                    ),
                  ),
                  Gaps.v24,
                  const VideoButton(
                    icon: FontAwesomeIcons.share,
                    text: "Share",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
