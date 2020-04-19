import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../home_page.dart';
import '../sign_up.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthService{
  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return SignUp();
          }
        });
  }

  signInWithOTP(smsCode, verId) {
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    FirebaseAuth.instance.signInWithCredential(authCreds);
  }
}