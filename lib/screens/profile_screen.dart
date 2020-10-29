import 'dart:io';
import 'package:MyntraHackathon/Provider/googleMapMarkers.dart';
import 'package:MyntraHackathon/Widget/PostUI.dart';
import 'package:MyntraHackathon/firebaseFunctions/firebaseAuth.dart';
import 'package:MyntraHackathon/firebaseFunctions/firestoreFunctions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  String uid;
  GoogleMapMarker marker;

  @override
  ProfileScreen({this.uid, this.marker});

  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProfileState();
  }
}

class ProfileState extends State<ProfileScreen> {
  bool followUser = false;

  ImageSource source;
  Image _img;
  Image _coverImage;
  bool notFound = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    var userDetails = ModalRoute.of(context).settings.arguments;
  }

  Future<void> selectImage(
      bool isCover, Map<String, dynamic> userDetails) async {
    PickedFile pickedImg = await ImagePicker.platform.pickImage(source: source);
    File img = File(pickedImg.path);
    if (img != null) {
      FirestoreFunction.updateUserProfile(
        name: userDetails['name'],
        username: userDetails['username'],
        description: userDetails['description'],
        image: img,
      );
      setState(() {
        if (isCover)
          _coverImage = Image.file(
            img,
            fit: BoxFit.fill,
          );
        else
          _img = Image.file(img);
      });
    }
  }

  void getImage(bool isCover, Map<String, dynamic> userDetails) {
    showDialog(
        context: context,
        builder: (ctx) => SimpleDialog(
              children: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () {
                    setState(() {
                      source = ImageSource.camera;
                    });
                    selectImage(isCover, userDetails);
                    Navigator.of(ctx).pop();
                  },
                  label: Text('Click From Camera'),
                ),
                FlatButton.icon(
                  icon: Icon(Icons.camera),
                  onPressed: () {
                    setState(() {
                      source = ImageSource.gallery;
                    });
                    selectImage(isCover, userDetails);
                    Navigator.of(ctx).pop();
                  },
                  label: Text('Choose from Gallery'),
                ),
              ],
            ));
  }

  bool coverNotFound = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<Map<String, dynamic>>(
          future: FirestoreFunction.getUserDetails(widget.uid, widget.marker),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting ||
                snap.data == null)
              return Center(child: CircularProgressIndicator());
            Map<String, dynamic> userDetails = snap.data;
////            snap.data['userDetails'];
//            List<QueryDocumentSnapshot> posts = snap.data['postDetails'];
            return Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
              ),
              child: NestedScrollView(
                headerSliverBuilder: (context, _) => [
                  SliverToBoxAdapter(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/profileBackground.png',
                          ),
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.topCenter,
                          repeat: ImageRepeat.repeatY,
                        ),
                        color: Theme.of(context).backgroundColor,
                      ),
                      width: double.infinity,
                      constraints:
                          BoxConstraints(minHeight: 300, maxHeight: 325),
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 136.5,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Card(
                              color: Colors.white,
                              elevation: 0,
                              margin: EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                  //borderRadius: BorderRadius.circular(10),
                                  ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(70)),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pushNamed('/editProfile');
                                        },
                                        elevation: 0,
                                        child: Text(
                                          'Edit Profile',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
                                        ),
                                        color: Theme.of(context).accentColor,
                                      ),
                                      SizedBox(width: 12),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 17,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 16, right: 15),
                                    child: Text(
                                      '${userDetails['name']}',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 16, right: 15),
                                    child: Text(
                                      '${userDetails['username']}',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 16, right: 15),
                                    child: Padding(
                                      child: Text(
                                        '${userDetails['description']}',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14),
                                      ),
                                      padding: EdgeInsets.only(right: 34),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 16, right: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        RichText(
                                          text: TextSpan(
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                              children: [
                                                TextSpan(
                                                    text:
                                                        '${(userDetails['posts'] ?? []).length}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextSpan(text: ' Posts '),
                                              ]),
                                        ),
                                        SizedBox(
                                          width: 18,
                                        ),
                                        RichText(
                                          text: TextSpan(
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                              children: [
                                                TextSpan(
                                                    text: '10k',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextSpan(text: ' Followers '),
                                              ]),
                                        ),
                                        SizedBox(
                                          width: 18,
                                        ),
                                        RichText(
                                          text: TextSpan(
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                              children: [
                                                TextSpan(
                                                    text: '200',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextSpan(text: ' Following '),
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Divider(
                                    height: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 90,
                            left: 16,
                            child: Container(
                              height: 96,
                              width: 96,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.white),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Container(
                                height: 100,
                                width: 100,
                                padding: EdgeInsets.all(0),
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: AssetImage(
                                        'assets/userIcon.png',
                                      ),
                                      backgroundColor: Color(0xFFD9D9D9),
//                                      backgroundImage:
                                      radius: 50,
                                    ),
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: _img != null
                                          ? _img.image
                                          : CachedNetworkImageProvider(
                                              userDetails['photoUrl']),
                                    ),
                                    if (widget.uid ==
                                        FirebaseAuthentication
                                            .auth.currentUser.uid)
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          child: CircleAvatar(
                                            radius: 16,
                                            child: Icon(
                                              Icons.camera_alt,
                                              color:
                                                  Theme.of(context).accentColor,
                                            ),
                                            backgroundColor: Colors.grey,
                                          ),
                                          onTap: () {
                                            getImage(false, userDetails);
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                physics: BouncingScrollPhysics(),
                body: FutureBuilder(
                  future: FirestoreFunction.getUserPosts(userDetails['posts']),
                  builder: (context, snap) {
                    if(snap.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                    List<DocumentSnapshot> posts = snap.data;
                    return ListView.builder(

                      itemBuilder: (context, idx) {
                        DocumentSnapshot doc = posts[idx];
                        return Container(child: PostUI(
                            postDetails: doc.data(), showOption: false),
                        width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height*0.5,
                        );
                      },
                      itemCount: posts.length,
                    );
                  }
                ),
              ),
            );
          }),
    );
  }
}
