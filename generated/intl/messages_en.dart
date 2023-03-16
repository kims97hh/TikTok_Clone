// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(potato) => "${potato}";

  static String m1(value, value2) =>
      "${value} ${Intl.plural(value2, one: 'Comment', other: 'Comments')}";

  static String m2(potato) => "${potato}";

  static String m3(gender) =>
      "Log in ${Intl.gender(gender, female: 'madam', male: 'sir', other: 'human')}";

  static String m4(nameOfTheApp) => "Log into your ${nameOfTheApp} account";

  static String m5(nameOfTheApp, when) => "Sign up for ${nameOfTheApp} ${when}";

  static String m6(videocount) =>
      "Create a profile, follow other accounts, make your own ${Intl.plural(videocount, zero: 'no videos', one: 'video', other: 'videos')}, and more.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "alreadyHaveAnAccount":
            MessageLookupByLibrary.simpleMessage("Already have an account?"),
        "appleButton":
            MessageLookupByLibrary.simpleMessage("Continue with Apple"),
        "commentCount": m0,
        "commentTitle": m1,
        "emailPasswordButton":
            MessageLookupByLibrary.simpleMessage("Use email & password"),
        "faceBookButton":
            MessageLookupByLibrary.simpleMessage("continue with Facebook"),
        "googleButton":
            MessageLookupByLibrary.simpleMessage("Continue with Google"),
        "likeCount": m2,
        "logIn": m3,
        "loginTitle": m4,
        "signUpTitle": m5,
        "signUpsubTitle": m6
      };
}
