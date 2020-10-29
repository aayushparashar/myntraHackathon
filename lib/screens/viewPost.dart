import 'package:MyntraHackathon/screens/profile_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewPostScreen extends StatefulWidget {
  Map<String, dynamic> postDetails;

  ViewPostScreen({this.postDetails});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ViewPostState();
  }
}

class ViewPostState extends State<ViewPostScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.postDetails['userName']),
        ),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(height: 10,),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        widget.postDetails['imageUrl']),
                    fit: BoxFit.fitWidth),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              child: Text(
                'About the user',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              padding: EdgeInsets.only(left: 20),
            ),
            Padding(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: widget.postDetails['userImage'] == null
                    ? AssetImage('assets/userIcon.png')
                    : CachedNetworkImageProvider(
                        widget.postDetails['userImage'],
                      ),
              ),
              padding: EdgeInsets.only(left: 20),
            ),
            Padding(
              child: Text(widget.postDetails['userName'], style: TextStyle(fontSize: 20),),
              padding: EdgeInsets.only(left: 20),
            ),
//              if (!widget.showOption)

//            if (!widget.showOption)
            Padding(
              child: Text(
                '${widget.postDetails['bio'] ?? ''}',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 18),
              ),
              padding: EdgeInsets.only(left: 20),
            ),
                Padding(
                  child: Text(
                    'Posted on : ${DateTime.parse(widget.postDetails['timestamp'].toDate().toString()).toString()}',
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  padding: EdgeInsets.only(left: 20),
                ),
                Padding(child: FlatButton(
              child: Text('View Profile'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => ProfileScreen(
                      uid: widget.postDetails['userId'],
//                      marker: widget.marker,
                    )));
              },
          ), padding: EdgeInsets.only(left: 20),),
                SizedBox(height: 20,),
                Center(child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  onPressed: () {},
                  child: Text(
                    'BUY NOW',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Theme.of(context).accentColor,
                ),),
          ]),
        ));
  }
}
