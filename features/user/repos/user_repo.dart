import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/user/model/user_profile_model.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // create profile, 사용자 신규가입후 개별정보를 기록한다.
  Future<void> createProfile(UserProfileModel profile) async {
    await _db.collection("users").doc(profile.uid).set(profile.toJson());
    // 위의 형식은 /users/uid/각각정보 => firestore 에 만들어놓은 db 에 저장 하는 경로가 표현되었다.
    // _db.collection("user") = 최상위 user 폴더
    // .doc(profile.uid) = /user/ 하위의 UID 고유번호 폴더
    // .set(profile.toJson()) /user/uid/각정보 => .set으로 기록한다(프로파일의 json 변환 정보)
  }

  // get profile, 사용자 로그인후 개별 정보를 읽어와 반영한다.
  // update profile(avatar, bio, link..etc) 각개별 수정 또는 한번에 모두 수정
  Future<Map<String, dynamic>?> findProfile(String uid) async {
    final doc = await _db.collection("users").doc(uid).get();
    return doc.data();
  }
}

final userRepo = Provider((ref) => UserRepository());
