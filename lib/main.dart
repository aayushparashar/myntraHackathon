import 'package:MyntraHackathon/Provider/googleMapMarkers.dart';
import 'package:MyntraHackathon/screens/navigationScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Myntra More',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(250, 73, 113, 1),
        accentColor: Color.fromRGBO(250, 73, 113, 1),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //Initializing the provider package
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: GoogleMapMarker(),
          ),
        ],
        child: FutureBuilder(
          //Initializing the firebase functionality to the app
          future: Firebase.initializeApp(),
          builder: (context, snap) =>
              snap.connectionState == ConnectionState.waiting
                  ? Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  :
              //When the app is initialized, open the navigation screen
              NavigationScreen(),
        ),
      ),
    );
  }
}
