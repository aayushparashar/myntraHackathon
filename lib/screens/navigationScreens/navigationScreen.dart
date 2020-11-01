import 'package:MyntraHackathon/Provider/userProvider.dart';
import 'package:MyntraHackathon/screens/navigationScreens/homeScreen.dart';
import 'file:///F:/AndroidStudioProjects/MyntraHackathon/MyntraHackathon/lib/screens/navigationScreens/myntraMore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NavigationState();
  }
}

class NavigationState extends State<NavigationScreen> {
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
        child: HomeScreen(this.changeIndex),
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
