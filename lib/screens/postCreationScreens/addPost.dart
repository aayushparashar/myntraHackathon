import 'dart:io';

import 'package:MyntraHackathon/Provider/googleMapMarkers.dart';
import 'package:MyntraHackathon/firebaseFunctions/firebaseAuth.dart';
import 'package:MyntraHackathon/screens/authScreens/loginScreen.dart';
import 'file:///F:/AndroidStudioProjects/MyntraHackathon/MyntraHackathon/lib/screens/postCreationScreens/createPost.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class createPostScreen extends StatefulWidget {
  Position currentLocation;
  String currentAddress;
  int totalPostsTillnow;
  GoogleMapMarker marker;

  createPostScreen(
      {this.currentLocation,
      this.currentAddress,
      this.totalPostsTillnow,
      this.marker});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return createPostState();
  }
}

class createPostState extends State<createPostScreen> {
//  bool detailsUpdated = false;
//
//  void detailsUploaded() {
//    setState(() {
//      detailsUpdated = true;
//    });
//  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<User>(
        stream: FirebaseAuthentication.auth.authStateChanges(),
        builder: (ctx, snap) {
//          FirebaseAuthentication.logout();
          if (snap.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snap.data == null) return LoginScreen();
//    print('****');
//    print(snap.data.displayName);
//          if (!detailsUpdated &&
//              (snap.data.displayName == null ||
//                  snap.data.displayName.length == 0))
//            return OnBoardFields(detailsUploaded);
          return CreatePost(
              totalPostsTillnow: widget.totalPostsTillnow,
              currentLocation: widget.currentLocation,
              currentAddress: widget.currentAddress,
              mapMarker: widget.marker);
        });
  }
}
