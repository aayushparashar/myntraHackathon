import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:MyntraHackathon/Provider/googleMapMarkers.dart';
import 'package:MyntraHackathon/Widget/PostUI.dart';
import 'package:MyntraHackathon/screens/postCreationScreens/addPost.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class MyntraMore extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MoreState();
  }
}

class MoreState extends State<MyntraMore> {
  Geolocator geolocator;
  Position _currentPosition;
  String _currentAddress;
  GoogleMapController _controller;
  DateTime _selectedDate = DateTime.now().subtract(Duration(days: 1));
DatePickerController dateController = DatePickerController();
  @override
  void initState() {
//    this.geolocator = Geolocator()..forceAndroidLocationManager;
    _getCurrentLocation();
    Geolocator.requestPermission();
    // TODO: implement initState
    super.initState();
  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
//      setState(() {
      _currentPosition = position;
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            bearing: 270.0,
            target:
                LatLng(_currentPosition.latitude, _currentPosition.longitude),
            tilt: 30.0,
            zoom: 18,
          ),
        ),
      );
//      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  bool trending = false;
  bool past = false;

  _getAddressFromLatLng() async {
    try {
      List<Address> p = await Geocoder.local.findAddressesFromCoordinates(
          Coordinates(_currentPosition.latitude, _currentPosition.longitude));
//      List<Placemark> p = await Geolocator.placemarkFromCoordinates(
//          _currentPosition.latitude, _currentPosition.longitude);
      Address place = p[0];
      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.countryName}";
      });
    } catch (e) {
      print(e);
    }
  }

  void changeStyleToSilver() {
    print('*** changind style ******');
    rootBundle.loadString('assets/map_style.txt').then((string) {
//      _mapStyle = string;
      _controller.setMapStyle(string);
    });
  }

  void changeStyleToRetro() {
    rootBundle.loadString('assets/trending_style.txt').then((string) {
//      _mapStyle = string;
      _controller.setMapStyle(string);
    });
  }

  void goBackToPresent() {
    rootBundle.loadString('assets/standard_style.txt').then((string) {
//      _mapStyle = string;
      _controller.setMapStyle(string);
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

//  GoogleMapMarker markers;
  @override
  void didChangeDependencies() {
    Provider.of<GoogleMapMarker>(context, listen: false).updateMarkers(context);

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Posts').snapshots(),
        builder: (context, snap) {
//        if(snap.connectionState == )
//        if(snap.connectionState == Connection)

          return Consumer<GoogleMapMarker>(builder: (context, markers, _) {
            return Scaffold(
              floatingActionButton: past? null : FloatingActionButton(
                backgroundColor: Theme.of(context).accentColor,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (_currentPosition != null)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => createPostScreen(
                          currentAddress: this._currentAddress,
                          currentLocation: this._currentPosition,
                          totalPostsTillnow: snap.data.docs.length,
                          marker: markers,
                        ),
                      ),
                    );
                },
              ),
              body: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: const LatLng(47.6, 8.8796),
                      zoom: 16.0,
                    ),
                    markers: markers.visibleMarkers,
                    myLocationEnabled: true,
                    zoomControlsEnabled: false,

//                    myLocationButtonEnabled: true,
                    onTap: (location) => print('onTap: $location'),
                    onCameraMove: (cameraUpdate) =>
                        print('onCameraMove: $cameraUpdate'),
//                    compassEnabled: true,
                    onMapCreated: (controller) {
                      setState(() {
                        this._controller = controller;
                      });
                      controller.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            bearing: 270.0,
                            target: LatLng(_currentPosition.latitude,
                                _currentPosition.longitude),
                            tilt: 30.0,
                            zoom: 18,
                          ),
                        ),
                      );
                      goBackToPresent();
                    },
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: MaterialButton(
                      child: Text(
                        '${past ? 'Back to the future' : 'Go back in time'}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: () {
                        if (past) {
                          markers.addDateFilter(
                              DateTime.now().subtract(Duration(days: 1)),
                              DateTime.now(),
                              context);
                          goBackToPresent();
                        } else {
                          markers.addDateFilter(
                              DateTime.now().subtract(Duration(days: 2)),
                              DateTime.now().subtract(Duration(days: 1)),
                              context);

                          changeStyleToSilver();
                        }
                        setState(() {
                          past = !past;
                        });
                      },
                    ),
                  ),
                  if(!past)
                    Positioned(
                    bottom: 10,
                    left: 10,
                    child: MaterialButton(
                      child: Text(
                        'Trending in your area',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: () {
                        if (_currentPosition == null) return;
                        if (trending) {
                          markers.addDateFilter(
                              DateTime.now().subtract(Duration(days: 1)),
                              DateTime.now(),
                              context);
                          goBackToPresent();
                        } else {
                          changeStyleToRetro();
                          markers.addTrendingFilter(_currentPosition);
                          showModalBottomSheet(
                            builder: (ctx) => NestedScrollView(
                              headerSliverBuilder: (context, __) => [
                                SliverToBoxAdapter(
                                  child: AppBar(
                                    title: Text('Trending in your area..'),
                                    leading: Container(),
                                  ),
                                )
                              ],
                              body: ListView(
                                children: markers.visibleMarkers.map((element) {
//                                  Position p = Position(
//                                      latitude: element.data()['latitude'],
//                                      longitude: element.data()['longitude']);
//                                  double dist = Geolocator.distanceBetween(
//                                    _currentPosition.latitude,
//                                    _currentPosition.longitude,
//                                    p.latitude,
//                                    p.longitude,
//                                  );
                                  DocumentSnapshot doc = markers.docs
                                      .firstWhere((doc) =>
                                          doc.id == element.markerId.value);
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: doc
                                                  .data()['userImage'] ==
                                              null
                                          ? AssetImage('assets/userIcon.png')
                                          : CachedNetworkImageProvider(
                                              doc.data()['userImage'],
                                            ),
                                    ),
                                    title: Text(
                                      doc.data()['userName'],
                                    ),
                                    subtitle: Text(doc.data()['bio'] ?? ''),
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (ctx) => PostUI(
                                          postDetails: doc.data(),
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                            context: context,
                          );
                        }
                        setState(() {
                          trending = !trending;
                        });
                      },
                    ),
                  ),
                  if (past)
                    Positioned(
                      top: 100,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.white,
                        height: 82,
                        width: MediaQuery.of(context).size.width,
                        child: DatePicker(
                          DateTime.now().subtract(
                            Duration(days: 30),
                          ),
                          controller: dateController,
                          height: 82,
                          selectionColor: Colors.white,
                          selectedTextColor: Theme.of(context).accentColor,
                          daysCount: 30,
                          deactivatedColor: Colors.white,

                          initialSelectedDate: _selectedDate,

                          onDateChange: (date) {
                            dateController.animateToSelection();

                            setState(() {
                              _selectedDate = date;
                            });
                            markers.addDateFilter(
                                DateTime(date.year, date.month, date.day, 0),
                                DateTime(
                                    date.year, date.month, date.day + 1, 0),
                                context);
                          },
                        ),
                      ),
                    ),
                ],
              ),
            );
          });
        });
  }
}
