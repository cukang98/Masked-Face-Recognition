import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseAuth {
  Future<String> signInWithEmail(String email, String password);
  Future<void> signOut();
  Future<String> signInWithGoogle();
  Future<String> getUid();
  Future<String> registerUser(String email, String password, String displayName);
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String> registerUser(String email, String password, String displayName) async {
    String errorMessage;
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = _firebaseAuth.currentUser;
      user.updateDisplayName(user.displayName);
      print('displayName: ${user.displayName}');

    } catch (e) {
      switch (e.code){
        case "email-already-in-use":
          errorMessage = "Your email address already in use.";
          break;
        case "invalid-email":
          errorMessage = "Invalid email address.";
          break;
        case "weak-password":
          errorMessage = "Your password is weak, please try another.";
          break;
      }
    }
    if (errorMessage != null) 
      return Future.error(errorMessage);
    else
      return 'Success register';
  }

  Future<String> signInWithEmail(String email, String password) async {
    String errorMessage;

    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      switch (e.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Your password is wrong.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
    }

    if (errorMessage != null) {
      return Future.error(errorMessage);
    }

    User user = _firebaseAuth.currentUser;
    return await user.getIdToken();
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    await _firebaseAuth.signInWithCredential(credential);
    final User user = _firebaseAuth.currentUser;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User currentUser = _firebaseAuth.currentUser;
    assert(user.uid == currentUser.uid);

    return await user.getIdToken();
  }

  Future<String> getUid() async {
    User user = _firebaseAuth.currentUser;

    return user.uid;
  }

  Future<String> getName() async {
    User user = _firebaseAuth.currentUser;

    return user.displayName;
  }

  Future<User> getUser() async {
    User user = _firebaseAuth.currentUser;

    return user;
  }
}

Auth auth = Auth();