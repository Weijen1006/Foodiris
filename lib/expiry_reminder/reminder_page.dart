import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fyp/main.dart';
import 'reminder_helper.dart';
import 'reminder_model.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class Reminder extends StatefulWidget {
  Reminder(this.timezone);

  final String timezone;

  @override
  _ReminderState createState() => _ReminderState();
}

class _ReminderState extends State<Reminder> {
  TextEditingController _foodName;
  DateTime _reminderDate;
  String _reminderDateString;
  ReminderHelper _reminderHelper = ReminderHelper();
  Color _buttonColor = Colors.white;
  Future<List<ReminderInfo>> _reminders;
  bool isNameValid = true;

  @override
  void initState() {
    _foodName = new TextEditingController();
    _reminderHelper.initializeDatabase().then((value) {
      // print('-----database initialized');
      loadReminders();
    });

    super.initState();
  }

  void loadReminders() {
    _reminders = _reminderHelper.getReminders();
    if (mounted) setState(() {});
  }

  void chooseReminder(
      ReminderInfo reminderInfo, int id, String timezone) async {
    bool oneDay = false;
    bool threeDay = false;
    bool sevenDay = false;
    bool fourteenDay = false;
    bool thirtyDay = false;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setBuilderState) {
          return AlertDialog(
            title: Text("Interval of reminder"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  (reminderInfo.reminderDate
                              .difference(DateTime.now())
                              .inDays >=
                          0)
                      ? CheckboxListTile(
                          title: Text("On expiry date (default)"),
                          value: true,
                          onChanged: null,
                        )
                      : Container(),
                  (reminderInfo.reminderDate
                              .difference(DateTime.now())
                              .inDays >=
                          1)
                      ? CheckboxListTile(
                          title: Text("1 day before"),
                          value: oneDay,
                          onChanged: (bool checked) {
                            setBuilderState(() {
                              oneDay = checked;
                            });
                          })
                      : Container(),
                  (reminderInfo.reminderDate
                              .difference(DateTime.now())
                              .inDays >=
                          3)
                      ? CheckboxListTile(
                          title: Text("3 days before"),
                          value: threeDay,
                          onChanged: (bool checked) {
                            setBuilderState(() {
                              threeDay = checked;
                            });
                          })
                      : Container(),
                  (reminderInfo.reminderDate
                              .difference(DateTime.now())
                              .inDays >=
                          7)
                      ? CheckboxListTile(
                          title: Text("7 days before"),
                          value: sevenDay,
                          onChanged: (bool checked) {
                            setBuilderState(() {
                              sevenDay = checked;
                            });
                          })
                      : Container(),
                  (reminderInfo.reminderDate
                              .difference(DateTime.now())
                              .inDays >=
                          14)
                      ? CheckboxListTile(
                          title: Text("14 days before"),
                          value: fourteenDay,
                          onChanged: (bool checked) {
                            setBuilderState(() {
                              fourteenDay = checked;
                            });
                          })
                      : Container(),
                  (reminderInfo.reminderDate
                              .difference(DateTime.now())
                              .inDays >=
                          30)
                      ? CheckboxListTile(
                          title: Text("30 days before"),
                          value: thirtyDay,
                          onChanged: (bool checked) {
                            setBuilderState(() {
                              thirtyDay = checked;
                            });
                          })
                      : Container(),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
    if (oneDay) {
      scheduleReminderInterval(reminderInfo, id, timezone, 1);
    }
    if (threeDay) {
      scheduleReminderInterval(reminderInfo, id, timezone, 3);
    }
    if (sevenDay) {
      scheduleReminderInterval(reminderInfo, id, timezone, 7);
    }
    if (fourteenDay) {
      scheduleReminderInterval(reminderInfo, id, timezone, 14);
    }
    if (thirtyDay) {
      scheduleReminderInterval(reminderInfo, id, timezone, 30);
    }
    scheduleReminder(reminderInfo, id, widget.timezone);
    loadReminders();
  }

  void scheduleReminderInterval(ReminderInfo reminderInfo, int id,
      String timezone, int remainingDay) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL ID',
      'CHANNEL NAME',
      'CHANNEL FOR REMINDING',
      importance: Importance.max,
      priority: Priority.high,
      icon: 'foodiris_logo',
      largeIcon: DrawableResourceAndroidBitmap('foodiris_logo'),
      enableVibration: true,
    );

    var platformChannelSpecifies =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    final location = tz.getLocation(timezone);
    final scheduledDate = tz.TZDateTime.from(
        reminderInfo.reminderDate.subtract(Duration(days: remainingDay)),
        location);
    // print(scheduledDate);

    int modifiedId;
    if (remainingDay == 1) {
      modifiedId = id + 1000;
    } else if (remainingDay == 3) {
      modifiedId = id + 2000;
    } else if (remainingDay == 7) {
      modifiedId = id + 3000;
    } else if (remainingDay == 14) {
      modifiedId = id + 4000;
    } else if (remainingDay == 30) {
      modifiedId = id + 5000;
    }

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          modifiedId,
          'Your food will expire in $remainingDay day(s) !!!',
          '${reminderInfo.title}',
          scheduledDate,
          platformChannelSpecifies,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);
    } catch (ex) {
      print(ex);
    }
    // print("Inserted $remainingDay");
  }

  void alertHelp() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Welcome to Expiry Date Reminder"),
          content: Text(
              "This feature helps you to keep track of your food's expiry dates.\n\nSimply enter your food name and choose an expiry date,\nand choose the interval of your reminders.\n\nIt will send the notifications based on your selection to remind you about your food."),
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

  void alertDelete(ReminderInfo reminder) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete “${reminder.title}” ?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Yes"),
              onPressed: () {
                _reminderHelper.delete(reminder.id);
                deleteReminder(reminder.id);
                loadReminders();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("No"),
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
          "Expiry Date Reminder",
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
      body: Container(
        padding: EdgeInsets.all(10),
        child: FutureBuilder<List<ReminderInfo>>(
          future: _reminders,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: snapshot.data.map<Widget>((reminder) {
                  var reminderDate =
                      DateFormat('yyyy-MM-dd').format(reminder.reminderDate);
                  return Container(
                    padding: EdgeInsets.all(5),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 3,
                            color: changeReminderColor(reminder.reminderDate),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                reminder.title,
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '$reminderDate',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      alertDelete(reminder);
                                    },
                                  ),
                                ],
                              ),
                              if (reminder.reminderDate
                                      .difference(DateTime.now())
                                      .inSeconds <=
                                  0)
                                Text(
                                  'Expired !!',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                )
                              else if (reminder.reminderDate
                                      .difference(DateTime.now())
                                      .inDays <
                                  1)
                                Text(
                                  'Expire in less than ${reminder.reminderDate.difference(DateTime.now()).inHours + 1} hour(s)',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                )
                              else
                                Text(
                                  'Expire in less than ${reminder.reminderDate.difference(DateTime.now()).inDays + 1} day(s)',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10.0,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.orangeAccent,
        onPressed: () {
          _reminderDateString = 'Please pick a date';
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            builder: (context) {
              return StatefulBuilder(
                builder: (context, modalState) {
                  return Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "Please enter the information",
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "Name : ",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              Flexible(
                                child: TextField(
                                  controller: _foodName,
                                  onChanged: (text) {
                                    if (text.isNotEmpty) {
                                      modalState(() {
                                        isNameValid = true;
                                      });
                                    }
                                  },
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                  decoration: InputDecoration(
                                      labelText: 'Enter Food Name',
                                      errorText: isNameValid
                                          ? null
                                          : 'Please do not leave blank'),
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                "Date : ",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              RaisedButton(
                                color: _buttonColor,
                                child: Text(
                                  _reminderDateString,
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                onPressed: () async {
                                  _reminderDate = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        DateTime.now().add(Duration(days: 1)),
                                    firstDate:
                                        DateTime.now().add(Duration(days: 1)),
                                    lastDate: DateTime(2030),
                                  );
                                  if (_reminderDate != null) {
                                    modalState(() {
                                      _reminderDateString =
                                          DateFormat('yyyy-MM-dd')
                                              .format(_reminderDate);
                                      _buttonColor = Colors.white;
                                    });
                                  }
                                },
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FlatButton(
                                child: Text("OK"),
                                onPressed: () async {
                                  if (_foodName.text.isEmpty) {
                                    modalState(() {
                                      isNameValid = false;
                                    });
                                  } else if (_reminderDate == null) {
                                    modalState(() {
                                      _buttonColor = Colors.redAccent;
                                    });
                                  } else {
                                    var reminderInfo = ReminderInfo(
                                      title: _foodName.text,
                                      reminderDate: _reminderDate,
                                    );
                                    int id = await _reminderHelper
                                        .insertReminder(reminderInfo);
                                    Navigator.of(context).pop();
                                    chooseReminder(
                                        reminderInfo, id, widget.timezone);
                                    _foodName.text = '';
                                    _reminderDate = null;
                                  }
                                },
                              ),
                              FlatButton(
                                child: Text("Cancel"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

Color changeReminderColor(date) {
  if (date.difference(DateTime.now()).inDays < 7)
    return Colors.red[300];
  else if (date.difference(DateTime.now()).inDays < 14)
    return Colors.yellow[300];
  else
    return Colors.green[300];
}

void scheduleReminder(
  ReminderInfo reminderInfo,
  int id,
  String timezone,
) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'reminder_notif',
    'reminder_notif',
    'Channel for Reminder notification',
    importance: Importance.max,
    priority: Priority.high,
    icon: 'foodiris_logo',
    largeIcon: DrawableResourceAndroidBitmap('foodiris_logo'),
    enableVibration: true,
  );

  var platformChannelSpecifies =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  final location = tz.getLocation(timezone);
  final scheduledDate = tz.TZDateTime.from(reminderInfo.reminderDate, location);
  try {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        'Your food had expired !!!',
        '${reminderInfo.title}',
        scheduledDate,
        platformChannelSpecifies,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  } catch (ex) {
    print(ex);
  }

  try {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Reminder created successfully',
        '${reminderInfo.title}',
        tz.TZDateTime.now(location).add(Duration(seconds: 1)),
        platformChannelSpecifies,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  } catch (ex) {
    print(ex);
  }
}

Future<void> deleteReminder(int id) async {
  try {
    await flutterLocalNotificationsPlugin.cancel(id);
  } catch (ex) {
    print(ex);
  }
  try {
    await flutterLocalNotificationsPlugin.cancel(id + 1000);
  } catch (ex) {
    print(ex);
  }
  try {
    await flutterLocalNotificationsPlugin.cancel(id + 2000);
  } catch (ex) {
    print(ex);
  }
  try {
    await flutterLocalNotificationsPlugin.cancel(id + 3000);
  } catch (ex) {
    print(ex);
  }
  try {
    await flutterLocalNotificationsPlugin.cancel(id + 4000);
  } catch (ex) {
    print(ex);
  }
  try {
    await flutterLocalNotificationsPlugin.cancel(id + 5000);
  } catch (ex) {
    print(ex);
  }

  // List<PendingNotificationRequest> p =
  //     await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  // print('Pending Notification: ${p.length}');
}
