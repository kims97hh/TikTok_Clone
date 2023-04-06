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

  UserProfileModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.bio,
    required this.link,
  });

  UserProfileModel.empty()
      : uid = "",
        email = "",
        name = "",
        bio = "",
        link = "";

  UserProfileModel.fromJson(Map<String, dynamic> json)
      : uid = json["uid"],
        email = json["email"],
        name = json["name"],
        bio = json["bio"],
        link = json["link"];

  // firebase 에 _db 전송을 json 형식으로 변환하기 위함
  Map<String, String> toJson() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
      "bio": bio,
      "link": link,
    };
  }
}
