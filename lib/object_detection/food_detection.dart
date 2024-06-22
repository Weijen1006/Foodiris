import 'package:flutter/material.dart';
import 'dart:io';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'detected_food.dart';

class Detection extends StatefulWidget {
  @override
  _DetectionState createState() => _DetectionState();
}

class _DetectionState extends State<Detection> {
  File pickedImage;
  final picker = ImagePicker();
  bool imageLoaded = false;
  List<String> result;
  List<String> confidence;

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

  Future ssdModel() async {
    String res = await Tflite.loadModel(
        model: "assets/tflite/detect.tflite",
        labels: "assets/tflite/labelmap.txt",
        numThreads: 1,
        // defaults to 1
        isAsset: true,
        // defaults to true, set to false to load resources outside assets
        useGpuDelegate:
            false // defaults to false, set to true to use GPU delegate
        );
    var recognition = await Tflite.detectObjectOnImage(
        path: pickedImage.path,
        // required
        model: "SSDMobileNet",
        imageMean: 127.5,
        imageStd: 127.5,
        threshold: 0.4,
        // defaults to 0.1
        numResultsPerClass: 2,
        // defaults to 5
        asynch: true // defaults to true
        );

    print(res);
    setState(() {
      result = [];
      confidence = [];
      for (var name in recognition) {
        result.add(name["detectedClass"]);
        confidence
            .add("${(name["confidenceInClass"] * 100).toStringAsFixed(0)}%");
      }
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Food(result: result, confidence: confidence)));
    });
  }

  void alertHelp() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Welcome to Food Detection"),
          content: Text(
              "This feature allows you to put in the photo of real food via gallery and camera (Eg: Photo of an apple).\n\nPress \"Detect\" button to identify the food in your photo.\n\nIt will analyse the photo and produce the results with confidence level,\nwhere you can click to check on the food details."),
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
          "Food Detection",
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
                    child: Text("Detect"),
                    onPressed: ssdModel,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
