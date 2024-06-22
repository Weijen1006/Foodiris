import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'food_detail.dart';

class Food extends StatefulWidget {
  final result;
  final confidence;

  Food({Key key, @required this.result, this.confidence}) : super(key: key);

  @override
  _FoodState createState() => _FoodState();
}

class _FoodState extends State<Food> {
  List<QueryDocumentSnapshot> output = [];
  List<String> _confidence = [];
  bool exist = true;

  void initState() {
    filterDetection();
    Timer(Duration(seconds: 5), () {
      setState(() {
        exist = false;
      });
    });
    super.initState();
  }

  void filterDetection() async {
    final firestore = FirebaseFirestore.instance;
    QuerySnapshot food = await firestore.collection('Food').get();
    for (int i = 0; i < food.docs.length; i++) {
      if (widget.result
          .contains(food.docs[i]["name"].toString().toLowerCase())) {
        setState(() {
          output.add(food.docs[i]);
          _confidence.add(widget.confidence[widget.result
              .indexOf(food.docs[i]["name"].toString().toLowerCase())]);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text(
          "Detected Food",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: output.length == 0
            ? Center(
                child: exist
                    ? CircularProgressIndicator()
                    : Text(
                        "No Food Found",
                        style: TextStyle(fontSize: 18),
                      ),)
            : ListView.builder(
                itemCount: output.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: EdgeInsets.all(5),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 3,
                            color: Colors.black12,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Card(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FoodDetail(
                                          foodDetails: output[index],
                                        )));
                          },
                          child: ListTile(
                            title: Text(
                              output[index]["name"],
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Text("Confidence : ${_confidence[index]}"),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
      ),
    );
  }
}
