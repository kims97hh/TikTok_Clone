import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentification/auth_button.dart';
import 'package:tiktok_clone/features/authentification/view_models/social_auth_view_model.dart';
import 'package:tiktok_clone/features/authentification/widgets/login_screen.dart';
import 'package:tiktok_clone/features/authentification/widgets/username_screen.dart';
import 'package:tiktok_clone/utils.dart';
import 'package:tiktok_clone/generated/l10n.dart';

class SignUpScreen extends ConsumerWidget {
  static String routeURL = "/";
  static String routeName = "signUp";
  const SignUpScreen({super.key});

  void onLoginTap(BuildContext context) async {
    /* final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    ); */
    /*final result = await Navigator.of(context).pushNamed(LoginScreen.routeName);
    print(result);*/
    context.pushNamed(
        LoginScreen.routeName); // .go 를 사용시 뒤로가기가 불가(android, ios 앱 only)
  } //async, await 이용하여 result 값을 받는다.

  void onEmailtap(BuildContext context) {
    /* Navigator.of(context).push(
      PageRouteBuilder(
          transitionDuration: const Duration(seconds: 1),
          reverseTransitionDuration: const Duration(seconds: 1),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const UsernameScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final offsetAnimation = Tween(
              begin: const Offset(0, -1), //(-좌우, -위아래), 1=100%
              end: Offset.zero, //원화면,정상화면
            ).animate(animation);// pageBuilder 의 animation 또는 secondaryAnimation 은 "Animation<double>" 형식이므로, 요구하는 형식과 동일하여 그대로 사용할 수 있다.
            final opacityAnimation = Tween(
              begin: 0.5,
              end: 1.0, // 더블형식 필수
            ).animate(animation);
            return SlideTransition(
              position: offsetAnimation,
              child: FadeTransition(
                opacity: opacityAnimation,
                child: child,
              ),
            );
          }),
    ); */
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const UsernameScreen(),
      ),
    ); // 웹상에서 주소를 표시하지 않기 위해 Navigator1.0 을 사용하였다.
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size40,
              ),
              child: Column(
                children: [
                  Gaps.v80,
                  Text(
                    S.of(context).signUpTitle("TikTok", DateTime.now()),
                    style: const TextStyle(
                        fontSize: Sizes.size24,
                        fontWeight:
                            FontWeight.w700), // "!" 는 정의 되어 있는 내용 , "?" null 허용
                  ),
                  Gaps.v20,
                  Opacity(
                    opacity:
                        0.7, // => 흰색 + 0.7(opacity) => light mode, Dark mode 공통
                    child: Text(
                      S.of(context).signUpsubTitle(
                          1), // pluralization 복수형('s) 에 따른 번역 "변수, plural, =0{번역} =1... other{번역}"
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium, // option#1 => color: isDarkMode(context) ? Colors.grey.shade300: Colors.black45,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Gaps.v40,
                  if (orientation == Orientation.portrait) ...[
                    //"...[]" collection if 문으로 List를 if로 사용할 수 있다.
                    GestureDetector(
                      onTap: () => onEmailtap(context),
                      child: AuthButton(
                        icon: const FaIcon(FontAwesomeIcons.user),
                        text: S.of(context).emailPasswordButton,
                      ),
                    ),
                    Gaps.v16,
                    GestureDetector(
                      onTap: () => ref
                          .read(socialAuthProvider.notifier)
                          .githubSignIn(context),
                      child: const AuthButton(
                        icon: FaIcon(
                          FontAwesomeIcons.github,
                          color: Colors.black,
                        ),
                        text: 'continue with Github',
                      ),
                    ),
                    Gaps.v16,
                    AuthButton(
                      icon: const FaIcon(
                        FontAwesomeIcons.facebook,
                        color: Colors.blue,
                      ),
                      text: S.of(context).faceBookButton,
                    ),
                    Gaps.v16,
                    GestureDetector(
                      onTap: () => ref
                          .read(socialAuthProvider.notifier)
                          .googlesignIn(context),
                      child: AuthButton(
                        icon: const FaIcon(
                          FontAwesomeIcons.google,
                          color: Colors.red,
                        ),
                        text: S.of(context).googleButton,
                      ),
                    ),
                  ],
                  if (orientation == Orientation.landscape)
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => onEmailtap(context),
                            child: AuthButton(
                              icon: const FaIcon(FontAwesomeIcons.user),
                              text: S.of(context).emailPasswordButton,
                            ),
                          ),
                        ),
                        Gaps.h16,
                        Expanded(
                          child: AuthButton(
                            icon: const FaIcon(
                              FontAwesomeIcons.facebook,
                              color: Colors.blue,
                            ),
                            text: S.of(context).faceBookButton,
                          ),
                        ),
                        Gaps.h16,
                        Expanded(
                          child: AuthButton(
                            icon: const FaIcon(FontAwesomeIcons.apple),
                            text: S.of(context).appleButton,
                          ),
                        ),
                        Gaps.h16,
                        Expanded(
                          child: AuthButton(
                            icon: const FaIcon(
                              FontAwesomeIcons.google,
                              color: Colors.red,
                            ),
                            text: S.of(context).googleButton,
                          ),
                        ),
                      ],
                    )
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            color: isDarkMode(context)
                ? null
                : Colors.grey.shade50, //null 값이면 Themdata를 이용한다.
            child: Padding(
              padding: const EdgeInsets.only(
                  top: Sizes.size32, bottom: Sizes.size64),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).alreadyHaveAnAccount,
                    style: const TextStyle(
                        fontSize: Sizes.size16,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600),
                  ),
                  Gaps.h5,
                  GestureDetector(
                    onTap: () => onLoginTap(context),
                    child: Text(
                      S.of(context).logIn(
                          "female"), // "{변수, select, 인수{번역} ... other{번역}"
                      style: TextStyle(
                          fontSize: Sizes.size16,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
