import 'package:flutter/material.dart';

class buyProductScreen extends StatefulWidget{
  int imageIdx;
  buyProductScreen(this.imageIdx);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BuyProductState();
  }
}
class BuyProductState extends State<buyProductScreen>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Image.asset('assets/orders/${widget.imageIdx}b.jpeg', fit: BoxFit.fill,),
    );
  }
}