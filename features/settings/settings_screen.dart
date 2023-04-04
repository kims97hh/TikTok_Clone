import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/common/widgets/video_configration/videdo_config.dart';
import 'package:tiktok_clone/features/authentification/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/videos/view_models/playback_config_vm.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          SwitchListTile.adaptive(
            value: ref
                .watch(playbackConfigProvider)
                .muted, // watch<>() 변화값참조 , read<>()는 고정값참조
            onChanged: (value) =>
                ref.read(playbackConfigProvider.notifier).setMuted(value),
            title: const Text("Mute Video"),
            subtitle: const Text("Videos muted by default."),
          ),
          SwitchListTile.adaptive(
            value: ref
                .watch(playbackConfigProvider)
                .autoplay, // watch<>() 변화값참조 , read<>()는 고정값참조
            onChanged: (value) =>
                ref.read(playbackConfigProvider.notifier).setAutoplay(value),
            title: const Text("Auto Play"),
            subtitle: const Text("Videos will start playing automatically."),
          ),
          ValueListenableBuilder(
            // ChangeNotifier{} 사용시 ValueListenableBuilder() 를 사용하여 Widget 에서 데이터 변화를 감지하여 전송. 또한 only AnimatedBuilder() 만 rebuild 된다. 효율장점
            valueListenable: darkMode,
            builder: (context, value, child) => SwitchListTile.adaptive(
              value: value,
              onChanged: (value) {
                darkMode.value = !darkMode.value;
              },
              title: Text(
                  "Change DarkMode (this ${value ? "Dark" : "SyS"}Mode)"), // AnimatedBuilder() 로 동일하게 구현가능하나, builder: 에서 "value" 값을 받을 수 없어 Text 구문에 활용할 수 없다.
              subtitle: const Text("Dark mode present"),
            ),
          ),
          SwitchListTile.adaptive(
            // ".adaptive" 는 각 운영체제별 머터리얼 디자인으로 표시한다( ex, ios 버튼 또는 android 버튼)
            value: false,
            onChanged: (value) {},
            title: const Text("Enable notifications"),
            subtitle: const Text("sub title"),
          ),
          CheckboxListTile(
            activeColor: Colors.black,
            checkColor: Colors.amber,
            value: false,
            onChanged: (value) {},
            title: const Text("Enable notifications"),
          ),
          ListTile(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1980),
                lastDate: DateTime(2030),
              );
              if (kDebugMode) {
                print(date);
              }

              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (kDebugMode) {
                print(time);
              }

              final booking = await showDateRangePicker(
                context: context,
                firstDate: DateTime(1980),
                lastDate: DateTime(2030),
                builder: (context, child) {
                  return Theme(
                    data: ThemeData(
                        appBarTheme: const AppBarTheme(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black)),
                    child: child!,
                  );
                },
              );
              if (kDebugMode) {
                print(booking);
              }
            },
            title: const Text("What is your birthday?"),
          ),
          ListTile(
            title: const Text("Log out (iOS)"),
            textColor: Colors.red,
            onTap: () {
              showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: const Text("are your sure?"),
                  content: const Text("plz dont go"),
                  actions: [
                    CupertinoDialogAction(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("No"),
                    ),
                    CupertinoDialogAction(
                      onPressed: () {
                        ref.read(authRepo).signOut();
                        context.go("/");
                      },
                      isDestructiveAction: true,
                      child: const Text("Yes"),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            title: const Text("Log out (Android)"),
            textColor: Colors.red,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  icon: const FaIcon(
                    FontAwesomeIcons.skull,
                  ),
                  title: const Text("are your sure?"),
                  content: const Text("plz dont go"),
                  actions: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const FaIcon(FontAwesomeIcons.tiktok),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Yes"),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            title: const Text("Log out (iOS / Bottom UP)"),
            textColor: Colors.red,
            onTap: () {
              showCupertinoModalPopup(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: const Text("are your sure?"),
                  content: const Text("plz dont go"),
                  actions: [
                    CupertinoDialogAction(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("No"),
                    ),
                    CupertinoDialogAction(
                      onPressed: () => Navigator.of(context).pop(),
                      isDestructiveAction: true,
                      child: const Text("Yes"),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            title: const Text("Log out (iOS / Bottom)"),
            textColor: Colors.red,
            onTap: () {
              showCupertinoDialog(
                // "showCupertion"+"Dialog" 는 외부 클릭 불가, +"ModalPopup" 은 외부 클릭시 해제 ,(ios 에서만 가능한듯, Android는 기본적으로 바깥쪽 선택시 해제됨)
                context: context,
                builder: (context) => CupertinoActionSheet(
                  title: const Text("are your sure?"),
                  message: const Text("plez don go"),
                  actions: [
                    CupertinoActionSheetAction(
                      isDefaultAction: true, // 기본옵션(굵게)
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Not log out"),
                    ),
                    CupertinoActionSheetAction(
                      isDestructiveAction: true, // 강조표시(red)
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Yes plz"),
                    ),
                  ],
                ),
              );
            },
          ),
          const AboutListTile(),
        ],
      ),
    );
  }
}
