import 'package:flutter/material.dart';

class Unavailable extends StatelessWidget {
  final String data;

  Unavailable({Key key, @required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
        title: Text(
          data,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        child: Center(
          child: Text("No data available",
              style: TextStyle(fontSize: 18),),
        ),
      ),
    );
  }
}
