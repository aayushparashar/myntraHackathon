import 'dart:io';

import 'package:MyntraHackathon/Provider/googleMapMarkers.dart';
import 'package:MyntraHackathon/Provider/userProvider.dart';
import 'package:MyntraHackathon/firebaseFunctions/firebaseAuth.dart';
import 'package:MyntraHackathon/screens/authScreens/loginScreen.dart';
import 'package:MyntraHackathon/screens/navigationScreens/subscriptionPage.dart';
import 'package:MyntraHackathon/screens/postCreationScreens/orderListScreen.dart';
import 'file:///F:/AndroidStudioProjects/MyntraHackathon/MyntraHackathon/lib/screens/postCreationScreens/createPost.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userProvider _currUser = Provider.of<userProvider>(context);
    // TODO: implement build
    return StreamBuilder<User>(
      //Getting the firebase auth from the firebase clas
        stream: FirebaseAuthentication.auth.authStateChanges(),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snap.data == null)
            //The user is not logged in
            return LoginScreen();
          //Forwarding it to the screen to create the required post
          if(!_currUser.isSubscribed)
            return SubscriptionPage();
          if(_orderSelected==-1)
            return OrderListScreen(this.setOrder)
;          return CreatePost(
              totalPostsTillnow: widget.totalPostsTillnow,
              currentLocation: widget.currentLocation,
              currentAddress: widget.currentAddress,
              orderIdx: _orderSelected,
          );
        },
    );
  }
  int _orderSelected = -1;
  void setOrder(int idx){
    setState(() {
      _orderSelected = idx;
    });
  }
}
