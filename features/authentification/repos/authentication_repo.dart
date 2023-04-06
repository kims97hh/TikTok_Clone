import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool get isLoggedIn => user != null;
  User? get user => _firebaseAuth.currentUser;

  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();
  // addlistener 같은 역할, <User> 의 상태변화를 감지하고 있음 "?"는 null 여부
  // .authStateChanges() 의 설명 : Notifies about changes to the user's sign-in state (such as sign-in or sign-out).

  Future<UserCredential> emailSignUp(String email, String password) async {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> signIn(String email, String password) async {
    // try {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    /*  } on FirebaseException catch (exception, stackTrace) {
      return Future.error(AsyncError(exception, stackTrace));
      // firebase 에서는 Exception error 부분을 명시하여 주어야 catch 한다.
    } catch (error, stackTrace) {
      print(error.runtimeType);
      return Future.error(AsyncError(error, stackTrace));
    } */
  }

  // 소셜 미디어 로그인 방법
  // 깃허브
  Future<void> githubSignIn() async {
    await _firebaseAuth.signInWithProvider(GithubAuthProvider());
  }

// 구글 (dependencies: google_sign_in: ^6.0.2 확인)
  Future<void> googleSignIn() async {
    await _firebaseAuth.signInWithProvider(GoogleAuthProvider());
  }
}

final authRepo = Provider((ref) => AuthenticationRepository());

final authState = StreamProvider((ref) {
  final repo = ref.read(authRepo);
  return repo.authStateChanges();
});
