import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'ocr process.dart';

class Label extends StatefulWidget {
  @override
  _LabelState createState() => _LabelState();
}

class _LabelState extends State<Label> {
  File pickedImage;
  final picker = ImagePicker();
  bool imageLoaded = false;
  String result = "Result here";

  Future pickImageFromGallery() async {
    try {
      var temp = await picker.getImage(source: ImageSource.gallery);

      setState(() {
        pickedImage = File(temp.path);
        imageLoaded = true;
      });
    } catch (ex) {
      print(ex);
    }
  }

  Future pickImageFromCamera() async {
    try {
      var temp = await picker.getImage(source: ImageSource.camera);

      setState(() {
        pickedImage = File(temp.path);
        imageLoaded = true;
      });
    } catch (ex) {
      print(ex);
    }
  }

  Future readText() async {
    FirebaseVisionImage myImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(myImage);
    result = '';

    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        result = result + ' ' + line.text + '\n';
      }
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Keyword(textDetected: result.toLowerCase())));
  }

  void alertHelp() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Welcome to Food Label Scanner"),
          content: Text(
              "This feature allows you to put in the photo of food labels via gallery and camera.\n\nPress \"Read Text\" button to identify the keywords in your food label.\n\nIt will analyse the photo and produce the list of keywords identified including allergies and nutrition facts,\nwhere you can click to check on the details."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text(
          "Food Label Scanner",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.help,
              color: Colors.white,
            ),
            onPressed: alertHelp,
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          imageLoaded
              ? Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 1.75,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: FileImage(pickedImage),
                      fit: BoxFit.contain,
                    )),
                  ),
                )
              : Container(
                  height: MediaQuery.of(context).size.height / 1.75,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(
                      "Please pick an image",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                child: Text("Gallery"),
                onPressed: pickImageFromGallery,
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              RaisedButton(
                child: Text("Camera"),
                onPressed: pickImageFromCamera,
              ),
            ],
          ),
          Padding(padding: EdgeInsets.all(8.0)),
          imageLoaded
              ? Center(
                  child: RaisedButton(
                    child: Text("Read Text"),
                    onPressed: readText,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
