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
    with WidgetsBindingObserver {
  bool _hasPermission = false;
  bool _permissionAlert = false;
  int count = 0;

  late final CameraController _cameraController;

  Future<void> initCamera() async {
    final cameras = await availableCameras();

    if (cameras.isEmpty) {
      return;
    }

    _cameraController = CameraController(
      cameras[0],
      ResolutionPreset.ultraHigh,
    );

    await _cameraController.initialize();
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
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
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
                ],
              ),
      ),
    );
  }
}
