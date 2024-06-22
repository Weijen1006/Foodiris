import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'object_detection/food_detection.dart';
import 'text_recognition/ocr.dart';
import 'expiry_reminder/reminder_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
String timezone;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var initializationSettingsAndroid =
      AndroidInitializationSettings('foodiris_logo');

  var initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  });

  tz.initializeTimeZones();
  timezone = await FlutterNativeTimezone.getLocalTimezone();

  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        accentColor: Colors.orangeAccent,
        highlightColor: Colors.orangeAccent,
        colorScheme: ColorScheme.light(
            primary: Colors.orangeAccent //date picker color scheme
            )),
    home: Main_menu(),
  ));
}

class Main_menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [
                0.1,
                0.3,
                0.5,
                0.8,
                0.9
              ],
              colors: [
                Colors.orange[500],
                Colors.orange[200],
                Colors.orange[300],
                Colors.orange[400],
                Colors.orange[600],
              ]),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/images/foodiris logo.png'),
                width: 200,
              ),
              Padding(padding: EdgeInsets.all(60)),
              Column(
                children: <Widget>[
                  ButtonTheme(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    buttonColor: Colors.white,
                    minWidth: 200,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => (Detection())));
                      },
                      child: Text("Food Detection"),
                    ),
                  ),
                  ButtonTheme(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    buttonColor: Colors.white,
                    minWidth: 200,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Label()));
                      },
                      child: Text("Food Label Scanner"),
                    ),
                  ),
                  ButtonTheme(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    buttonColor: Colors.white,
                    minWidth: 200,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Reminder(timezone)));
                      },
                      child: Text("Expiry Date Reminder"),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
