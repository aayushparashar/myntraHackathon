import 'package:MyntraHackathon/firebaseFunctions/firebaseAuth.dart';
import 'package:MyntraHackathon/screens/myntraMore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NavigationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NavigationState();
  }
}

class NavigationState extends State<NavigationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void changeIndex(int idx) {
    setState(() {
      this._selectedIdx = idx;
    });
  }

  List<Widget> screens;
  int _selectedIdx = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    screens = [
      Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: [
            Image.asset(
              'assets/staticSections/0.jpeg',
              fit: BoxFit.fill,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                child: Container(
                  color: Colors.transparent,
                  height: 100, width: 100,
//            child:
                ),
                onTap: () {
                  _scaffoldKey.currentState.openDrawer();
                },
              ),
            ),
          ],
        ),
        drawer: Drawer(
            child: Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: FirebaseAuthentication.auth.currentUser != null
                          ? CachedNetworkImageProvider(
                              FirebaseAuthentication.auth.currentUser.photoURL,

                            )
                          : AssetImage('assets/drawer.jpeg'),
                  alignment: Alignment.center,
                    fit: BoxFit.fill
                  )),
              width: double.infinity,
              height: 150,
//              color: Colors.black,
            ),
            if(FirebaseAuthentication.auth.currentUser!=null)
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Log Out'),
                onTap: (){
                  FirebaseAuthentication.logout();
                },
              ),
            ListTile(
              leading: Icon(Icons.category_rounded),
              title: Text('Shop by Categories'),
              onTap: () {
                changeIndex(1);
              },
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Theme Stores'),
              onTap: () {
                changeIndex(1);
              },
            ),
            ListTile(
              leading: Icon(Icons.account_box),
              title: Text('Orders'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => Scaffold(
                      body: Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top),
                        child: Image.asset('assets/orders.jpeg'),
                      ),
                    ),
                  ),
                );
              },
            ),
            FlatButton(
              onPressed: () {
//                  changeIndex(1);
              },
              child: Text(
                'FAQs',
                style: TextStyle(color: Colors.grey, fontSize: 12),
                textAlign: TextAlign.start,
              ),
            ),
            FlatButton(
                onPressed: () {},
                child: Text(
                  'CONTACT US',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                  textAlign: TextAlign.start,
                )),
            FlatButton(
                onPressed: () {},
                child: Text(
                  'MORE',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                  textAlign: TextAlign.start,
                )),
          ],
        )),
      ),
      Image.asset('assets/staticSections/1.jpeg', fit: BoxFit.fill),
      Image.asset('assets/staticSections/2.jpeg', fit: BoxFit.fill),
      MyntraMore(),
      Image.asset('assets/staticSections/4.jpeg', fit: BoxFit.fill),
      Image.asset('assets/staticSections/5.jpeg', fit: BoxFit.fill),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 11,
          unselectedFontSize: 10,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/myntraIcon.png',
                height: 20,
              ),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              title: Text('Categories'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.tv),
              title: Text('Studio'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.language),
              title: Text('More'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              title: Text('Explore'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile'),
            ),
          ],
          currentIndex: _selectedIdx,
          unselectedItemColor: Colors.black,
          selectedItemColor: Theme.of(context).primaryColor,
          onTap: (idx) {
            setState(() {
              _selectedIdx = idx;
            });
          },
        ),
        backgroundColor: Colors.white,
        body: Padding(
          child: screens[_selectedIdx],
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        ),
      ),
    );
  }
}
