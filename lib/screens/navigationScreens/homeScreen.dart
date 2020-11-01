import 'package:MyntraHackathon/firebaseFunctions/firebaseAuth.dart';
import 'package:MyntraHackathon/screens/navigationScreens/profile_screen.dart';
import 'package:MyntraHackathon/screens/navigationScreens/subscriptionPage.dart';
import 'package:MyntraHackathon/screens/postCreationScreens/orderListScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  Function changetoIndex;

  HomeScreen(this.changetoIndex);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeState();
  }
}

class HomeState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<User>(
      stream: FirebaseAuthentication.auth.authStateChanges(),
      builder: (context, snap) => Scaffold(
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                snap.data != null
                    ? snap.data.photoURL==null? Container():CachedNetworkImage(
                  imageUrl:
                  snap.data.photoURL,
                  fit: BoxFit.fitWidth,
                )
                    : Image.asset('assets/drawer.jpeg', fit: BoxFit.fitWidth),
                if (snap.data != null)
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Log Out'),
                    onTap: () {
                      FirebaseAuthentication.logout();
                    },
                  ),
                if (snap.data != null)
                  ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Your profile'),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => ProfileScreen(
                              uid:
                              snap.data.uid,
                            )));
                      }),
                ListTile(
                  leading: Icon(Icons.subscriptions_rounded),
                  title: Text('Subscribe to Myntra More'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => SubscriptionPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.category_rounded),
                  title: Text('Shop by Categories'),
                  onTap: () {
                    widget.changetoIndex(1);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Theme Stores'),
                  onTap: () {
                    widget.changetoIndex(1);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.account_box),
                  title: Text('Orders'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => OrderListScreen((val) {}),
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
            ),
          ),
        ),
      )
    );
  }
}
