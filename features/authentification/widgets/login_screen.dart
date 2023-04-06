import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentification/auth_button.dart';
import 'package:tiktok_clone/features/authentification/view_models/social_auth_view_model.dart';
import 'package:tiktok_clone/features/authentification/widgets/login_form_screen.dart';
import 'package:tiktok_clone/utils.dart';

class LoginScreen extends ConsumerWidget {
  static String routeURL = "/login";
  static String routeName = "login";
  const LoginScreen({super.key});

  void _onSignTap(BuildContext context) {
    context.pop();
  }

  void _onEmailLoginTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginFormScareen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ConsumerWidget 에서는 WidgetRef ref 변수가 필요하다.
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
                "Log in to TicTok",
                style: TextStyle(
                    fontSize: Sizes.size24, fontWeight: FontWeight.w700),
              ),
              Gaps.v20,
              const Opacity(
                opacity: 0.7,
                child: Text(
                  "Manage your account, check notifications, comment on videos, and more.",
                  style: TextStyle(
                    fontSize: Sizes.size16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Gaps.v40,
              GestureDetector(
                onTap: () => _onEmailLoginTap(context),
                child: const AuthButton(
                  icon: FaIcon(FontAwesomeIcons.user),
                  text: 'Use email & password',
                ),
              ),
              Gaps.v16,
              GestureDetector(
                onTap: () =>
                    ref.read(socialAuthProvider.notifier).githubSignIn(context),
                child: const AuthButton(
                  icon: FaIcon(
                    FontAwesomeIcons.github,
                    color: Colors.black,
                  ),
                  text: 'continue with Github',
                ),
              ),
              Gaps.v16,
              const AuthButton(
                icon: FaIcon(FontAwesomeIcons.facebook),
                text: 'Continue with Facebook',
              ),
              Gaps.v16,
              GestureDetector(
                onTap: () =>
                    ref.read(socialAuthProvider.notifier).googlesignIn(context),
                child: const AuthButton(
                  icon: FaIcon(
                    FontAwesomeIcons.google,
                    color: Colors.red,
                  ),
                  text: 'Continue with Google',
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: isDarkMode(context) ? null : Colors.grey.shade50,
        child: Padding(
          padding: const EdgeInsets.only(
            top: Sizes.size32,
            bottom: Sizes.size64,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Don't have an account?",
                style: TextStyle(
                    fontSize: Sizes.size16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600),
              ),
              Gaps.h5,
              GestureDetector(
                onTap: () => _onSignTap(context),
                child: Text(
                  'Sign up',
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
  }
}
