import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseAuthentication {
  static String phoneNumber;
  static FirebaseAuth auth = FirebaseAuth.instance;
  static String _otpSent;

  static logout() {
    auth.signOut();
  }

//Sending the otp to the user and auto detection method
  static verifyPhoneNumber(String phoneNumber) {
    FirebaseAuthentication.phoneNumber = phoneNumber;
    auth.verifyPhoneNumber(
        //The number to which the OTP is to be sent
        phoneNumber: '+91$phoneNumber',
        //When auto-detection of the OTP occurs
        verificationCompleted: (credential) {
          auth.signInWithCredential(credential);
          Fluttertoast.showToast(msg: 'Logged in');
        },
        //When some error occurs during verification
        verificationFailed: (exception) {
          Fluttertoast.showToast(msg: 'Some Error Occured. Please try again');
        },
        //Function called when the code is sent to the number
        codeSent: (code, _) {
          _otpSent = code;
        },
        //Auto Retrieval Timeout
        codeAutoRetrievalTimeout: (
          _,
        ) {});
  }

//To manually login with OTP in case auto detection does not occur
  static loginWithOTP(String otp) async {
    AuthCredential _credential =
        PhoneAuthProvider.credential(verificationId: _otpSent, smsCode: otp);
    await auth.signInWithCredential(_credential);
    if (auth.currentUser != null) Fluttertoast.showToast(msg: 'Logged in');
  }
//Updating the firebase user details
  static updateCurrentUserData(String displayName, String photoUrl) {
    User currentUser = auth.currentUser;
    currentUser.updateProfile(displayName: displayName, photoURL: photoUrl);
  }
}
