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
    _loginScreen = LoginScreen();
    _subscribeScreen = SubscriptionPage();
    _orderListScreen = OrderListScreen(setOrder);
    // TODO: implement initState
    super.initState();
  }

  LoginScreen _loginScreen;
  SubscriptionPage _subscribeScreen;
  OrderListScreen _orderListScreen;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<User>(
      //Getting the firebase auth from the firebase clas
      stream: FirebaseAuthentication.auth.authStateChanges(),
      builder: (ctx, snap) {
        return Consumer<userProvider>(
          builder: (context, _currUser, child) {
            print('will it?...');
            if (snap.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (snap.data == null)
              //The user is not logged in
              return _loginScreen;
            //Forwarding it to the screen to create the required post
            if (!_currUser.isSubscribed) return _subscribeScreen;
            if (_orderSelected == -1) return _orderListScreen;
            return CreatePost(
              totalPostsTillnow: widget.totalPostsTillnow,
              currentLocation: widget.currentLocation,
              currentAddress: widget.currentAddress,
              orderIdx: _orderSelected,
            );
          },
        );
      },
    );
  }

  int _orderSelected = -1;

  void setOrder(int idx) {
    setState(() {
      _orderSelected = idx;
    });
  }
}
