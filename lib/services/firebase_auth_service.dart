import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tal3a/data/models/user_model.dart';
import 'package:tal3a/firebase_options.dart';

class FirebaseAuthService {
  static FirebaseAuthService instance = FirebaseAuthService._internal();
  FirebaseAuthService._internal();
  String webClientid =
      "531231308653-sek6esieuvt592t7vqtmgapf4on52dgd.apps.googleusercontent.com";

  init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  signInEmailPassword({required String email, required String password}) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on SocketException {
      throw "No Internet Connection";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw "No Account Provided For That Email";
      } else if (e.code == 'wrong-password') {
        throw "Wrong Password Provided For That User";
      } else {
        throw "User not found";
      }
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
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
        throw "No Account Provided For That Email";
      }

      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: accessToken,
      );

      final userCred = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      return userCred;
    } on SocketException {
      throw "No Internet Connection";
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "There was an error, Please try again later";
    } catch (e) {
      throw e.toString();
    }
  }

  forgetPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    } on SocketException {
      throw "No Internet Connection";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'There is no user for that email';
      } else if (e.code == 'invalid-email') {
        throw 'Your email is invalid';
      } else {
        throw 'Unexpected error has happened';
      }
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
      final credintals = await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set({
            'username': username,
            'email': email,
            'createdAt': FieldValue.serverTimestamp(),
          });
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw "Your password is weak";
      } else if (e.code == 'email-already-in-use') {
        throw "The email is already used";
      } else {
        log(e.code);
        throw e.code;
      }
    }
  }

  Future<UserCredential?> signUpWithGoogle() async {
    try {
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

      return userCred;
    } on SocketException {
      throw "No Internet Connection";
    } catch (e) {
      log(e.toString());
      throw "There was an error, Please try again later";
    }
  }
}
