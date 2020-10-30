import 'package:MyntraHackathon/Provider/googleMapMarkers.dart';
import 'package:MyntraHackathon/Provider/userProvider.dart';
import 'package:MyntraHackathon/Widget/buyProduct.dart';
import 'package:MyntraHackathon/firebaseFunctions/firestoreFunctions.dart';
import 'file:///F:/AndroidStudioProjects/MyntraHackathon/MyntraHackathon/lib/screens/navigationScreens/profile_screen.dart';
import 'package:MyntraHackathon/screens/viewPost.dart';
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
      body:
//        SingleChildScrollView(
//      child:
          Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
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
              trailing: widget.showOption
                  ? FlatButton(
                      child: Text('View Profile'),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => ProfileScreen(
                              uid: widget.postDetails['userId'],
                            ),
                          ),
                        );
                      },
                    )
                  : null,
              contentPadding: EdgeInsets.all(0),
              onTap: () async {},
            ),
            width: MediaQuery.of(context).size.width,
          ),
          Center(
            child: Container(
              alignment: Alignment.center,
              height: 300,
              width: 200,
//            width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFD9D9D9), width: 5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: CachedNetworkImage(
                imageUrl: '${widget.postDetails['imageUrl']}',
                fit: BoxFit.fill,
              ),
            ),
          ),
          Row(
            children: [
              FlatButton.icon(
                onPressed: () {
                  user.likeAVideo(widget.postId);
                  FirestoreFunction.likeAPost(
                      widget.postId, widget.postDetails['userId']);
                  setState(() {
                    likes = likes + 1;
                  });
                },
                icon: Icon(
                  user.userLikedPosts.contains(widget.postId)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color:  user.userLikedPosts.contains(widget.postId)
                      ? Colors.red: Colors.black,
                ),
                label: Text('$likes'),
              ),
//              SizedBox(
//                width: 10,
//              ),
              InkWell(
//            padding: EdgeInsets.all(0),
                child: Icon(Icons.share), onTap: () {},
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          if (widget.showOption)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => buyProductScreen(
                            widget.postDetails['postIdx'] ?? 1),
                      ),
                    );
                  },
                  child: Text(
                    'BUY NOW',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Theme.of(context).accentColor,
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewPostScreen(
                                  postDetails: widget.postDetails,
                                )));
                  },
                  child: Text(
                    'VIEW POST',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Theme.of(context).accentColor,
                ),
              ],
            ),
          if (!widget.showOption)
            Padding(
              child: Text(
                'Posted on : ${DateTime.parse(widget.postDetails['timestamp'].toDate().toString()).toString()}',
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
              padding: EdgeInsets.only(left: 20),
            ),
          if (!widget.showOption)
            Padding(
              child: Text(
                '${widget.postDetails['bio'] ?? ''}',
                textAlign: TextAlign.start,
              ),
              padding: EdgeInsets.only(left: 20),
            )
        ],
      ),
//    )
    );
  }
}
