import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentification/auth_button.dart';
import 'package:tiktok_clone/features/authentification/widgets/login_screen.dart';
import 'package:tiktok_clone/features/authentification/widgets/username_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  void onLoginTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  void onEmailtap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const UsernameScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        print(orientation);
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size40,
              ),
              child: Column(
                children: [
                  Gaps.v80,
                  const Text(
                    "Sign up for TicTok",
                    style: TextStyle(
                      fontSize: Sizes.size24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Gaps.v20,
                  const Text(
                    "Create a profile, follow other accounts, make your own videos, and more.",
                    style: TextStyle(
                      fontSize: Sizes.size16,
                      color: Colors.black45,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Gaps.v40,
                  if (orientation == Orientation.portrait) ...[
                    //"...[]" collection if 문으로 List를 if로 사용할 수 있다.
                    GestureDetector(
                      onTap: () => onEmailtap(context),
                      child: const AuthButton(
                        icon: FaIcon(FontAwesomeIcons.user),
                        text: 'Use email & password',
                      ),
                    ),
                    Gaps.v16,
                    const AuthButton(
                      icon: FaIcon(
                        FontAwesomeIcons.facebook,
                        color: Colors.blue,
                      ),
                      text: 'continue with Facebook',
                    ),
                    Gaps.v16,
                    const AuthButton(
                      icon: FaIcon(FontAwesomeIcons.apple),
                      text: 'Continue with Apple',
                    ),
                    Gaps.v16,
                    const AuthButton(
                      icon: FaIcon(
                        FontAwesomeIcons.google,
                        color: Colors.red,
                      ),
                      text: 'Continue with Google',
                    ),
                  ],
                  if (orientation == Orientation.landscape)
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => onEmailtap(context),
                            child: const AuthButton(
                              icon: FaIcon(FontAwesomeIcons.user),
                              text: 'Use email & password',
                            ),
                          ),
                        ),
                        Gaps.h16,
                        const Expanded(
                          child: AuthButton(
                            icon: FaIcon(
                              FontAwesomeIcons.facebook,
                              color: Colors.blue,
                            ),
                            text: 'continue with Facebook',
                          ),
                        ),
                        Gaps.h16,
                        const Expanded(
                          child: AuthButton(
                            icon: FaIcon(FontAwesomeIcons.apple),
                            text: 'Continue with Apple',
                          ),
                        ),
                        Gaps.h16,
                        const Expanded(
                          child: AuthButton(
                            icon: FaIcon(
                              FontAwesomeIcons.google,
                              color: Colors.red,
                            ),
                            text: 'Continue with Google',
                          ),
                        ),
                      ],
                    )
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            elevation: 2,
            color: Colors.grey.shade50,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Sizes.size32,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account?',
                    style: TextStyle(
                        fontSize: Sizes.size16,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600),
                  ),
                  Gaps.h5,
                  GestureDetector(
                    onTap: () => onLoginTap(context),
                    child: Text(
                      'Log in',
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
