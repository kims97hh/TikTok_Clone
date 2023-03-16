import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/videos/video_recording_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const VideoRecordingScreen(),
    ),
  ],
);


/* 기타 예제 

    // GoRoute(
    //   name: SignUpScreen.routeName,
    //   path: SignUpScreen.routeURL,
    //   builder: (context, state) => const SignUpScreen(),
    //   routes: [
    //     GoRoute(
    //       path: UsernameScreen.routeURL,
    //       name: UsernameScreen.routeName,
    //       builder: (context, state) => const UsernameScreen(),
    //       routes: [
    //         GoRoute(
    //           path: EmailScreen.routeURL,
    //           name: EmailScreen.routeName,
    //           builder: (context, state) {
    //             final arg = state.extra as EmailScreenArgs;
    //             return EmailScreen(username: arg.username);
    //           },
    //         ),
    //       ],
    //     ),
    //   ],
    // ), //네스트 타입의 (URL Tree) GoRoute 에제

    // GoRoute(
    //   name: "username_screen",
    //   path: UsernameScreen.routeName,
    //   pageBuilder: (context, state) {
    //     return CustomTransitionPage(
    //       child: const UsernameScreen(),
    //       transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //         return FadeTransition(
    //           opacity: animation,
    //           child: ScaleTransition(
    //             scale: animation,
    //             child: child,
    //           ),
    //         );
    //       },
    //     );
    //   },
    // ), // GoRoute 에서 page 전환 Animation 예제

    // GoRoute(
    //   path: "/users/:username",
    //   builder: (context, state) {
    //     final username = state.params['username'];
    //     final tab = state.queryParams["show"];
    //     return UserProfileScreen(
    //       username: username!,
    //       tab: tab!,
    //     );
    //   },
    // ), // Url 의 데이터를 이용하는 예제

*/
