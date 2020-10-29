import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:MyntraHackathon/Widget/PostUI.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapMarker with ChangeNotifier {
  Set<Marker> markers = {};
  Set<Marker> visibleMarkers = {};
  List<DocumentSnapshot> docs;

  Future<BitmapDescriptor> getMarker(String imageUrl) async {
    if (imageUrl == null) return BitmapDescriptor.defaultMarker;
    final int targetWidth = 150;
    final File markerImageFile =
        await DefaultCacheManager().getSingleFile(imageUrl);
    final Uint8List markerImageBytes = await markerImageFile.readAsBytes();
    final Codec markerImageCodec = await instantiateImageCodec(
      markerImageBytes,
      targetWidth: targetWidth,
    );
    final FrameInfo frameInfo = await markerImageCodec.getNextFrame();
    final ByteData byteData = await frameInfo.image.toByteData(
      format: ImageByteFormat.png,
    );
    final Uint8List resizedMarkerImageBytes = byteData.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(resizedMarkerImageBytes);
  }

  void changeMarkers(List<DocumentChange> docs, BuildContext context) {
    docs.forEach((element) async {
      switch (element.type) {
        case DocumentChangeType.added:
          Marker _temp = await addDocument(element.doc, context);
          markers.add(_temp);
          DateTime time = DateTime.parse(
              element.doc['timestamp'].runtimeType == String
                  ? element.doc['timestamp']
                  : element.doc['timestamp'].toDate().toString());
//      print('*** ${time.toString()} ***');
          if (time.isAfter(DateTime.now().subtract(Duration(days: 1)))) {
            visibleMarkers.add(_temp);
            notifyListeners();
          }
          break;
        case DocumentChangeType.removed:
          visibleMarkers.removeWhere((m) => m.markerId.value == element.doc.id);
          notifyListeners();
          break;
      }
    });
  }
 addMarker(DocumentSnapshot doc, BuildContext context) async{
    docs.add(doc);
    Marker m = await addDocument(doc, context);
    markers.add(m);
    visibleMarkers.add(m);
    notifyListeners();
}
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
        showModalBottomSheet(

          context: context,
          builder: (ctx) => PostUI(
            postDetails: doc.data(),
            marker: this,
          ),
        );
      },
    );
  }

  void updateMarkers(BuildContext context) async {
    print('*** updating markers ***');
    QuerySnapshot snap =
        await FirebaseFirestore.instance.collection('Posts').get();
    this.docs = snap.docs;
    docs.forEach((element) async {
      Marker _temp = await addDocument(element, context);
      print('marker set up');
      markers.add(_temp);
      DateTime time = DateTime.parse(element['timestamp'].runtimeType == String
          ? element['timestamp']
          : element['timestamp'].toDate().toString());
//      print('*** ${time.toString()} ***');
      if (time.isAfter(DateTime.now().subtract(Duration(days: 1)))) {
        visibleMarkers.add(_temp);
        notifyListeners();
      }
    });
  }

  void addDateFilter(
      DateTime minDate, DateTime maxDate, BuildContext context) async {
//    m.clear();
    visibleMarkers.clear();
    notifyListeners();
   docs.forEach((element) {
     DateTime time = DateTime.parse(element['timestamp'].runtimeType == String? element['timestamp'] :element['timestamp'].toDate().toString());
//      print('*** ${time.toString()} ***');
     if(time.isBefore(minDate) || time.isAfter(maxDate))
       return;
     visibleMarkers.add(markers.firstWhere((m) => m.markerId.value == element.id));
     notifyListeners();
   });


    notifyListeners();
  }
  void addTrendingFilter(Position _currPosition){
    visibleMarkers.removeWhere((marker){
      DocumentSnapshot element = docs.firstWhere((element) => element.id == marker.markerId.value);
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
  }
}
