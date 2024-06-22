import 'package:flutter/material.dart';

class Detail extends StatelessWidget {
  final nutritionDetails;

  Detail({Key key, @required this.nutritionDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
        title: Text(
          nutritionDetails.get("name"),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "Major Role :",
                style: TextStyle(fontSize: 30),
              ),
            ),
            Text(
              "\n${nutritionDetails.get("role")}",
              style: TextStyle(fontSize: 20),
            ),
            Divider(
              height: 50,
              thickness: 2,
              color: Colors.orangeAccent,
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "Primary Sources :",
                style: TextStyle(fontSize: 30),
              ),
            ),
            Text(
              "\n${nutritionDetails.get("source")}",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
