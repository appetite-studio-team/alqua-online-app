// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print

import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart';
import 'package:floating_snackbar/floating_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:souq_alqua/helper/db_helper.dart';
import 'package:souq_alqua/screens/authentication/sign_in/sign_in_screen.dart';
import 'package:souq_alqua/screens/home/init_screen.dart';
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  bool isGuestLogin = false;

  set updateGuestLogin(bool value) {
    isGuestLogin = value;
    notifyListeners();
  }

  String? userId;
  String? userName;
  String? emailId;
  String? photoURL;

  Future<void> getPreference() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
    userName = prefs.getString('name');
    emailId = prefs.getString('email');
    // photoURL = "https://tse3.mm.bing.net/th/id/OIG3.KkLDg6bOkvP_3JDIWpZe?pid";
    photoURL =
        "https://tse4.mm.bing.net/th/id/OIG2.lc8mxyreWoiNYxYQh_xa?pid=ImgGn";
    notifyListeners();
  }

  // Future<void> sendOtp(String phoneNumber) async {
  //   await FirebaseAuth.instance.verifyPhoneNumber(
  //     phoneNumber: phoneNumber,
  //     verificationCompleted: (PhoneAuthCredential credential) {},
  //     verificationFailed: (FirebaseAuthException e) {
  //       // Handle verification failure
  //     },
  //     codeSent: (String verificationId, int? resendToken) {
  //       verificationIds = verificationId;
  //       otpSend = true;
  //       log("verificationId: $verificationId");
  //       notifyListeners();
  //       // Navigate to OTP verification screen with verificationId
  //     },
  //     codeAutoRetrievalTimeout: (String verificationId) {
  //       // Auto retrieval timeout
  //     },
  //   );
  // }

  // Future<void> verifyOtp(String otp, BuildContext context) async {
  //   try {
  //     PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //       verificationId: verificationIds,
  //       smsCode: otp,
  //     );
  //     await FirebaseAuth.instance
  //         .signInWithCredential(credential)
  //         .then((value) => Navigator.pushNamed(context, InitScreen.routeName));

  //     // OTP verified, navigate to home screen
  //   } catch (e) {
  //     // Handle verification failure
  //   }
  // }

  // Future<void> resendOtp(String phoneNumber) async {
  //   await FirebaseAuth.instance.verifyPhoneNumber(
  //     phoneNumber: phoneNumber,
  //     verificationCompleted: (PhoneAuthCredential credential) {},
  //     verificationFailed: (FirebaseAuthException e) {
  //       // Handle verification failure
  //     },
  //     codeSent: (String verificationId, int? resendToken) {
  //       verificationIds = verificationId;
  //       otpSend = true;
  //       log("verificationId: $verificationId");
  //       notifyListeners();
  //       // Navigate to OTP verification screen with verificationId
  //     },
  //     codeAutoRetrievalTimeout: (String verificationId) {
  //       // Auto retrieval timeout
  //     },
  //   );
  // }

  bool loginScreenAuthLoader = false;
  void setAuthLoader(bool value) {
    loginScreenAuthLoader = value;
    notifyListeners();
  }

  Future<void> requestOTP() async {
    try {
      final client = Client()
          .setEndpoint(DbHelper.dbUrl)
          .setProject(DbHelper.projectId)
          .setSelfSigned(status: true); // Your project ID

      final account = Account(client);

      final token = await account.createPhoneToken(
          userId: ID.unique(), phone: '+971522086600');

      // final userId = token.userId;

      log('Token ID: ${token.userId}');

      print('OTP sent');
    } catch (e) {
      print('Error: $e');
    }
  }

  //// Google auth
  Future<void> googleLogin({required BuildContext context}) async {
    try {
      loginScreenAuthLoader = true;
      notifyListeners();

      /// Trigger the authentication flow
      final client = Client()
          .setEndpoint(DbHelper.dbUrl)
          .setProject(DbHelper.projectId)
          .setSelfSigned(status: true); // Your project ID

      final account = Account(client);

      // check if web or mobile

      if (kIsWeb) {
        await account.createOAuth2Session(
          provider: OAuthProvider.google,
          success: 'https://store.alqua.online/auth.html',
          scopes: ['email', 'profile'],
        );
      } else {
        await account.createOAuth2Session(
          provider: OAuthProvider.google,
          // scopes: ['email', 'profile'],
        );
      }

      User user = await account.get();

      // if successful, redirect to the home page
      log(user.email);
      log(user.name);

      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('userId', user.$id);
      prefs.setString('email', user.email);
      prefs.setString('name', user.name);

      log('${user.$id}///');
      updateGuestLogin = false;

      /// if the user email is already in users collection then navigate to home screen else add user to users collection
      // DocumentSnapshot userSnapshot =
      //     await _firestore.collection('users').doc(user.email!).get();
      // if (!userSnapshot.exists) {
      //   await _firestore.collection('users').doc(user.email!).set({
      //     'email': user.email,
      //     'name': user.displayName,
      //     'image': user.photoURL,
      //     'uid': user.uid,
      //     'lastLogin': DateTime.now().toString(),
      //   });
      // } else {
      //   await _firestore.collection('users').doc(user.email!).update({
      //     'lastLogin': DateTime.now().toString(),
      //   });
      // }

      loginScreenAuthLoader = false;
      notifyListeners();
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, InitScreen.routeName);
    } on AppwriteException catch (e) {
      log(e.toString(), name: 'error');
      loginScreenAuthLoader = false;
      notifyListeners();
    }
  }

  Future<void> logoutFn({required BuildContext context}) async {
    final client = Client()
        .setEndpoint(DbHelper.dbUrl)
        .setProject(DbHelper.projectId)
        .setSelfSigned(status: true); // Your project ID

    final account = Account(client);
    account.deleteSession(sessionId: 'current').then((value) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return const SignInScreen();
      }), (route) => false);
    });
  }

  /// delete account function
  Future<void> deleteAccount({required BuildContext context}) async {
    final client = Client()
        .setEndpoint(DbHelper.dbUrl)
        .setProject(DbHelper.projectId)
        .setSelfSigned(status: true); // Your project ID
    final account = Account(client);

    try {
      await account.deleteIdentity(identityId: 'current').then((value) async {
        // delete database collection with user userid attribute as emailId
        final database = Databases(client);
        final response = await database.listDocuments(
          databaseId: DbHelper.orderMngmtDbId,
          collectionId: DbHelper.addressCollectionId,
          queries: [Query.equal('userId', emailId)],
        );
        // delete all the addresses of the user
        response.documents.forEach((element) async {
          await database.deleteDocument(
            databaseId: DbHelper.orderMngmtDbId,
            collectionId: DbHelper.addressCollectionId,
            documentId: element.data['\$id'],
          );
        });
        notifyListeners();

        SharedPreferences.getInstance().then((prefs) {
          prefs.clear();
        });
      });

      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return const SignInScreen();
      }), (route) => false);
    } catch (e) {
      // Handle errors here, for example:
      floatingSnackBar(
          message: "'Error deleting account: $e'", context: context);
    }
  }
}
