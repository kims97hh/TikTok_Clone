import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/settings/settings_screen.dart';
import 'package:tiktok_clone/features/user/view/avatar.dart';
import 'package:tiktok_clone/features/user/view_models/users_view_model.dart';
import 'package:tiktok_clone/features/user/widgets/persistent_tab_bar.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  final String username;
  final String tab;

  const UserProfileScreen({
    super.key,
    required this.username,
    required this.tab,
  });

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}


class _UserProfileScreenState extends ConsumerState<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  bool _showBarrier = false;

  final bool _isEditingSystem = false;

  bool _isEditingEmail = false;
  bool _isEditingName = false;
  bool _isEditingBio = false;
  bool _isEditingLink = false;
  bool _isEditingBirth = false;

  final _focusNodeEmail = FocusNode();
  final _focusNodeName = FocusNode();
  final _focusNodeBio = FocusNode();
  final _focusNodeLink = FocusNode();
  final _focusNodeBirth = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _inputEmail = TextEditingController();
  final TextEditingController _inputName = TextEditingController();
  final TextEditingController _inputBio = TextEditingController();
  final TextEditingController _inputLink = TextEditingController();
  final TextEditingController _inputBirth = TextEditingController();

  DateTime? _selectedBirth;

  double _formHeight = 30;

  late final AnimationController _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300)); //반드시 late 가 필요하다.

  late final Animation<double> _animation =
      Tween(begin: 0.0, end: 0.5).animate(_animationController);

  late final Animation<Color?> _barrierAnimation =
      ColorTween(begin: Colors.transparent, end: Colors.black38)
          .animate(_animationController);

  late final Animation<Offset> _panelAnmation = Tween(
    begin: const Offset(
        0, -1), // -1 즉, - 100퍼센트 만큼 수직축(dy)위로 옮긴다. (각수치는  %로 이해), 당연히 dx 는 수평축
    end: Offset
        .zero, // 기본값 = 즉 stack 에서 표시되는 화면 그대로의 값 (오프셋 0 은 에니메이션 반영전 값을 나타낸다)
  ).animate(_animationController);

  void _toggleAnimations() async {
    if (_animationController.isCompleted) {
      await _animationController.reverse();
    } else {
      _animationController.forward();
    }
    setState(() {
      _showBarrier = !_showBarrier;
    });
  }

  void setInputValues() {
    Map<String, dynamic> setInputdata = {
      // "email": _inputEmail.text,
      // "name": _inputName,
      "bio": _inputBio.text,
      "link": _inputLink.text,
      "birth": _inputBirth.text,
    };

    ref.read(usersProvider.notifier).onProfileUpdate(setInputdata);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNodeEmail.dispose();
    _focusNodeName.dispose();
    _focusNodeBio.dispose();
    _focusNodeLink.dispose();
    _focusNodeBirth.dispose();
    _inputEmail.dispose();
    _inputName.dispose();
    _inputBio.dispose();
    _inputLink.dispose();
    _inputBirth.dispose();
    super.dispose();
  }

// 여기까지 animationscreen 관련내용


  void _onGearPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(usersProvider).when(
          error: (error, stackTrace) => Center(
            child: Text(
              error.toString(),
            ),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          data: (data) => Scaffold(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,

            body: Stack(
              children: [
                SafeArea(
                  child: DefaultTabController(
                    initialIndex: widget.tab == "likes" ? 1 : 0,
                    length: 2,
                    child: NestedScrollView(
                      physics:
                          const BouncingScrollPhysics(), // SliverAppBar(stretch: stretchMode.. ) 의 기능 활성화 Android 한정
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return [
                          SliverAppBar(
                            centerTitle: true,
                            title: Text(data.name),
                            actions: [
                              GestureDetector(
                                onTap: () {
                                  _toggleAnimations();
                                },
                                child: Icon(
                                  Icons.manage_accounts,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              IconButton(
                                alignment: Alignment.topCenter,
                                onPressed: _onGearPressed,
                                icon: const FaIcon(
                                  FontAwesomeIcons.gear,
                                  size: Sizes.size20,
                                ),
                              ),
                            ],
                          ),
                          SliverToBoxAdapter(
                            child: Column(
                              children: [
                                Avatar(
                                  uid: data.uid,
                                  name: data.name,
                                  hasAvatar: data.hasAvatar,
                                ),
                                Gaps.v20,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "@${data.email}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: Sizes.size18,
                                      ),
                                    ),
                                    Gaps.h5,
                                    FaIcon(
                                      FontAwesomeIcons.solidCircleCheck,
                                      size: Sizes.size16,
                                      color: Colors.blue.shade500,
                                    ),
                                  ],
                                ),
                                Gaps.v24,
                                SizedBox(
                                  height: Sizes.size56,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      UserFollowers(
                                        line1: "37",
                                        line2: "Following",
                                      ),
                                      RowSeparatorLine(),
                                      UserFollowers(
                                        line1: "10.5M",
                                        line2: "Followers",
                                      ),
                                      RowSeparatorLine(),
                                      UserFollowers(
                                        line1: "194.3M",
                                        line2: "Likes",
                                      ),
                                    ],
                                  ),
                                ),
                                Gaps.v14,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: FractionallySizedBox(
                                        widthFactor: 1.1,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: Sizes.size12,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(Sizes.size4),
                                            ),
                                          ),
                                          child: const Text(
                                            "Follow",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Gaps.h16,
                                    const PlayandDropdownButton(
                                      icon: FaIcon(
                                        FontAwesomeIcons.youtube,
                                        size: Sizes.size16,
                                      ),
                                    ),
                                    Gaps.h4,
                                    const PlayandDropdownButton(
                                      icon: FaIcon(
                                        FontAwesomeIcons.chevronDown,
                                        size: Sizes.size16,
                                      ),
                                    ),
                                  ],
                                ),
                                Gaps.v14,
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Sizes.size32,
                                  ),
                                  child: Text(
                                    "All highlights and where to watch live matches on FIFA + I wonder how it would loook",
                                    textAlign: TextAlign.center,
                                    // 코드챌린지, "bio" = text input?
                                  ),
                                ),
                                Gaps.v14,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const FaIcon(
                                      FontAwesomeIcons.link,
                                      size: Sizes.size12,
                                    ),
                                    Gaps.h14,
                                    Text(
                                      data.link,
                                      // 코드챌린지, "link" = http type?
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Gaps.v20,
                              ],
                            ),
                          ),
                          SliverPersistentHeader(
                            delegate: PersistentTabBar(),
                            pinned: true,
                          ),
                        ];
                      },
                      body: TabBarView(
                        children: [
                          GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            itemCount: 20,
                            padding: EdgeInsets.zero,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: Sizes.size2,
                                    mainAxisSpacing: Sizes.size2,
                                    childAspectRatio: 9 / 13.5),
                            itemBuilder: (context, index) => Column(
                              children: [
                                AspectRatio(
                                  aspectRatio: 9 / 13.5, //소숫점이 사용 가능!@
                                  child: Stack(
                                    alignment: Alignment.bottomLeft,
                                    children: [
                                      FadeInImage.assetNetwork(
                                          fit: BoxFit.cover,
                                          placeholderFit: BoxFit.cover,
                                          placeholder:
                                              "assets/images/placeholder.jpg",
                                          image:
                                              "https://images.unsplash.com/photo-1583824093698-e81dede1e8d8?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80"),
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: Sizes.size8,
                                            bottom: Sizes.size3),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.play_arrow_outlined,
                                              color: Colors.white,
                                              size: Sizes.size24,
                                            ),
                                            Gaps.h1,
                                            Text(
                                              "$index.1M",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: Sizes.size16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],

                                  ),
                                ),
                              ],
                            ),

                          ),
                          const Center(
                            child: Text("Page two"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_showBarrier)
                  AnimatedModalBarrier(
                    color: _barrierAnimation,
                    dismissible: true,
                    onDismiss: _toggleAnimations,
                  ),
                SlideTransition(
                  position: _panelAnmation,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).appBarTheme.backgroundColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(Sizes.size5),
                        bottomRight: Radius.circular(Sizes.size5),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Gaps.v40,
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        width: 1,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 5,
                                    ),
                                    child: Text(
                                      "USER PROFILE UPDATE",
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: Sizes.size18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Gaps.v10,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text("UID : "),
                                  Gaps.h10,
                                  SizedBox(
                                    width: 240,
                                    height: 30,
                                    child: TextFormField(
                                      enabled: false,
                                      decoration: InputDecoration(
                                        hintText: data.uid,
                                        labelText: "This is the user id",
                                        border: const OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      if (_isEditingSystem) {
                                        setState(() {
                                          _isEditingName = !_isEditingName;
                                        });
                                      }
                                    },
                                    icon: _isEditingName
                                        ? const Icon(Icons.check)
                                        : const Icon(
                                            Icons.app_settings_alt_rounded),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text("eMail : "),
                                  Gaps.h10,
                                  SizedBox(
                                    width: 240,
                                    height: 30,
                                    child: TextFormField(
                                      enabled: _isEditingEmail,
                                      decoration: InputDecoration(
                                        labelText: data.email,
                                        border: const OutlineInputBorder(),
                                      ),
                                      validator: (value) {
                                        String pattern =
                                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                                        if (value!.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        if (!value.contains(pattern)) {
                                          return "Please enter a valid e-mail";
                                        }
                                        return null;
                                      },

                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      if (_isEditingSystem) {
                                        setState(() {
                                          _isEditingEmail = !_isEditingEmail;
                                        });
                                        if (_inputEmail.text.isEmpty) {
                                          _inputEmail.text = data.email;
                                        }
                                      }
                                    },
                                    icon: _isEditingEmail
                                        ? const Icon(Icons.check)
                                        : const Icon(
                                            Icons.app_settings_alt_rounded),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text("Name : "),
                                  Gaps.h10,
                                  SizedBox(
                                    width: 240,
                                    height: 30,
                                    child: TextFormField(
                                      enabled: _isEditingName,
                                      decoration: InputDecoration(
                                        labelText: data.name,
                                        border: const OutlineInputBorder(),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      if (_isEditingSystem) {
                                        setState(() {
                                          _isEditingName = !_isEditingName;
                                        });
                                        if (_inputName.text.isEmpty) {
                                          _inputName.text = data.name;
                                        }
                                      }
                                    },
                                    icon: _isEditingName
                                        ? const Icon(Icons.check)
                                        : const Icon(
                                            Icons.app_settings_alt_rounded),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text("Bio : "),
                                  Gaps.h10,
                                  SizedBox(
                                    width: 240,
                                    height: 30,
                                    child: TextFormField(
                                      maxLines: 1,
                                      style: const TextStyle(fontSize: 10),
                                      focusNode:
                                          _isEditingBio ? _focusNodeBio : null,
                                      enabled: _isEditingBio,
                                      decoration: InputDecoration(
                                        labelText: _isEditingBio
                                            ? "Please enter your Bio"
                                            : _inputBio.text.isNotEmpty
                                                ? "Changed ${_inputBio.text}"
                                                : data.bio,
                                        border: const OutlineInputBorder(),
                                        errorStyle:
                                            const TextStyle(height: 0.8),
                                      ),
                                      controller: _inputBio,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        if (value.length <= 20) {
                                          return "You can enter up to 20 characters.";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          _isEditingBio = !_isEditingBio;
                                          _formHeight = 30;
                                        });
                                        if (_inputBio.text.isEmpty) {
                                          _inputBio.text = data.bio;
                                        }
                                        FocusScope.of(context)
                                            .requestFocus(_focusNodeBio);
                                      } else {
                                        setState(() {
                                          _formHeight = 50;
                                        });
                                      }
                                    },
                                    icon: _isEditingBio
                                        ? const Icon(Icons.check)
                                        : const Icon(Icons.edit),
                                  ),
                                ],
                              ),
                              Form(
                                key: _formKey,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Text("Link : "),
                                    Gaps.h10,
                                    SizedBox(
                                      width: 240,
                                      height: _formHeight,
                                      child: TextFormField(
                                        focusNode: _isEditingLink
                                            ? _focusNodeLink
                                            : null,
                                        enabled: _isEditingLink,
                                        decoration: InputDecoration(
                                          labelText: _isEditingLink
                                              ? "Please enter valid link (http:// your link)"
                                              : _inputLink.text.isNotEmpty
                                                  ? "Changed to (${_inputLink.text})"
                                                  : data.link,
                                          border: const OutlineInputBorder(),
                                          errorStyle:
                                              const TextStyle(height: 0.8),
                                        ),
                                        controller: _inputLink,
                                        validator: (value) {
                                          String pattern = "http://";
                                          if (value!.isEmpty) {
                                            return null;
                                          }
                                          if (!value.contains(pattern)) {
                                            return "Please enter a valid link('$pattern'yourLink)";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          setState(() {
                                            _isEditingLink = !_isEditingLink;
                                            _formHeight = 30;
                                          });
                                          if (_inputLink.text.isEmpty) {
                                            _inputLink.text = data.link;
                                          }
                                          FocusScope.of(context)
                                              .requestFocus(_focusNodeLink);
                                        } else {
                                          setState(() {
                                            _formHeight = 50;
                                          });
                                        }
                                      },
                                      icon: _isEditingLink
                                          ? const Icon(Icons.check)
                                          : const Icon(Icons.edit),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text("Birth : "),
                                  Gaps.h10,
                                  SizedBox(
                                    width: 240,
                                    height: 30,
                                    child: TextFormField(
                                      enabled: _isEditingBirth,
                                      decoration: InputDecoration(
                                        labelText: data.birth,
                                        border: const OutlineInputBorder(),
                                      ),
                                      controller: TextEditingController(
                                          text: _selectedBirth != null
                                              ? '${_selectedBirth!.year}-${_selectedBirth!.month.toString().padLeft(2, '0')}-${_selectedBirth!.day.toString().padLeft(2, '0')}'
                                              : data.birth),
                                      validator: (value) {
                                        RegExp dateRegexp =
                                            RegExp(r'^\d{4}-\d{2}-\d{2}$');
                                        if (value!.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        if (!value.contains(dateRegexp)) {
                                          return "Please enter a valid 'yyyy-mm-dd'";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      if (!_isEditingBirth) {
                                        final selectedDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1950),
                                          lastDate: DateTime(2030),
                                        );
                                        if (selectedDate != null) {
                                          _inputBirth.text =
                                              "${selectedDate.year.toString()}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                                        }
                                        if (_inputBirth.text.isEmpty) {
                                          _inputBirth.text = data.birth;
                                        }
                                        setState(() {
                                          _selectedBirth = selectedDate;
                                          _isEditingBirth = !_isEditingBirth;
                                        });
                                      } else {
                                        setState(() {
                                          _isEditingBirth = !_isEditingBirth;
                                        });
                                      }
                                    },
                                    icon: Icon(_isEditingBirth
                                        ? Icons.check
                                        : Icons.calendar_month_outlined),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (!_isEditingEmail &&
                                          !_isEditingName &&
                                          !_isEditingBio &&
                                          !_isEditingLink &&
                                          !_isEditingBirth) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            icon: const FaIcon(
                                              FontAwesomeIcons.listCheck,
                                            ),
                                            title: const Text("are your sure?"),
                                            content: const Text(
                                              "Change your Profile",
                                              textAlign: TextAlign.center,
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  if (_inputBio.text == "") {
                                                    _inputBio.text = data.bio;
                                                  }
                                                  if (_inputLink.text == "") {
                                                    _inputLink.text = data.link;
                                                  }
                                                  if (_inputBirth.text == "") {
                                                    _inputBirth.text =
                                                        data.birth;
                                                  }
                                                  setInputValues();
                                                  Navigator.of(context).pop();
                                                  _toggleAnimations();
                                                }, // 데이터를 넘겨주는 곳
                                                child: const Text("Yes"),
                                              ),
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                child: const Text("No"),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 1),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            width: 1,
                                          )),
                                      child: const Text("Submit"),
                                    ),
                                  ),
                                  Gaps.h10,
                                  GestureDetector(
                                    onTap: _toggleAnimations,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 1),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            width: 1,
                                          )),
                                      child: const Text("Cancel"),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ],

            ),
          ),
        );
  }
}

class PlayandDropdownButton extends StatelessWidget {
  const PlayandDropdownButton({
    super.key,
    required this.icon,
  });

  final FaIcon icon;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: FractionallySizedBox(
        widthFactor: 0.33,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: Sizes.size12,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            color: Colors.white,
            borderRadius: const BorderRadius.all(
              Radius.circular(Sizes.size4),
            ),
          ),
          child: Center(
            child: icon,
          ),
        ),
      ),
    );
  }
}

class RowSeparatorLine extends StatelessWidget {
  const RowSeparatorLine({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return VerticalDivider(
      width: Sizes.size32,
      thickness: Sizes.size1,
      color: Colors.grey.shade400,
      indent:
          Sizes.size14, //father 높이의 최상단부터 여백 (SizedBox로 최상단, 바닥의 범위를 정하여야 한다)
      endIndent: Sizes.size14, //father 바닥의 최하단부터 여백
    );
  }
}

class UserFollowers extends StatelessWidget {
  const UserFollowers({
    super.key,
    required this.line1,
    required this.line2,
  });

  final String line1;
  final String line2;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          line1,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Sizes.size18,
          ),
        ),
        Gaps.v3,
        Text(
          line2,
          style: TextStyle(
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}
