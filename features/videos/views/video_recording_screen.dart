import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/views/video_preview_screen.dart';
import 'package:tiktok_clone/features/videos/views/video_timeline_screen.dart';

class VideoRecordingScreen extends StatefulWidget {
  static const String routeName = "postVideo";
  static const String routeURL = "/upload";
  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool _hasPermission = false;
  bool _permissionAlert = false;
  bool _permanentPermission = false;

  int initPermissionCount = 0;

  bool _isSelfieMode = false;

  late final bool _noCamera = kDebugMode && Platform.isIOS;

  final bool _isDragZoom = false;
  late double _maxZoom;
  late double _minZoom;
  late double _activeZoom;
  double zoom = 0.0;

  late final AnimationController _buttonAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  late final Animation<double> _buttonAnimation =
      Tween(begin: 1.0, end: 1.3).animate(_buttonAnimationController);

  late final AnimationController _progressAnimationController =
      AnimationController(
          vsync: this,
          duration: const Duration(seconds: 10),
          lowerBound: 0.0,
          upperBound: 1.0);

  late FlashMode _flashMode;
  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
    if (!_noCamera) {
      initPermissions();
    } else {
      setState(() {
        _hasPermission = true;
      });
    }
    WidgetsBinding.instance.addObserver(this); // 현재app 에서 벗어남,돌아옴을 감지
    _progressAnimationController.addListener(() {
      setState(() {}); // await 할 경우
    });
    _progressAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _stopRecording();
      }
    });
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    _buttonAnimationController.dispose();
    if (!_noCamera) {
      _cameraController.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (_noCamera) return;

    if (!_hasPermission &&
        _permissionAlert &&
        state == AppLifecycleState.resumed) {
      final cameraGranted = await Permission.camera.isGranted;
      final micGranted = await Permission.microphone.isGranted;

      if (cameraGranted && micGranted) {
        _hasPermission = true;
        _permissionAlert = false;
        await initCamera();
        _permanentPermission = true;
        setState(() {}); // await 할 경우
      } else {
        _hasPermission = false;
        _permissionAlert = true;
        _permanentPermission = false;
        setState(() {}); // await 할 경우
      }
    }

    if (_permanentPermission) {
      if (state == AppLifecycleState.inactive) {
        _cameraController.dispose();
      } else if (state == AppLifecycleState.resumed) {
        await initCamera();
      }
    }
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();

    if (cameras.isEmpty) {
      return;
    }

    _cameraController = CameraController(
      cameras[_isSelfieMode ? 1 : 0],
      ResolutionPreset.ultraHigh,
    );

    await _cameraController.initialize();

    await _cameraController.prepareForVideoRecording(); //only iOS (영상/음성 sync)

    _maxZoom = await _cameraController.getMaxZoomLevel();
    _minZoom = await _cameraController.getMinZoomLevel();
    // _cameraController.setZoomLevel(zoom);

    _flashMode = _cameraController.value.flashMode;

    setState(() {});
  }

  Future<void> initPermissions() async {
    final cameraPermission = await Permission.camera.request();
    final micPermission = await Permission.microphone.request();

    final cameraDenied =
        cameraPermission.isDenied || cameraPermission.isPermanentlyDenied;

    final micDenied =
        micPermission.isDenied || micPermission.isPermanentlyDenied;

    if (!cameraDenied && !micDenied) {
      _hasPermission = true;
      await initCamera();
      setState(() {}); // 카메라초기화후 await 동안 화면 재생성한다, (만약 하지 않으면 무한 대기)
    } else {
      setState(() {
        _permissionAlert = true;
      });
    }
  }

  void rePermission() {
    initPermissionCount = initPermissionCount + 1;
    if (initPermissionCount < 2) {
      setState(() {
        _hasPermission = false;
        _permissionAlert = false;
      });
      initPermissions();
    } else {
      openAppSettings();
    }
  }

  Future<void> _toggleSelfieMode() async {
    _isSelfieMode = !_isSelfieMode;
    await initCamera();
    setState(() {}); // await 할 경우
  }

  Future<void> _setFlashMode(FlashMode newFlashMode) async {
    await _cameraController.setFlashMode(newFlashMode);
    _flashMode = newFlashMode;
    setState(() {}); // await 할 경우
  }

  Future<void> _startRecording(TapDownDetails _) async {
    if (_cameraController.value.isRecordingVideo) return;

    await _cameraController.startVideoRecording();

    _buttonAnimationController.forward();
    _progressAnimationController.forward();
  }

  Future<void> _stopRecording() async {
    if (!_cameraController.value.isRecordingVideo) return;

    _buttonAnimationController.reverse();
    _progressAnimationController.reset();

    final video = await _cameraController.stopVideoRecording();

    if (!mounted) return; // async 에서 context를 사용할 경우 !mounted return 으로 조치한다.

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          video: video,
          isPicked: false,
        ),
      ),
    );
  }

  Future<void> _onPickVideoPressed() async {
    final video = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );
    if (video == null) return;

    if (!mounted) return; // async 에서 context를 사용할 경우 !mounted return 으로 조치한다.

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          video: video,
          isPicked: true,
        ),
      ),
    );
  }

  void _onDrag(DragUpdateDetails details) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: !_hasPermission
            ? _permissionAlert
                ? AlertDialog(
                    icon: const FaIcon(FontAwesomeIcons.tiktok),
                    title: const Text(
                        "The camera and microphone are unavailable."),
                    content: const Text(
                        "Please return to Home or set permissions again"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const VideoTimelineScreen(),
                          ),
                        ),
                        child: const Text("Back to Home"),
                      ),
                      TextButton(
                        onPressed: () => rePermission(),
                        child: const Text("Re-permissions"),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Initializing...",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Sizes.size20,
                        ),
                      ),
                      Gaps.v20,
                      CircularProgressIndicator.adaptive(),
                    ],
                  )
            : Stack(
                alignment: Alignment.center,
                children: [
                  if (!_noCamera && _cameraController.value.isInitialized)
                    CameraPreview(_cameraController),
                  const Positioned(
                    top: Sizes.size40,
                    left: Sizes.size20,
                    child: CloseButton(
                      color: Colors.white,
                    ),
                  ),
                  if (!_noCamera)
                    Positioned(
                      top: Sizes.size32,
                      right: Sizes.size20,
                      child: Column(
                        children: [
                          selfieAndflashButton(
                              _toggleSelfieMode,
                              const Icon(Icons.cameraswitch_outlined),
                              _isSelfieMode),
                          Gaps.v10,
                          selfieAndflashButton(
                              () => _setFlashMode(FlashMode.off),
                              const Icon(Icons.flash_off_rounded),
                              _flashMode == FlashMode.off),
                          Gaps.v10,
                          selfieAndflashButton(
                              () => _setFlashMode(FlashMode.always),
                              const Icon(Icons.flash_on_rounded),
                              _flashMode == FlashMode.always),
                          Gaps.v10,
                          selfieAndflashButton(
                              () => _setFlashMode(FlashMode.auto),
                              const Icon(Icons.flash_auto_rounded),
                              _flashMode == FlashMode.auto),
                          Gaps.v10,
                          selfieAndflashButton(
                              () => _setFlashMode(FlashMode.torch),
                              const Icon(Icons.flashlight_on_rounded),
                              _flashMode == FlashMode.torch),
                        ],
                      ),
                    ),
                  Positioned(
                    width: MediaQuery.of(context).size.width,
                    bottom: Sizes.size40,
                    child: Row(
                      children: [
                        const Spacer(),
                        GestureDetector(
                          onTapDown: _startRecording,
                          onVerticalDragUpdate:
                              (DragUpdateDetails details) async {
                            // _startRecording;
                            _activeZoom = details.localPosition.dy;

                            zoom = _maxZoom -
                                (double.parse(_activeZoom.toStringAsFixed(0)) /
                                    10);

                            if (zoom <= _maxZoom && zoom >= _minZoom) {
                              print(zoom);
                              await _cameraController.setZoomLevel(zoom);
                            }
                            setState(() {});

                            // _cameraController.setZoomLevel(zoom);
                          },
                          onLongPressEnd: (details) => _stopRecording(),
                          child: ScaleTransition(
                            scale: _buttonAnimation,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: Sizes.size80 + Sizes.size14,
                                  height: Sizes.size80 + Sizes.size14,
                                  child: CircularProgressIndicator(
                                    color: Colors.red.shade400,
                                    strokeWidth: Sizes.size6,
                                    value: _progressAnimationController
                                        .value, // 진행도를 %로 표시 1=100%
                                  ),
                                ),
                                Container(
                                  width: Sizes.size80,
                                  height: Sizes.size80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: IconButton(
                              onPressed: _onPickVideoPressed,
                              icon: const FaIcon(
                                FontAwesomeIcons.image,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  IconButton selfieAndflashButton(var onPressed, Icon icon, bool mode) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
      color: mode ? Colors.amber.shade200 : Colors.white,
    );
  }
}
