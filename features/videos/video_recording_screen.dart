import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/widgets/video_timeline_screen.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool _hasPermission = false;
  bool _permissionAlert = false;
  int count = 0;

  bool _isSelfieMode = false;

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
    _flashMode = _cameraController.value.flashMode;
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
    count = count + 1;
    if (count < 2) {
      setState(() {
        _hasPermission = false;
        _permissionAlert = false;
      });
      initPermissions();
    } else {
      openAppSettings();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final cameraGranted = await Permission.camera.isGranted;
      final micGranted = await Permission.microphone.isGranted;
      if (cameraGranted && micGranted) {
        _hasPermission = true;
        _permissionAlert = false;
        await initCamera();
        setState(() {});
      } else {
        _hasPermission = false;
        _permissionAlert = true;
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initPermissions();
    WidgetsBinding.instance.addObserver(this);
    _progressAnimationController.addListener(() {
      setState(() {});
    });
    _progressAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _stopRecording();
      }
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _toggleSelfieMode() async {
    _isSelfieMode = !_isSelfieMode;
    await initCamera();
    setState(() {});
  }

  Future<void> _setFlashMode(FlashMode newFlashMode) async {
    await _cameraController.setFlashMode(newFlashMode);
    _flashMode = newFlashMode;
    setState(() {});
  }

  void _startRecording(TapDownDetails _) {
    _buttonAnimationController.forward();
    _progressAnimationController.forward();
  }

  void _stopRecording() {
    _buttonAnimationController.reverse();
    _progressAnimationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: !_hasPermission || !_cameraController.value.isInitialized
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
                  CameraPreview(_cameraController),
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
                    bottom: Sizes.size40,
                    child: GestureDetector(
                      onTapDown: _startRecording,
                      onTapUp: (details) => _stopRecording(),
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
