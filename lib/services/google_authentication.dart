import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthService({required FirebaseAuth firebaseAuth, required GoogleSignIn googleSignIn})
      : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn;

  Future<User?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    final googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    final authResult = await _firebaseAuth.signInWithCredential(credential);
    return authResult.user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}

Future<UserCredential> signWebInWithGoogle() async {
  GoogleAuthProvider googleProvider = GoogleAuthProvider();
  googleProvider.setCustomParameters({
    'login_hint': 'user@example.com'
  });
  return await FirebaseAuth.instance.signInWithPopup(googleProvider);
}

class GoogleSignInProvider extends ChangeNotifier{

  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    final googleUser = await googleSignIn.signIn();
    if(googleUser == null) return;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    notifyListeners();
  }

}