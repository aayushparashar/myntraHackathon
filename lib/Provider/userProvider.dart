import 'package:MyntraHackathon/firebaseFunctions/firebaseAuth.dart';
import 'package:MyntraHackathon/firebaseFunctions/firestoreFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class userProvider extends ChangeNotifier {
  bool isSubscribed = false;
  int posts_this_month = 0;
  bool openedMap = false;
  Position currLocation;
  List<dynamic> userLikedPosts = [];
  List<dynamic> userFollowers = [];

  void updateUserLikedPosts(dynamic list){
    this.userLikedPosts = [];
  }
  bool subscribe() {
    this.isSubscribed = true;
    notifyListeners();
  }
  bool openedMyntraMoreMap(){
    this.openedMap = true;
    notifyListeners();
  }
  void setCurrLocation(Position p){
    this.currLocation = p;
  }
  void likeAVideo(String postId){
    this.userLikedPosts.add(postId);
    notifyListeners();
  }
  Map<String, dynamic> userDetails;
  void setUserDetails() async{
    this.userDetails = await FirestoreFunction.getCurrentUserDetails();
    this.userLikedPosts = userDetails['likedPosts']??[];
    this.userFollowers = userDetails['following']??[];
    notifyListeners();
  }
  void followUser(String followerId){
    this.userFollowers.add(followerId);
    notifyListeners();
    FirestoreFunction.followUser(followerId, FirebaseAuthentication.auth.currentUser.uid);

  }
}
