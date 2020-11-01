import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:MyntraHackathon/Widget/UserSwipeDocs.dart';
import 'package:MyntraHackathon/firebaseFunctions/firebaseAuth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapMarker with ChangeNotifier {
  //Storing every marker that may or may not be rendered on the screen
  Set<Marker> markers = {};

  //min and max Dates constraints
  DateTime minDate = DateTime.now().subtract(Duration(days: 1));
  DateTime maxDate = DateTime.now();

  //The markers that are currently visible on the screen
  Set<Marker> visibleMarkers = {};

  //A list of all the documents available on the Firebase related to the posts
  List<DocumentSnapshot> docs;

//A map of all user ids as keys list of all the posts by that user
  Map<String, List<DocumentSnapshot>> userPosts = {};

  //Generating the marker in the BitmapDescriptor format
  Future<BitmapDescriptor> getMarker(String imageUrl) async {
    if (imageUrl == null)
      //The creator of the post has no uploaded display picture
      return BitmapDescriptor.defaultMarker;
    final int targetWidth = 150;
    //Storing the network image on the device to be rendered into bytes
    final File markerImageFile =
        await DefaultCacheManager().getSingleFile(imageUrl);
    final Uint8List markerImageBytes = await markerImageFile.readAsBytes();
    final ui.Codec markerImageCodec = await ui.instantiateImageCodec(
      markerImageBytes,
      targetWidth: targetWidth,
    );
    final ui.FrameInfo frameInfo = await markerImageCodec.getNextFrame();
    final ByteData byteData = await frameInfo.image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    final Uint8List resizedMarkerImageBytes = byteData.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(resizedMarkerImageBytes);
  }



  //Realtime Update of the database from the firestore
  void changeMarkers(List<DocumentChange> docs, BuildContext context) {
    docs.forEach((element) async {
      switch (element.type) {
        case DocumentChangeType.added:
          //A new post is added
          Marker _temp = await addDocument(element.doc, context);
          markers.add(_temp);
          DateTime time = DateTime.parse(
              element.doc['timestamp'].runtimeType == String
                  ? element.doc['timestamp']
                  : element.doc['timestamp'].toDate().toString());
          if (time.isAfter(DateTime.now().subtract(Duration(days: 1)))) {
            visibleMarkers.add(_temp);
            notifyListeners();
          }
          break;
        case DocumentChangeType.removed:
          // A post is removed from the database
          visibleMarkers.removeWhere((m) => m.markerId.value == element.doc.id);
          notifyListeners();
          break;
      }
    });
  }

  //To manually add the marker of the post that the current user has posted
  addMarker(DocumentSnapshot doc, BuildContext context) async {
    Marker m = await addDocument(doc, context);
    markers.add(m);
    userPosts[FirebaseAuthentication.auth.currentUser.uid].add(doc);
    visibleMarkers.add(m);
    notifyListeners();
  }

  //Adding the document to the list and return the marker for that post
  Future<Marker> addDocument(DocumentSnapshot doc, BuildContext context) async {
    final tempMarker = await getMarker(doc.data()['userImage']);
    return Marker(
      markerId: MarkerId('${doc.id}'),
      position: LatLng(doc.data()['latitude'], doc.data()['longitude']),
      consumeTapEvents: true,
      infoWindow: InfoWindow(
        title: '${doc.data()['userName']}',
        snippet: "${doc.data()['bio']}",
      ),
      alpha: 1,
      icon: tempMarker,
      onTap: () {
        showDialog(
          child: UserPostsSwipeCards(doc.data()['userId']),
          context: context,
          barrierColor: Colors.transparent,
        );
      },
    );
  }

  //The function called initially to set the values for all the markers and documents
  void updateMarkers(BuildContext context) async {
    visibleMarkers.clear();
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('Posts')
        .orderBy('timestamp', descending: false)
        .get();
    this.docs = snap.docs;
    docs.forEach((element) {
      userPosts.putIfAbsent(element.data()['userId'], () => []);
      userPosts[element.data()['userId']].add(element);
    });
    userPosts.forEach(
      (key, value) async {
        value.forEach((element) async {
          Marker _temp = await addDocument(element, context);
          markers.add(_temp);
        });
      },
    );
    addDateFilter(
        DateTime.now().subtract(Duration(days: 1)), DateTime.now(), context);
  }

  getUserPosts(String uid) {
    List<DocumentSnapshot> userDocs = [];
    List<DocumentSnapshot> allPosts = userPosts[uid] ?? [];
    print(allPosts.length);
    for (DocumentSnapshot snaps in allPosts) {
      bool contains = false;
      DateTime time = DateTime.parse(
          snaps.data()['timestamp'].runtimeType == String
              ? snaps.data()['timestamp']
              : snaps.data()['timestamp'].toDate().toString());
      if (time.isBefore(maxDate) && time.isAfter(minDate)) {
        userDocs.add(snaps);
      }
    }
    return userDocs;
  }

  //Show only those markers that lie in the given duration for the feature "Go back in time"
  void addDateFilter(
      DateTime minDate, DateTime maxDate, BuildContext context) async {
    this.minDate = minDate;
    this.maxDate = maxDate;
    visibleMarkers.clear();
    notifyListeners();
    userPosts.forEach((key, value) {
      Marker _selectedMarker;
      value.forEach((element) async {
        Marker _temp =
            markers.firstWhere((mm) => mm.markerId.value == element.id);
        DateTime time = DateTime.parse(
            element['timestamp'].runtimeType == String
                ? element['timestamp']
                : element['timestamp'].toDate().toString());
        if (time.isAfter(minDate) && time.isBefore(maxDate)) {
          if (_selectedMarker != null) visibleMarkers.remove(_selectedMarker);
          _selectedMarker = _temp;
          visibleMarkers.add(_selectedMarker);

          notifyListeners();
        }
      });

      notifyListeners();
    });
    notifyListeners();
  }

  //Show only those posts that are trending within 5km of my current location for the feature "Trending in your area"
  void addTrendingFilter(Position _currPosition) {
    visibleMarkers.removeWhere((marker) {
      DocumentSnapshot element =
          docs.firstWhere((element) => element.id == marker.markerId.value);
      Position p = Position(
          latitude: element.data()['latitude'],
          longitude: element.data()['longitude']);
      double dist = Geolocator.distanceBetween(
        _currPosition.latitude,
        _currPosition.longitude,
        p.latitude,
        p.longitude,
      );
      return dist > 5000;
    });
    notifyListeners();
  }
}
