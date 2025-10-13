import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:splash_screen/core/constants/colors.dart';
import 'package:splash_screen/core/constants/globals.dart';
import 'package:splash_screen/features/authentication/login_screen.dart';
import 'package:splash_screen/features/home/screens/home_screen.dart';
import 'package:splash_screen/firebase_options.dart';

class FirebaseService {
  static FirebaseService instance = FirebaseService._internal();
  bool isloading = false;
  FirebaseService._internal();
  String webClientid =
      "531231308653-sek6esieuvt592t7vqtmgapf4on52dgd.apps.googleusercontent.com";

  init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  signInemailPassword({required String email, required String password}) async {
    try {
      isloading = true;
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      navigationkey.currentState?.push(
        MaterialPageRoute(
          builder: (context) {
            return HomeScreen();
          },
        ),
      );
    } on FirebaseAuthException catch (e) {
      isloading = false;
      if (e.code == 'user-not-found') {
        snackbarKey.currentState?.showSnackBar(
          SnackBar(
            content: Text('Try Adding Valid User'),
            duration: Duration(seconds: 2),
            backgroundColor: primaryBlue,
          ),
        );
      } else if (e.code == 'wrong-password') {
        snackbarKey.currentState?.showSnackBar(
          SnackBar(
            content: Text('Wrong Password Provided For That User'),
            duration: Duration(seconds: 2),
            backgroundColor: primaryBlue,
          ),
        );
      } else {
        snackbarKey.currentState?.showSnackBar(
          SnackBar(
            content: Text('Please Check Your Credintials'),
            duration: Duration(seconds: 2),
            backgroundColor: primaryBlue,
          ),
        );
      }
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      isloading = true;
      final signIn = GoogleSignIn.instance;

      await signIn.initialize(serverClientId: webClientid);

      final GoogleSignInAccount? googleUser = await signIn.authenticate();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication auth = await googleUser.authentication;
      final String? idToken = auth.idToken;

      final String? accessToken = await (() async {
        final GoogleSignInClientAuthorization? authz = await googleUser
            .authorizationClient
            .authorizationForScopes(<String>['email', 'profile', 'openid']);
        return authz?.accessToken;
      })();

      if (idToken == null && accessToken == null) {
        throw Exception('');
      }

      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: accessToken,
      );

      final userCred = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      navigationkey.currentState?.push(
        MaterialPageRoute(
          builder: (context) {
            return HomeScreen();
          },
        ),
      );

      return userCred;
    } catch (e) {
      snackbarKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('No Account Provided For That Email'),
          duration: Duration(seconds: 2),
          backgroundColor: primaryBlue,
        ),
      );
    }
    return null;
  }

  forgetPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      snackbarKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            'If this email is registered, a reset link has been sent.',
          ),
          duration: Duration(seconds: 2),
          backgroundColor: primaryBlue,
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Unexpected error has happened';
      if (e.code == 'user-not-found') {
        message = 'There is no user for that email';
      } else if (e.code == 'invalid-email') {
        message = 'Your email is invalid';
      }
      snackbarKey.currentState?.showSnackBar(
        SnackBar(content: Text(message), backgroundColor: primaryBlue),
      );
    }
  }

  signUpemailPassword({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set({
            'username': username,
            'email': email,
            'createdAt': FieldValue.serverTimestamp(),
          });

      navigationkey.currentState?.push(
        MaterialPageRoute(
          builder: (context) {
            return LoginScreen();
          },
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Unexpected error has happened';
      if (e.code == 'weak-password') {
        message = "Your password is weak";
      } else if (e.code == 'email-already-in-use') {
        message = "The email is already used";
      }
      snackbarKey.currentState?.showSnackBar(
        SnackBar(content: Text(message), backgroundColor: primaryBlue),
      );
    }
  }

  Future<UserCredential?> signUpWithGoogle() async {
    try {
      isloading = true;
      final signIn = GoogleSignIn.instance;

      await signIn.initialize(serverClientId: webClientid);

      final GoogleSignInAccount? googleUser = await signIn.authenticate();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication auth = await googleUser.authentication;
      final String? idToken = auth.idToken;

      final String? accessToken = await (() async {
        final GoogleSignInClientAuthorization? authz = await googleUser
            .authorizationClient
            .authorizationForScopes(<String>['email', 'profile', 'openid']);
        return authz?.accessToken;
      })();

      if (idToken == null && accessToken == null) {
        throw Exception('');
      }

      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: accessToken,
      );

      final userCred = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      if (userCred.additionalUserInfo!.isNewUser) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCred.user!.uid)
            .set({
              'username': userCred.user!.displayName,
              'email': userCred.user!.email,
              'photoUrl': userCred.user!.photoURL,
              'createdAt': FieldValue.serverTimestamp(),
            });
      }
      navigationkey.currentState?.push(
        MaterialPageRoute(
          builder: (context) {
            return LoginScreen();
          },
        ),
      );

      return userCred;
    } catch (e) {
      log(e.toString());
      snackbarKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('There was an error'),
          duration: Duration(seconds: 2),
          backgroundColor: primaryBlue,
        ),
      );
    }
    return null;
  }
}
