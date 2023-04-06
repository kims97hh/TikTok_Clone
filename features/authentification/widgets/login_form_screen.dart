import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentification/repos/login_view_model.dart';
import 'package:tiktok_clone/features/authentification/widgets/form_button.dart';

class LoginFormScareen extends ConsumerStatefulWidget {
  const LoginFormScareen({super.key});

  @override
  ConsumerState<LoginFormScareen> createState() => _LoginFormScareenState();
}

class _LoginFormScareenState extends ConsumerState<LoginFormScareen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, String> formData = {};

  void _onSubmitTab() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        ref.read(loginProvider.notifier).login(
              formData["email"]!,
              formData["password"]!,
              context,
            );
        // String? 으로 표시된 err는 null 일수 있음을 표시하므로 "!" 를 붙여주어 값이 있음을 알려준다.
        // context.goNamed(InterestsScreen.routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log in'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.size36),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Gaps.v28,
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Email',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "Please Write your email";
                  }
                  return null;
                  //"i dont like your email";
                },
                onSaved: (newValue) {
                  if (newValue != null) {
                    formData['email'] = newValue;
                  }
                },
              ),
              Gaps.v16,
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Password',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "Please write your password";
                  }
                  return null;

                  //"wrong password";
                },
                onSaved: (newValue) {
                  if (newValue != null) {
                    formData['password'] = newValue;
                  }
                },
              ),
              Gaps.v28,
              GestureDetector(
                onTap: _onSubmitTab,
                child: FormButton(
                  disable: ref.watch(loginProvider).isLoading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
