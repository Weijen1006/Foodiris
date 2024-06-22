import 'package:flutter/material.dart';

class Allergy extends StatelessWidget {
  final allergyDetails;

  Allergy({Key key, @required this.allergyDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
        title: Text(
          allergyDetails.get("name"),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
        child: ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              child: Image.network(
                allergyDetails.get("photo"),
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.orangeAccent)
              ),
              child: Text(
                allergyDetails.get("description"),
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
