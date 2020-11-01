import 'package:MyntraHackathon/Provider/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubscriptionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SubscriptionState();
  }
}

class SubscriptionState extends State<SubscriptionPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(appBar: AppBar(
      title: Text('Subscribe to Myntra More'),
    ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/myntraIcon.png',
              height: 50,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Let\'s choose a plan that works out the best for you!',
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(
              height: 20,
            ),
            Card(
              child: ListTile(
                leading: Image.asset('assets/subscriptions/0.jpeg'),
                title: Text('Silver'),
                subtitle: Text('₹100 pm \n30 posts per month'),
                 isThreeLine: true,
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Provider.of<userProvider>(context, listen: false).subscribe();
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              child: ListTile(
                leading: Image.asset('assets/subscriptions/1.jpeg'),
                title: Text('Gold'),
                subtitle: Text('₹200 pm \n45 posts per month'),
                trailing: Icon(Icons.arrow_forward_ios),
                isThreeLine: true,
                onTap: () {
                  Provider.of<userProvider>(context, listen: false).subscribe();},
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              child: ListTile(
                leading: Image.asset('assets/subscriptions/2.jpeg'),
                title: Text('Platinum'),
                subtitle: Text('₹300 pm \n60 posts per month'),
                trailing: Icon(Icons.arrow_forward_ios),
                isThreeLine: true,
                onTap: () {
                  Provider.of<userProvider>(context, listen: false).subscribe();
                  },
              ),
            )
          ],
        ),
      ),
    );
  }
}
