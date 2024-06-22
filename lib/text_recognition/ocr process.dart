import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'nutrition_detail.dart';
import 'allergies_detail.dart';

class Keyword extends StatefulWidget {
  final textDetected;

  Keyword({Key key, @required this.textDetected}) : super(key: key);

  @override
  _KeywordState createState() => _KeywordState();
}

class _KeywordState extends State<Keyword> {
  List<QueryDocumentSnapshot> detectedAllergy = [];
  List<QueryDocumentSnapshot> detectedNutrition = [];
  bool exist = true;

  @override
  void initState() {
    filterText();
    Timer(Duration(seconds: 5), () {
      setState(() {
        exist = false;
      });
    });
    super.initState();
  }

  void filterText() async {
    final firestore = FirebaseFirestore.instance;
    QuerySnapshot allergy = await firestore.collection('Allergies').get();
    QuerySnapshot nutrition = await firestore.collection('Nutrients').get();
    for (int i = 0; i < allergy.docs.length; i++) {
      if (widget.textDetected
          .contains(allergy.docs[i]["name"].toString().toLowerCase())) {
        setState(() {
          detectedAllergy.add(allergy.docs[i]);
        });
      }
    }
    for (int i = 0; i < nutrition.docs.length; i++) {
      if (widget.textDetected
          .contains(nutrition.docs[i]["name"].toString().toLowerCase())) {
        setState(() {
          detectedNutrition.add(nutrition.docs[i]);
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
          "Keywords",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: (detectedAllergy.length == 0 && detectedNutrition.length == 0)
            ? Center(
                child: exist
                    ? CircularProgressIndicator()
                    : Text(
                        "No Keyword Found",
                        style: TextStyle(fontSize: 18),
                      ))
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    (detectedAllergy.length != 0)
                        ? Text(
                            "Allergy Alert!!!",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        : Container(),
                    (detectedAllergy.length != 0)
                        ? Padding(padding: EdgeInsets.all(5.0))
                        : Container(),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: detectedAllergy.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            padding: EdgeInsets.all(5),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 3,
                                    color: Colors.redAccent,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Card(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> Allergy(allergyDetails: detectedAllergy[index],)));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          detectedAllergy[index]["name"],
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        Icon(
                                          Icons.warning_amber_rounded,
                                          color: Colors.redAccent,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                    (detectedAllergy.length != 0 && detectedNutrition.length != 0)
                        ? Divider(
                            height: 40,
                            thickness: 1,
                            color: Colors.orangeAccent,
                          )
                        : Container(),
                    (detectedNutrition.length != 0)
                        ? Text(
                            "Nutrition Facts",
                            style: TextStyle(fontSize: 20),
                          )
                        : Container(),
                    Padding(padding: EdgeInsets.all(5.0)),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: detectedNutrition.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            padding: EdgeInsets.all(5),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 3,
                                    color: Colors.black12,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Card(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Detail(
                                                  nutritionDetails:
                                                      detectedNutrition[index],
                                                )));
                                  },
                                  child: ListTile(
                                    title: Text(
                                      detectedNutrition[index]["name"],
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    subtitle:
                                        Text(detectedNutrition[index]["type"]),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              ),
      ),
    );
  }
}
