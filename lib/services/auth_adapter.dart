
import 'package:google_sign_in/google_sign_in.dart';

import 'auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthServiceAdapter implements AuthService{
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  static Future<User?> signInUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    User? user;

    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
          AuthServiceAdapter.customSnackBar(
            content: 'No user found for that email. Please create an account.',
          ),
        );
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
        ScaffoldMessenger.of(context).showSnackBar(
          AuthServiceAdapter.customSnackBar(
            content: 'Wrong password provided.',
          ),
        );
      }
    }

    return user;
  }

  static Future<User?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = userCredential.user;
      await user!.updateProfile(displayName: name);
      await user.reload();
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        ScaffoldMessenger.of(context).showSnackBar(
          AuthServiceAdapter.customSnackBar(
            content: 'The password provided is too weak.',
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
          AuthServiceAdapter.customSnackBar(
            content: 'The account already exists for that email.',
          ),
        );
      }
    } catch (e) {
      print(e);
    }

    return user;
  }

  static Future<User?> refreshUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await user.reload();
    User? refreshedUser = auth.currentUser;

    return refreshedUser;
  }

  @override
  dispose() {
  }

  static Future<User?> signInAnonimously({required BuildContext context}) async {
    User? user=(await _firebaseAuth.signInAnonymously()).user;
    return user;
  }

  static Future<void> signOut() async {
    if ((await _googleSignInAccount!.authentication).accessToken!=null)
      _googleSignIn!.disconnect();

    await _firebaseAuth.signOut();
  }

  static GoogleSignIn? _googleSignIn;
  static GoogleSignInAccount? _googleSignInAccount;


  static Future<User?> signInWithGoogle() async {
    // Trigger the authentication flow
    _googleSignIn= GoogleSignIn();
    _googleSignInAccount = await _googleSignIn!.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await _googleSignInAccount!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    var cr= await FirebaseAuth.instance.signInWithCredential(credential);
    return cr.user;
  }
}
