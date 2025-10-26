import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tal3a/core/core.dart';
import 'package:tal3a/features/authentication/presentation/screens/login_screen.dart';
import 'package:tal3a/features/home/screens/home_page.dart';
import 'package:tal3a/firebase_options.dart';


class FirebaseService {
  static FirebaseService instance = FirebaseService._internal();
  bool isLoading = false;
  FirebaseService._internal();
  String webClientId =
      "531231308653-sek6esieuvt592t7vqtmgapf4on52dgd.apps.googleusercontent.com";

  init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  signInEmailPassword({required String email, required String password}) async {
    try {
      isLoading = true;
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      navigationKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) {
            return HomePage();
          },
        ),
      );
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      if (e.code == 'user-not-found') {
        snackBarKey.currentState?.showSnackBar(
          SnackBar(
            content: Text('Try Adding Valid User'),
            duration: Duration(seconds: 2),
            backgroundColor:  AppColors.primaryBlue,
          ),
        );
      } else if (e.code == 'wrong-password') {
        snackBarKey.currentState?.showSnackBar(
          SnackBar(
            content: Text('Wrong Password Provided For That User'),
            duration: Duration(seconds: 2),
            backgroundColor: AppColors.primaryBlue,
          ),
        );
      } else {
        snackBarKey.currentState?.showSnackBar(
          SnackBar(
            content: Text('User not found'),
            duration: Duration(seconds: 2),
            backgroundColor:  AppColors.primaryBlue,
          ),
        );
      }
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      isLoading = true;
      final signIn = GoogleSignIn.instance;

      await signIn.initialize(serverClientId: webClientId);

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

      navigationKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) {
            return HomePage();
          },
        ),
      );

      return userCred;
    } catch (e) {
      snackBarKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('No Account Provided For That Email'),
          duration: Duration(seconds: 2),
          backgroundColor:  AppColors.primaryBlue,
        ),
      );
    }
    return null;
  }

  forgetPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      snackBarKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(
            'If this email is registered, a reset link has been sent.',
          ),
          duration: Duration(seconds: 2),
          backgroundColor:  AppColors.primaryBlue,
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Unexpected error has happened';
      if (e.code == 'user-not-found') {
        message = 'There is no user for that email';
      } else if (e.code == 'invalid-email') {
        message = 'Your email is invalid';
      }
      snackBarKey.currentState?.showSnackBar(
        SnackBar(content: Text(message), backgroundColor:  AppColors.primaryBlue),
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

      navigationKey.currentState?.push(
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
      snackBarKey.currentState?.showSnackBar(
        SnackBar(content: Text(message), backgroundColor:  AppColors.primaryBlue),
      );
    }
  }

  Future<UserCredential?> signUpWithGoogle() async {
    try {
      isLoading = true;
      final signIn = GoogleSignIn.instance;

      await signIn.initialize(serverClientId: webClientId);

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
      navigationKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) {
            return LoginScreen();
          },
        ),
      );

      return userCred;
    } catch (e) {
      log(e.toString());
      snackBarKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('There was an error'),
          duration: Duration(seconds: 2),
          backgroundColor:  AppColors.primaryBlue,
        ),
      );
    }
    return null;
  }
}
