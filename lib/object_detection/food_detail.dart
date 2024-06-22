import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../text_recognition/nutrition_detail.dart';
import '../pending.dart';

class FoodDetail extends StatefulWidget {
  final foodDetails;

  FoodDetail({Key key, @required this.foodDetails}) : super(key: key);

  @override
  _FoodDetailState createState() => _FoodDetailState();
}

class _FoodDetailState extends State<FoodDetail> {
  final ScrollController _scrollController1 = ScrollController();
  final ScrollController _scrollController2 = ScrollController();
  QuerySnapshot nutrient;

  void getDetail() async {
    final firestore = FirebaseFirestore.instance;
    nutrient = await firestore.collection('Nutrients').get();
  }

  void initState() {
    getDetail();
    super.initState();
  }

  void nutrientRoute(String selected) {
    bool exist = false;
    int index = 0;
    for (int i = 0; i < nutrient.docs.length; i++) {
      if (selected == nutrient.docs[i]["name"].toString()) {
        exist = true;
        index = i;
        break;
      }
    }

    if (exist) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Detail(
                    nutritionDetails: nutrient.docs[index],
                  )));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Unavailable(
                    data: selected,
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
        title: Text(
          widget.foodDetails.get("name"),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.foodDetails.get("description"),
              style: TextStyle(fontSize: 22),
            ),
            Divider(
              height: 40,
              thickness: 1,
              color: Colors.orangeAccent,
            ),
            Text(
              "Nutrition Facts",
              style: TextStyle(fontSize: 20),
            ),
            Padding(padding: EdgeInsets.all(5.0)),
            Expanded(
              child: Scrollbar(
                isAlwaysShown: true,
                controller: _scrollController1,
                child: ListView.builder(
                    shrinkWrap: true,
                    controller: _scrollController1,
                    itemCount: widget.foodDetails.get("nutrient").length,
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
                                nutrientRoute(widget.foodDetails
                                    .get("nutrient")[index]
                                    .toString());
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      widget.foodDetails.get("nutrient")[index],
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      widget.foodDetails
                                          .get("nutrient_amount")[index],
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
            Divider(
              height: 40,
              thickness: 1,
              color: Colors.orangeAccent,
            ),
            Text(
              "Rich source of",
              style: TextStyle(fontSize: 20),
            ),
            Padding(padding: EdgeInsets.all(5.0)),
            Expanded(
              child: Scrollbar(
                isAlwaysShown: true,
                controller: _scrollController2,
                child: ListView.builder(
                    shrinkWrap: true,
                    controller: _scrollController2,
                    itemCount: widget.foodDetails.get("source").length,
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
                                nutrientRoute(widget.foodDetails
                                    .get("source")[index]
                                    .toString());
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  widget.foodDetails.get("source")[index],
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
