// MVVM Architecture기초
// ..model => 저장소선언,(app에서 사용되는 data & process)
// ..view => 사용자 표시 화면,(UI)
// ..viewmodel => 저장/로딩 (view(UI)에 처리된 자료 전송,공유, model(data & process) 데이터 처리 )

class UserProfileModel {
  final String uid;
  final String email;
  final String name;
  final String bio;
  final String link;
  final bool hasAvatar;
  final String birth;

  UserProfileModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.bio,
    required this.link,
    required this.hasAvatar,
    required this.birth,
  });

  UserProfileModel.empty()
      : uid = "",
        email = "",
        name = "",
        bio = "",
        link = "",
        hasAvatar = false,
        birth = "";

  UserProfileModel.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        email = json["email"],
        name = json["name"],
        bio = json["bio"],
        link = json["link"],
        hasAvatar = json["hasAvatar"],
        birth = json["birth"];

  // firebase 에 _db 전송을 json 형식으로 변환하기 위함
  Map<String, String> toJson() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
      "bio": bio,
      "link": link,
      "birth": birth,
    };
  }

  UserProfileModel copyWith({
    // ({}) Named parameter
    String? uid,
    String? email,
    String? name,
    String? bio,
    String? link,
    bool? hasAvatar,
    String? birth,
  }) {
    return UserProfileModel(
        // .copyWith 에서 받아온 정보가 null 이면 기본정보(this.~) 를 사용 즉, UserProfileModel.copyWith() => UserProfileModel 에 null 인경우만 반영, new 인경우에도 반영할 수 있을듯 (update?)
        uid: uid ?? this.uid,
        email: email ?? this.email,
        name: name ?? this.name,
        bio: bio ?? this.bio,
        link: link ?? this.link,
        hasAvatar: hasAvatar ?? this.hasAvatar,
        birth: birth ?? this.birth);

        // 이것은 기존 정보를 [수정]할 수 없으므로(db) 새로운 데이터를 만들고 현존하는 정보가 있으면 현재의 정보를 없으면 기존의 정보를 대입한후, 다시 전체를 올려 덮어 씌우게 된다.
  }
}
