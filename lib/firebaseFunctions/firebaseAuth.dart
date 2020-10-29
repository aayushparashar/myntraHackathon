import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseAuthentication {
  static String phoneNumber;
  static FirebaseAuth auth = FirebaseAuth.instance;
  static String _otpSent;
static logout(){
  auth.signOut();
}
  static verifyPhoneNumber(String phoneNumber) {
    FirebaseAuthentication.phoneNumber = phoneNumber;
    auth.verifyPhoneNumber(phoneNumber: '+91$phoneNumber',
        verificationCompleted: (credential) {
          auth.signInWithCredential(credential);
          Fluttertoast.showToast(msg: 'Logged in');
        },
        verificationFailed: (exception) {
          Fluttertoast.showToast(msg: 'Some Error Occured. Please try again');
        },
        codeSent: (code, _) {
          _otpSent = code;
        },
        codeAutoRetrievalTimeout: (_,){

        });
  }
  static loginWithOTP(String otp) async{
    AuthCredential _credential = PhoneAuthProvider.credential(verificationId: _otpSent, smsCode: otp);
    await auth.signInWithCredential(_credential);
    if(auth.currentUser!=null)
      Fluttertoast.showToast(msg: 'Logged in');
  }
  static updateCurrentUserData(String displayName, String photoUrl){
    User currentUser = auth.currentUser;
    currentUser.updateProfile(
      displayName: displayName,
      photoURL: photoUrl
    );
//    currentUser.
  }
}