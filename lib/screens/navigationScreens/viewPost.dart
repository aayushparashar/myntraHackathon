import 'file:///F:/AndroidStudioProjects/MyntraHackathon/MyntraHackathon/lib/screens/navigationScreens/profile_screen.dart';
import 'package:MyntraHackathon/Provider/userProvider.dart';
import 'package:MyntraHackathon/Widget/buyProduct.dart';
import 'package:MyntraHackathon/firebaseFunctions/firestoreFunctions.dart';
import 'package:MyntraHackathon/staticData/orderDetails.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewPostScreen extends StatefulWidget {
  Map<String, dynamic> postDetails;
  String postId;
bool showUser;
  ViewPostScreen(postId, {this.postDetails, this.showUser = true});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ViewPostState();
  }
}

class ViewPostState extends State<ViewPostScreen> {
  int likes = 0;

  @override
  void initState() {
    this.likes = widget.postDetails['likes'] ?? 0;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userProvider user = Provider.of<userProvider>(context);
    // TODO: implement build
    return Scaffold(
      bottomNavigationBar: widget.showUser?Builder(
        builder: (context) => MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          onPressed: () {},
          child: Text(
            'BUY NOW',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          color: Theme.of(context).accentColor,
        ),
      ):null,
      appBar: widget.showUser?AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title:  ListTile(
          title: Text(OrderDetails.details[widget.postDetails['postType'] ?? 1 - 1]
        ['product'], style: TextStyle(fontWeight: FontWeight.bold),),
        subtitle:  Text(OrderDetails.details[widget.postDetails['postType'] ?? 1 - 1]
        ['company']),
        ),

      ): null,
      body: Card(
        child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: widget.postDetails['imageUrl'],
                fit: BoxFit.fill,
                height: MediaQuery.of(context).size.height*0.6,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton.icon(
                      onPressed: () {
                        if (user.userLikedPosts.contains(widget.postId)) return;
                        user.likeAVideo(widget.postId);
                        FirestoreFunction.likeAPost(
                            widget.postId, widget.postDetails['userId']);
                        setState(() {
                          likes = likes + 1;
                        });
                      },
                      icon: Icon(
                        Icons.thumb_up,
                        color: user.userLikedPosts.contains(widget.postId)
                            ? Theme.of(context).accentColor
                            : Colors.black,
                      ),
                      label: Text('Like')),
                  FlatButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.shopping_cart,
                        color: Colors.black,
                      ),
                      label: Text('Add to Cart')),
                  FlatButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => buyProductScreen(
                                widget.postDetails['postIdx'] ?? 1),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.tag,
                      ),
                      label: Text('View Product'))
                ],
              ),
              Padding(
                child: Text(
                  '${widget.postDetails['bio']??''}',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 16),
                ),
                padding: EdgeInsets.only(left: 20),
              ),
//            Spacer(),
              Divider(),
              if(widget.showUser)
                ListTile(
                leading: CircleAvatar(
//                    radius: 50,
                  backgroundImage: widget.postDetails['userImage'] == null
                      ? AssetImage('assets/userIcon.png')
                      : CachedNetworkImageProvider(
                          widget.postDetails['userImage'],
                        ),
                ),
                title: Text(
                  widget.postDetails['userName'],
                  style: TextStyle(fontSize: 20),
                ),
                subtitle: Text(
                  'Posted on : ${DateTime.parse(widget.postDetails['timestamp'].toDate().toString()).toString()}',
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
                trailing: FlatButton(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Text('View Profile'),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => ProfileScreen(
                              uid: widget.postDetails['userId'],
//                      marker: widget.marker,
                            )));
                  },
                ),
              )
            ],
          ),

        elevation: 10,
      ),
    );
  }
}
