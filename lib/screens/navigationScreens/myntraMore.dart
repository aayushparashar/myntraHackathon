import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:MyntraHackathon/Provider/googleMapMarkers.dart';
import 'package:MyntraHackathon/Provider/userProvider.dart';
import 'package:MyntraHackathon/Widget/PostUI.dart';
import 'package:MyntraHackathon/Widget/buyProduct.dart';
import 'package:MyntraHackathon/firebaseFunctions/firestoreFunctions.dart';
import 'package:MyntraHackathon/screens/navigationScreens/viewPost.dart';
import 'package:MyntraHackathon/screens/postCreationScreens/addPost.dart';
import 'package:MyntraHackathon/staticData/orderDetails.dart';
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

class MoreState extends State<MyntraMore> with AutomaticKeepAliveClientMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  Geolocator geolocator;
  Position _currentPosition;
  String _currentAddress;
  GoogleMapController _controller;
  DateTime _selectedDate = DateTime.now().subtract(Duration(days: 1));
  DatePickerController dateController = DatePickerController();

  @override
  void initState() {
    _getCurrentLocation();
    //Ask for permission to access GPD coordinates
    Geolocator.requestPermission();
    // TODO: implement initState
    super.initState();
  }

//Accessing the current location based on the device's GPS coordinates
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

//Setting the address based on the current location
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

//Change the style of the map to dark for "Go back in time" feature
  void changeStyleToSilver() {
    rootBundle.loadString('assets/map_style.txt').then((string) {
//      _mapStyle = string;
      _controller.setMapStyle(string);
    });
  }

//Change the style to "Trending in your area" feature
  void changeStyleToRetro() {
    rootBundle.loadString('assets/trending_style.txt').then((string) {
//      _mapStyle = string;
      _controller.setMapStyle(string);
    });
  }

//Change the style to the normal version of the map
  void goBackToPresent() {
    rootBundle.loadString('assets/standard_style.txt').then((string) {
//      _mapStyle = string;
      _controller.setMapStyle(string);
    });
  }

//  GoogleMapMarker markers;
  @override
  void didChangeDependencies() {
    //Setting the markers and the values in the Google Map Marker provider
    Provider.of<GoogleMapMarker>(context, listen: false).updateMarkers(context);

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    userProvider _currUserState = Provider.of<userProvider>(context);
    // TODO: implement build
    return StreamBuilder<QuerySnapshot>(
      //Realtime update from the firebase via stream
      stream: FirebaseFirestore.instance.collection('Posts').snapshots(),
      builder: (context, snap) {
        if (!_currUserState.openedMap) {
          Future.delayed(Duration(seconds: 5), () {
            _currUserState.openedMyntraMoreMap();
          });
          return Scaffold(
            body: Center(
              child: Image.asset(
                'assets/welcomeToMyntraMore.gif',
                fit: BoxFit.fitWidth,
              ),
            ),
          );
        }
        //Listening to all the changes made in the Google Map Marker provider
        return Consumer<GoogleMapMarker>(
          builder: (context, markers, _) {
            return Scaffold(
              floatingActionButton:
                  //Giving the functionality to add a post only if the user is in the present
                  past
                      ? null
                      : FloatingActionButton(
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
                  //Google map widget from the Flutter Library
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: const LatLng(47.6, 8.8796),
                      zoom: 16.0,
                    ),
                    markers: markers.visibleMarkers,
                    myLocationEnabled: true,
                    zoomControlsEnabled: false,
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
                  //Go back in time feature
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
                  //Applying the "Trending in your area" feature
                  if (!past)
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: MaterialButton(
                        child: Text(
                          trending ? 'Back to normal' : 'Trending in your area',
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
                              context,
                            );
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
                                body: markers.visibleMarkers.length == 0
                                    ? Center(
                                        child: Text(
                                            'No one trending near you... '),
                                      )
                                    : ListView(
                                        children: markers
                                            .getTrendingPosts(_currentPosition)
                                            .map(
                                          (doc) {
                                            return ListTile(
                                              leading: CircleAvatar(
                                                backgroundImage: doc.data()[
                                                            'imageUrl'] ==
                                                        null
                                                    ? AssetImage(
                                                        'assets/userIcon.png')
                                                    : CachedNetworkImageProvider(
                                                        doc.data()['imageUrl'],
                                                      ),
                                              ),
                                              title: Text(
                                                OrderDetails.details[
                                                    (doc.data()['postType'] ??
                                                            1) -
                                                        1]['product'],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              subtitle: Text(
                                                OrderDetails.details[
                                                    (doc.data()['postType'] ??
                                                            1) -
                                                        1]['company'],
                                              ),
                                              trailing: FlatButton.icon(
                                                onPressed: () {},
                                                icon: Icon(
                                                  Icons.favorite,
                                                  color: Colors.red,
                                                ),
                                                label: Text(
                                                  '${doc.data()['likes'] ?? 0}',
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        buyProductScreen(
                                                      doc.data()['postIdx'] ??
                                                          1,
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ).toList(),
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
                  if (!past)
                    Positioned(
                      bottom: 100,
                      right: 10,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        color: Theme.of(context).accentColor,
                        child: Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => Dialog(
                              child: Scaffold(
                                appBar: AppBar(
                                  title: Text('Promoter Leaderboard'),
                                ),
                                body: FutureBuilder<dynamic>(
                                  future:
                                      FirestoreFunction.getLeaderboardValues(),
                                  builder: (context, snap) => snap
                                              .connectionState ==
                                          ConnectionState.waiting
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : ListView(
                                          children:
                                              snap.data.map<Widget>((element) {
                                            return ListTile(
                                              leading: CircleAvatar(
                                                backgroundImage: element.data()[
                                                            'photoUrl'] ==
                                                        null
                                                    ? AssetImage(
                                                        'assets/userIcon.png')
                                                    : CachedNetworkImageProvider(
                                                        element.data()[
                                                            'photoUrl']),
                                              ),
                                              title:
                                                  Text(element.data()['name']),
                                              subtitle: Text(element
                                                      .data()['description'] ??
                                                  ''),
                                              trailing: FlatButton.icon(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                    Icons.favorite,
                                                    color: Colors.red,
                                                  ),
                                                  label: Text(
                                                      '${element.data()['likes'] ?? 0}')),
                                            );
                                          }).toList(),
                                        ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  if (past)
                    //Show the calender when the user is in the past
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
          },
        );
      },
    );
  }
}
