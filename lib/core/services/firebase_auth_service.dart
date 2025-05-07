import 'dart:convert';
import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:crypto/crypto.dart';
import 'package:appointify_app/core/errors/exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAuthService {

  Future<User> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          throw CustomException(messageKey: 'The password is too weak.');
        case 'email-already-in-use':
          throw CustomException(messageKey: 'You are already registered. Please sign in.');
        case 'network-request-failed':
          throw CustomException(messageKey: 'Please check your internet connection.');
        default:
          throw CustomException(messageKey: 'An error occurred. Please try again later.');
      }
    } catch (e) {
      throw CustomException(messageKey: 'An error occurred. Please try again later.');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      // Use standard Firebase password reset (no custom domains required)
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      
      // Note: We're using the standard Firebase password reset flow
      // Users will be directed to the Firebase default password reset page
      // After resetting their password, they can return to the app to sign in
    } on FirebaseAuthException catch (e) {
      log('Firebase auth exception in sendPasswordResetEmail: ${e.code} - ${e.message}');
      String errorMessage;
      
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email address.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'unauthorized-domain':
          errorMessage = 'Your app domain is not authorized for this operation. Please check Firebase console.';
          break;
        default:
          errorMessage = 'Failed to send password reset email. Please try again.';
      }
      
      throw CustomException(messageKey: errorMessage);
    } catch (e) {
      log('Exception in sendPasswordResetEmail: ${e.toString()}');
      throw CustomException(messageKey: 'An error occurred. Please try again later.');
    }
  }

  Future<void> updatePasswordWithEmail(String email, String newPassword) async {
    try {
      HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
          'updateUserPassword');
      final result = await callable.call({
        'email': email,
        'newPassword': newPassword,
      });

      if (result.data['success'] != true) {
        throw Exception('Failed to update password');
      }
    } catch (e) {
      throw Exception('Error updating password: $e');
    }
  }

  Future<User> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      log("Exception in FirebaseAuthService.signInWithEmailAndPassword: ${e
          .toString()} and code is ${e.code}");
      if (e.code == 'user-not-found') {
        throw CustomException(
            messageKey: 'The email or password is incorrect.');
      } else if (e.code == 'wrong-password') {
        throw CustomException(
            messageKey: 'The email or password is incorrect.');
      } else if (e.code == 'invalid-credential') {
        throw CustomException(
            messageKey: 'The email or password is incorrect.');
      } else if (e.code == 'network-request-failed') {
        throw CustomException(messageKey: 'Please check your internet connection.');
      } else {
        throw CustomException(
            messageKey: 'An error occurred. Please try again later.');
      }
    } catch (e) {
      log("Exception in FirebaseAuthService.signInWithEmailAndPassword: ${e
          .toString()}");

      throw CustomException(
          messageKey: 'An error occurred. Please try again later.');
    }
  }

  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
    await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return (await FirebaseAuth.instance.signInWithCredential(credential)).user!;
  }


  Future<User> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();

    final OAuthCredential facebookAuthCredential = FacebookAuthProvider
        .credential(loginResult.accessToken!.tokenString);

    return (await FirebaseAuth.instance.signInWithCredential(
        facebookAuthCredential)).user!;
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<User> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    return (await FirebaseAuth.instance.signInWithCredential(oauthCredential))
        .user!;
  }

  bool isLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  Future deleteUser() async {
    await FirebaseAuth.instance.currentUser!.delete();
  }

  Future<void> signOut() async {
    try {

      // Firebase Sign-Out
      await FirebaseAuth.instance.signOut();

      // Google Sign-Out
      final googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }

      // Facebook Sign-Out
      final accessToken = await FacebookAuth.instance.accessToken;
      if (accessToken != null) {
        await FacebookAuth.instance.logOut();
      }

      print('Successfully signed out from all providers');
    } catch (e) {
      print('Error during sign out: $e');
      throw Exception('Error signing out: ${e.toString()}');
    }
  }


}