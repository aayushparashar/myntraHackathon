import 'package:MyntraHackathon/firebaseFunctions/firebaseAuth.dart';
import 'package:MyntraHackathon/screens/authScreens/OTP_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

//Input of the phone number
class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginState();
  }
}

class LoginState extends State<LoginScreen> {
  var controller = TextEditingController();
  var key = GlobalKey<FormState>();
  String phoneNumber = '';
//  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
   @override
  Widget build(BuildContext context) {
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
//      key: _scaffoldKey,
      body: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/myntraIcon.png', height: 100,),
              SizedBox(height: 10,),
              Text(
                'What\'s your Mobile Number?',
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
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hoverColor: Theme.of(context).accentColor,
                    focusColor: Theme.of(context).accentColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide:
                          BorderSide(color: Color(0xFFC4C4C4), width: 1),
                    ),
                  ),
//                cursorColor: Theme.of(context).accentColor,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF484848),
                  ),
                  maxLengthEnforced: true,
                  textAlignVertical: TextAlignVertical.center,
                  onChanged: (val) {
                    this.phoneNumber = val;
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  if (phoneNumber.length != 10)
                    Fluttertoast.showToast(
                        msg: 'Please Enter a 10 Digit Mobile Number');
                  else {
                    FirebaseAuthentication.verifyPhoneNumber(
                        '${this.phoneNumber}');
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>OtpScreen()));
//                    Navigator.of(context)
//                        .push(MaterialPageRoute(builder: (ctx) => OtpScreen()));
                  }
                },
                minWidth: double.maxFinite,
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text(
                  'SEND OTP',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
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
  }
}
