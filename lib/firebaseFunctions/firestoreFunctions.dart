import 'dart:io';
import 'package:MyntraHackathon/Provider/googleMapMarkers.dart';
import 'package:MyntraHackathon/firebaseFunctions/firebaseAuth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

class FirestoreFunction {
  static StorageReference ref = FirebaseStorage.instance.ref();
  static FirebaseFirestore fire = FirebaseFirestore.instance;

  static postImage(Position userPosition, File image, int cnt, String bio,
      User user, GoogleMapMarker marker, BuildContext context) async {
    User _currUser = FirebaseAuthentication.auth.currentUser;
    try {
      String url = await uploadImage(
          ref
              .child('userProfile')
              .child(_currUser.uid.toString())
              .child('currentUser$cnt'),
          image);
      List<Address> address = await Geocoder.local.findAddressesFromCoordinates(
          Coordinates(userPosition.latitude, userPosition.longitude));
      Address place = address[0];
      DocumentReference coll = await fire.collection('Posts').add({
        'latitude': userPosition.latitude,
        'longitude': userPosition.longitude,
        'imageUrl': url,
        'timestamp': DateTime.now(),
        'bio': bio,
        'userId': user.uid,
        'userName': user.displayName,
        'userImage': user.photoURL,
        'address':
            "${place.locality}, ${place.postalCode}, ${place.countryName}"
      });

      DocumentSnapshot snap = await coll.get();
      fire.collection('Users').doc(user.uid).update({
        "posts": FieldValue.arrayUnion([snap.id]),
      });
      marker.addMarker(snap, context);
      Fluttertoast.showToast(msg: 'Post Uploaded');
      print('db complete..');
    } catch (e) {
      print(e);
    }
  }

  static uploadImage(StorageReference imgRef, File image) async {
    print('uploading image');
//      Firestore.instance.collection('Posts').get();

    StorageUploadTask task = imgRef.putFile(image);
    StorageTaskSnapshot details = await task.onComplete;
    print('upload complete..');
    return await imgRef.getDownloadURL();
  }

  static updateUserProfile(
      {String name, String description, String username, File image}) async {
    User _currUser = FirebaseAuthentication.auth.currentUser;
    String url;
    if (image != null)
      url = await uploadImage(
          ref
              .child('userProfile')
              .child(_currUser.uid.toString())
              .child('profilePicture'),
          image);
    fire.collection('Users').doc(_currUser.uid).set({
      'name': name,
      'description': description,
      'username': username,
      'photoUrl': url,
      'timeStamp': DateTime.now().toString(),
      'posts': [],
    });
    FirebaseAuthentication.updateCurrentUserData(name, url);
  }

  static Future<Map<String, dynamic>> getUserDetails(
      String uid, GoogleMapMarker marker) async {
    DocumentReference ref =
        FirebaseFirestore.instance.collection('Users').doc(uid);
    DocumentSnapshot snap = await ref.get();
    print('lalallaa ${snap.data()['posts']}');
//    List<QueryDocumentSnapshot> postDetails = await getUserPosts(snap.data()['posts']);
//    Map<String, dynamic> result = {
//      'userDetails': snap.data(),
//      'postDetails': postDetails
//    };
    return snap.data();
  }

  static  getUserPosts(List<dynamic> posts) async {
    print('getting posts... $posts');
    List<DocumentSnapshot> ll = [];
    for(String post in posts){
      DocumentSnapshot snap = await FirebaseFirestore.instance.collection('Posts').doc(post).get();
      ll.add(snap);
    }
    return ll;
//    QuerySnapshot snap =
//        await FirebaseFirestore.instance.collection('Posts').();
//    print(snap.docs.length);
//    return snap.docs.where((element) => posts.contains(element.id)).toList();
  }
}
