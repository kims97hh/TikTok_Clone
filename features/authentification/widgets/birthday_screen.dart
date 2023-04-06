import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentification/view_models/signup_view_model.dart';
import 'form_button.dart';

class BirthdayScreen extends ConsumerStatefulWidget {
  const BirthdayScreen({super.key});

  @override
  ConsumerState<BirthdayScreen> createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends ConsumerState<BirthdayScreen> {
  final TextEditingController _birthdayController = TextEditingController();
  int ageLimitYear = 12; //연령제한

  DateTime initialdate = DateTime.now();

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    initialdate = DateTime(now.year - ageLimitYear, now.month,
        now.day); // 연령제한 년수 "-" 와 오늘 월/일을 지정, 미지정시 1월1일표시

    _setTextFieldDate(initialdate);
  }

  @override
  void dispose() {
    _birthdayController.dispose();
    super.dispose();
  }

  void _onNextTap() {
    final String textDate =
        _birthdayController.value.toString().split("┤")[1].split("├")[0];
    final state = ref.read(signUpForm.notifier).state;
    ref.read(signUpForm.notifier).state = {
      ...state, // final state 에 모든 list 와 ,~
      "bio": textDate,
    };
    ref.read(signUpProvider.notifier).signUp(context);
    // context.goNamed(InterestsScreen.routeName);
  }

  void _setTextFieldDate(DateTime date) {
    final textDate = date.toString().split(" ").first;
    _birthdayController.value = TextEditingValue(text: textDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign up"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size36,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.v40,
            const Text(
              "When's your birthday?",
              style: TextStyle(
                fontSize: Sizes.size24,
                fontWeight: FontWeight.w700,
              ),
            ),
            Gaps.v8,
            const Text(
              "Your birthday won't be shown publicly.",
              style: TextStyle(
                fontSize: Sizes.size16,
                color: Colors.black54,
              ),
            ),
            Gaps.v16,
            TextField(
              enabled: false,
              controller: _birthdayController,
              onEditingComplete: _onNextTap,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              cursorColor: Theme.of(context).primaryColor,
            ),
            Gaps.v5,
            Text(
              "Age $ageLimitYear and older can sign up",
              style: TextStyle(color: Colors.grey.shade600),
            ),
            Gaps.v16,
            GestureDetector(
              onTap: _onNextTap,
              child: FormButton(
                  disable: ref
                      .watch(signUpProvider)
                      .isLoading), // 비활성조건,=입력값이 조건에 못 미치거나, firebase 작업중이거나
            ),
            Gaps.v20,
            SizedBox(
              height: 400,
              child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  maximumDate: initialdate,
                  initialDateTime: initialdate,
                  onDateTimeChanged: _setTextFieldDate),
            ),
          ],
        ),
      ),
    );
  }
}
