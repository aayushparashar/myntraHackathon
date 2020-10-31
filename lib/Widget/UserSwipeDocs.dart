import 'package:MyntraHackathon/Provider/googleMapMarkers.dart';
import 'package:MyntraHackathon/Provider/userProvider.dart';
import 'package:MyntraHackathon/Widget/PostUI.dart';
import 'package:MyntraHackathon/Widget/buyProduct.dart';
import 'package:MyntraHackathon/firebaseFunctions/firestoreFunctions.dart';
import 'package:MyntraHackathon/screens/navigationScreens/viewPost.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';

class UserPostsSwipeCards extends StatefulWidget {
  String userId;

  UserPostsSwipeCards(this.userId);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UserPostsSwipeState();
  }
}

class UserPostsSwipeState extends State<UserPostsSwipeCards> {
  List<DocumentSnapshot> userDocs = [];

  void setUserDocs() {
    GoogleMapMarker marker =
        Provider.of<GoogleMapMarker>(context, listen: false);
    List<String> documentAdded = [];
    List<DocumentSnapshot> allPosts = marker.userPosts[widget.userId] ?? [];
    for (DocumentSnapshot snaps in allPosts) {
      bool contains = false;
      marker.visibleMarkers.forEach((element) {
        if (element.markerId.value == snaps.id) {
          contains = true;
        }
      });
      if (contains && !documentAdded.contains(snaps.id)) {
        this.userDocs.add(snaps);
        documentAdded.add(snaps.id);
      }
    }
  }

  SwiperController _controller = SwiperController();

  @override
  void didChangeDependencies() {
    setUserDocs();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
int _currIndex = 0;
  @override
  Widget build(BuildContext context) {
//    print('***');
    userProvider user = Provider.of<userProvider>(context);
    // TODO: implement build
    return userDocs.length == 0
        ? Container()
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black.withOpacity(0.5),
            ),
            alignment: Alignment.center,
            height: double.maxFinite,
            width: double.maxFinite,
            child: Stack(
//        mainAxisSize: MainAxisSize.min,
              children: [
                Swiper(
                  itemCount: userDocs.length,
                  controller: _controller,
                  itemBuilder: (context, idx) {
                    DocumentSnapshot curr = userDocs[idx];
                    return PostUI(
                      curr.id,
                      postDetails: curr.data(),
                      showOption: false,
                    );
                  },
                  onIndexChanged: (idx){
                    setState(() {
                      _currIndex = idx;
                    });
                  },
                  layout: SwiperLayout.TINDER,
                  loop: false,
                  itemWidth: MediaQuery.of(context).size.width * 0.9,
                  itemHeight: MediaQuery.of(context).size.height * 0.7,
                ),
                Container(

                  height: MediaQuery.of(context).size.height * 0.85,
                  width: double.maxFinite,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Material(
                      color: Colors.transparent,
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          child: CircleAvatar(
                            radius: 21,
                            backgroundColor: Colors.grey,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 20,
                              child: Icon(
                                Icons.cancel,
                                color: Colors.red,
                                size: 24,
                              ),
                            ),
                          ),
                          onTap: () {
                            if(_currIndex == userDocs.length)
                              Navigator.of(context).pop();
                            _controller.next();
                          },
                        ),
                        SizedBox(width: 10,),
                        GestureDetector(
                          child: CircleAvatar(
                            radius: 31,
                            backgroundColor: Colors.grey,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 30,
                              child: Icon(
                                Icons.thumb_up,
                                color: user.userLikedPosts.contains(
                                        userDocs[_currIndex].id)
                                    ? Colors.blue
                                    : Colors.black,
                                size: 35,
                              ),
                            ),
                          ),
                          onTap: () {
                            if (user.userLikedPosts
                                .contains(userDocs[_currIndex].id))
                              return;
                            user.likeAVideo(userDocs[_currIndex].id);
                            FirestoreFunction.likeAPost(
                                userDocs[_currIndex].id,
                                userDocs[_currIndex].data()['userId']);
                          },
                        ),
                        SizedBox(width: 10,),
                        GestureDetector(
                          child: CircleAvatar(
                            radius: 31,
                            backgroundColor: Colors.grey,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 30,
                              child: Icon(
                                Icons.shopping_cart,
                                color: Colors.yellow,
                                size: 35,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => buyProductScreen(
                                  userDocs[_currIndex]
                                          .data()['postIdx'] ??
                                      1,
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 10,),
                        GestureDetector(
                          child: CircleAvatar(
                            radius: 21,
                            backgroundColor: Colors.grey,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 20,
                              child: Icon(
                                Icons.info_outline,
                                color: Colors.green,
                                size: 25,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewPostScreen(
                                  userDocs[_currIndex].id,
                                  postDetails:
                                      userDocs[_currIndex].data(),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
