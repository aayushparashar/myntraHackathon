import 'package:MyntraHackathon/Provider/googleMapMarkers.dart';
import 'package:MyntraHackathon/Provider/userProvider.dart';
import 'package:MyntraHackathon/Widget/buyProduct.dart';
import 'package:MyntraHackathon/firebaseFunctions/firebaseAuth.dart';
import 'package:MyntraHackathon/firebaseFunctions/firestoreFunctions.dart';
import 'package:MyntraHackathon/staticData/orderDetails.dart';
import 'file:///F:/AndroidStudioProjects/MyntraHackathon/MyntraHackathon/lib/screens/navigationScreens/profile_screen.dart';
import 'file:///F:/AndroidStudioProjects/MyntraHackathon/MyntraHackathon/lib/screens/navigationScreens/viewPost.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//The UI of how the post is rendered on the screen
class PostUI extends StatefulWidget {
  Map<String, dynamic> postDetails;
  GoogleMapMarker marker;
  bool showOption;
  String postId;

  PostUI(this.postId, {this.postDetails, this.showOption = true, this.marker});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PostState();
  }
}

class PostState extends State<PostUI> {
  userProvider user;
  int likes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.likes = widget.postDetails['likes'] ?? 0;
  }

  @override
  void didChangeDependencies() {
    user = Provider.of<userProvider>(context);
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

//  bool loading = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: widget.postDetails['userImage'] == null
                      ? AssetImage('assets/userIcon.png')
                      : NetworkImage(widget.postDetails['userImage']),
                ),
                title: Text(widget.postDetails['userName']),
                subtitle: Text(widget.postDetails['address'] ?? ''),
                trailing: widget.postDetails['userId'] ==
                        FirebaseAuthentication.auth.currentUser.uid
                    ? null
                    : FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(70)),
                        onPressed: user.userFollowers
                                .contains(widget.postDetails['userId'])
                            ? null
                            : () {
                                user.followUser(widget.postDetails['userId']);
                              },
                        child: Text(
                          user.userFollowers
                                  .contains(widget.postDetails['userId'])
                              ? 'Followed'
                              : 'Follow user',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                contentPadding: EdgeInsets.all(0),
                onTap: () async {},
              ),
              width: MediaQuery.of(context).size.width,
            ),
            CachedNetworkImage(
              imageUrl: '${widget.postDetails['imageUrl']}',
              fit: BoxFit.fill,
              height: MediaQuery.of(context).size.height * 0.45,
              width: MediaQuery.of(context).size.width,
              progressIndicatorBuilder: (context, _, __) {
                return CircularProgressIndicator();
              },
              alignment: Alignment.center,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                OrderDetails
                        .details[((widget.postDetails['postType'] ?? 1)) - 1]
                    ['details'],
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(OrderDetails.details[(widget.postDetails['postType'] ?? 1) - 1]
                ['product'])
//          if (widget.showOption)
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//              children: [
//                MaterialButton(
//                  shape: RoundedRectangleBorder(
//                    borderRadius: BorderRadius.circular(10),
//                  ),
//                  onPressed: () {
//                    Navigator.of(context).push(
//                      MaterialPageRoute(
//                        builder: (ctx) => buyProductScreen(
//                            widget.postDetails['postIdx'] ?? 1,
//                        ),
//                      ),
//                    );
//                  },
//                  child: Text(
//                    'BUY NOW',
//                    style: TextStyle(color: Colors.white),
//                  ),
//                  color: Theme.of(context).accentColor,
//                ),
//                MaterialButton(
//                  shape: RoundedRectangleBorder(
//                    borderRadius: BorderRadius.circular(10),
//                  ),
//                  onPressed: () {
//                    Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                            builder: (context) => ViewPostScreen(
//                              widget.postId,
//                                  postDetails: widget.postDetails,
//                                )));
//                  },
//                  child: Text(
//                    'VIEW POST',
//                    style: TextStyle(color: Colors.white),
//                  ),
//                  color: Theme.of(context).accentColor,
//                ),
//              ],
//            ),
//          if (!widget.showOption)
//            Padding(
//              child: Text(
//                'Posted on : ${DateTime.parse(widget.postDetails['timestamp'].toDate().toString()).toString()}',
//                textAlign: TextAlign.start,
//                style: TextStyle(color: Colors.grey, fontSize: 10),
//              ),
//              padding: EdgeInsets.only(left: 20),
//            ),
//          if (!widget.showOption)
//            Padding(
//              child: Text(
//                '${widget.postDetails['bio'] ?? ''}',
//                textAlign: TextAlign.start,
//              ),
//              padding: EdgeInsets.only(left: 20),
//            )
          ],
        ),
      ),
//    )
    );
  }
}
