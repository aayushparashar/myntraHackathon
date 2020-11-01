import 'dart:async';

import 'package:MyntraHackathon/firebaseFunctions/firebaseAuth.dart';
import 'package:MyntraHackathon/screens/authScreens/CreateAccount.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OTPState();
  }
}

class OTPState extends State<OtpScreen> {
  bool submitted = false;
  String smsCode;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<User>(
        stream: FirebaseAuthentication.auth.authStateChanges(),
        builder: (context, snap) {
          if(snap.data!=null){
            Future.delayed(Duration(seconds: 5),(){
              if(snap.data.displayName!=null && snap.data.displayName.length != 0)
                 Navigator.of(context).pop();
              else
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=> OnBoardFields()));
            });
            return Scaffold(body: Center(child: Image.asset('assets/welcomeToMyntraMore.gif', fit: BoxFit.fitWidth,),),);
          }
          return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 26),
//          decoration: BoxDecoration(
//              image: DecorationImage(
//            alignment: Alignment.topCenter,
//            image: AssetImage(
//              'assets/images/AuthScreens/authBg2.png',
//            ),
//            fit: BoxFit.fitWidth,
//            repeat: ImageRepeat.noRepeat,
//          )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/myntraIcon.png',
                  height: 100,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Enter the 6-digit one time password we have sent on ${FirebaseAuthentication.phoneNumber}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF484848).withOpacity(0.9),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 50,
                  child: TextField(
                    cursorColor: Theme.of(context).accentColor,
                    decoration: InputDecoration(
                      hoverColor: Theme.of(context).accentColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide:
                            BorderSide(color: Color(0xFFC4C4C4), width: 1),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF484848),
                    ),
                    maxLengthEnforced: true,
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.number,
                    onChanged: (val) {
                      this.smsCode = val;
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () async {
                    if (smsCode.length != 6)
                      Fluttertoast.showToast(
                          msg:
                              'Please Enter a 6 Digit OTP sent to your Number');
                    else {
                      setState(() {
                        submitted = true;
                      });
                      await FirebaseAuthentication.loginWithOTP(this.smsCode);
                      setState(() {
                        submitted = false;
                      });
                    }
                  },
                  minWidth: double.maxFinite,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    'CONFIRM OTP',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                snap.data!=null?
                    Center(child  : Icon(Icons.check_circle, color: Colors.green,),)
                    :submitted
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : FlatButton(
                        child: Text('Resend OTP'),
                        onPressed: () {
                          FirebaseAuthentication.verifyPhoneNumber(
                              '${FirebaseAuthentication.phoneNumber}');
                        },
                      ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'By creating account, you agree to our Terms & Conditions',
                  style: TextStyle(color: Color(0xFF6B6A6B)),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
