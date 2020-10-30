import 'package:MyntraHackathon/Widget/buyProduct.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderListScreen extends StatefulWidget {
  Function setOrder;

  OrderListScreen(this.setOrder);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OrderState();
  }
}

class OrderState extends State<OrderListScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Order'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(child: Column(
          children: [
            Text(
              'Select which product you want to promote!',
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 10,
            ),
            orderCard(1),
            SizedBox(
              height: 10,
            ),
            orderCard(2),
            SizedBox(
              height: 10,
            ),
            orderCard(3),
            SizedBox(
              height: 10,
            ),
            orderCard(4),
          ],
        ),
        ),
      ),
    );
  }

  Widget orderCard(int cnt) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/orders/${cnt}a.jpeg'),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
            FlatButton(onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> buyProductScreen(cnt)));
            }, child: Text('View Product')),
            FlatButton(
                onPressed: () {
                  widget.setOrder(cnt);
                },
                child: Text('Promote Product'))
          ])
        ],
      ),
    );
  }
}
