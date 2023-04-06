import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/discover/discover_screen.dart';
import 'package:tiktok_clone/features/inbox/inbox_screen.dart';
import 'package:tiktok_clone/common/widgets/main_navigation/widgets/nav_tab.dart';
import 'package:tiktok_clone/common/widgets/main_navigation/widgets/post_video_button.dart';
import 'package:tiktok_clone/features/user/user_profile_screen.dart';
import 'package:tiktok_clone/utils.dart';
import 'package:tiktok_clone/features/videos/views/video_recording_screen.dart';
import 'package:tiktok_clone/features/videos/views/video_timeline_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  static String routeName = "mainNavigation";

  final String tab;

  const MainNavigationScreen({super.key, required this.tab});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final List<String> _tabs = [
    "home",
    "discover",
    "xxxx",
    "inbox",
    "profile",
  ];

  late int _selectedIndex = _tabs.indexOf(widget.tab); // 앱시작시 초기 화면
  bool _onTapDown = false;

  void _onTap(int index) {
    context.go("/${_tabs[index]}");
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onPostVideoButtonTap() {
    context.pushNamed(VideoRecordingScreen.routeName);
    setState(() {
      _onTapDown = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);
    return Scaffold(
      resizeToAvoidBottomInset:
          false, //키보드 호출시 메인화면 크기를 조절할 것인지 여부.(기본값 - 화면을 재조정(줄임))
      backgroundColor:
          _selectedIndex == 0 || isDark ? Colors.black : Colors.white,
      body: Stack(
        children: [
          Offstage(
            //기본값이 모두숨김
            offstage: _selectedIndex != 0,
            child: const VideoTimelineScreen(),
          ),
          Offstage(
            //기본값이 모두숨김
            offstage: _selectedIndex != 1,
            child: const DiscoverScreen(),
          ),
          Offstage(
            //기본값이 모두숨김
            offstage: _selectedIndex != 3,
            child: const InboxScreen(),
          ),
          Offstage(
            //기본값이 모두숨김
            offstage: _selectedIndex != 4,
            child: const UserProfileScreen(
              username: "hhk",
              tab: "",
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: _selectedIndex == 0 || isDark ? Colors.black : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.size12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NavTab(
                text: "Home",
                isSelected: _selectedIndex == 0,
                icon: FontAwesomeIcons.houseChimneyMedical,
                selectedIcon: FontAwesomeIcons.houseChimneyUser,
                onTap: () => _onTap(0),
                selectedIndex: _selectedIndex,
              ),
              NavTab(
                text: "Discover",
                isSelected: _selectedIndex == 1,
                icon: FontAwesomeIcons.compass,
                selectedIcon: FontAwesomeIcons.solidCompass,
                onTap: () => _onTap(1),
                selectedIndex: _selectedIndex,
              ),
              Gaps.h24,
              GestureDetector(
                onTapDown: (details) {
                  setState(() {
                    _onTapDown = true;
                  });
                },
                onTapUp: (details) => _onPostVideoButtonTap(),
                child: PostVideoButton(
                  onTapDown: _onTapDown,
                  inverted: _selectedIndex != 0,
                ),
              ),
              Gaps.h24,
              NavTab(
                text: "Inbox",
                isSelected: _selectedIndex == 3,
                icon: FontAwesomeIcons.message,
                selectedIcon: FontAwesomeIcons.solidMessage,
                onTap: () => _onTap(3),
                selectedIndex: _selectedIndex,
              ),
              NavTab(
                text: "Profile",
                isSelected: _selectedIndex == 4,
                icon: FontAwesomeIcons.user,
                selectedIcon: FontAwesomeIcons.solidUser,
                onTap: () => _onTap(4),
                selectedIndex: _selectedIndex,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
