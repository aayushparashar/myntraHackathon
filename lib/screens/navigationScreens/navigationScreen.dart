import 'package:MyntraHackathon/Provider/userProvider.dart';
import 'package:MyntraHackathon/firebaseFunctions/firebaseAuth.dart';
import 'package:MyntraHackathon/firebaseFunctions/firestoreFunctions.dart';
import 'package:MyntraHackathon/screens/navigationScreens/subscriptionPage.dart';
import 'package:MyntraHackathon/screens/postCreationScreens/orderListScreen.dart';
import 'file:///F:/AndroidStudioProjects/MyntraHackathon/MyntraHackathon/lib/screens/navigationScreens/myntraMore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class NavigationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NavigationState();
  }
}

class NavigationState extends State<NavigationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
int cnt = 0;
  void changeIndex(int idx) {
    setState(() {
      this._selectedIdx = idx;
    });
  }

  //All the bottom navigation screens for the main app
  List<Widget> screens;
  int _selectedIdx = 0;

  @override
  void didChangeDependencies() {
    screens = [
      Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Scaffold(
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
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: double.infinity,
                  height: 150,
//              color: Colors.black,
                ),
                if (FirebaseAuthentication.auth.currentUser != null)
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Log Out'),
                    onTap: () {
                      FirebaseAuthentication.logout();
                    },
                  ),
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
//                MaterialButton(
//                  shape: RoundedRectangleBorder(
//                    borderRadius: BorderRadius.circular(100),
//                  ),
//                  color: Theme.of(context).accentColor,
//                  child: Icon(
//                    Icons.calendar_today,
//                    color: Colors.white,
//                  ),
//                  onPressed: () {
//                    showDialog(
//                      context: context,
//                      builder: (ctx) => Dialog(
//                        child: Scaffold(
//                          appBar: AppBar(
//                            title: Text('Leaderboard'),
//                          ),
//                          body: FutureBuilder<dynamic>(
//                            future: FirestoreFunction.getLeaderboardValues(),
//                            builder: (context, snap) => snap
//                                .connectionState ==
//                                ConnectionState.waiting
//                                ? Center(
//                                child: CircularProgressIndicator())
//                                : ListView(
//                              children: snap.data.map((element) {
//                                return ListTile(
//                                  leading: CircleAvatar(
//                                    backgroundImage: element.data()[
//                                    'photoUrl'] ==
//                                        null
//                                        ? AssetImage(
//                                        'assets/userIcon.png')
//                                        : CachedNetworkImageProvider(
//                                        element.data()[
//                                        'photoUrl']),
//                                  ),
//                                  title:
//                                  Text(element.data()['name']),
//                                  subtitle: Text(element
//                                      .data()['description'] ??
//                                      ''),
//                                  trailing: FlatButton.icon(
//                                      onPressed: () {},
//                                      icon: Icon(
//                                        Icons.favorite,
//                                        color: Colors.red,
//                                      ),
//                                      label: Text(
//                                          '${element.data()['likes'] ?? 0}')),
//                                );
//                              }).toList(),
//                            ),
//                          ),
//                        ),
//                      ),
//                    );
//                  },
//                )
              ],
            ),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Image.asset('assets/staticSections/1.jpeg', fit: BoxFit.fill),
      ),
      Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Image.asset('assets/staticSections/2.jpeg', fit: BoxFit.fill),
      ),
      Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: MyntraMore(),
      ),
      Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Image.asset('assets/staticSections/4.jpeg', fit: BoxFit.fill),
      ),
      Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Image.asset('assets/staticSections/5.jpeg', fit: BoxFit.fill),
      ),
    ];
    Provider.of<userProvider>(context, listen: false).setUserDetails();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
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
            if(idx == 3 && cnt == 0){
              cnt++;

            }
            setState(() {
              _selectedIdx = idx;
            });
          },
        ),
        backgroundColor: Colors.white,
        body: IndexedStack(
          children: screens,
          index: _selectedIdx,
//            key:,
        ));
  }
}