import 'package:sqflite/sqflite.dart';
import 'reminder_model.dart';

final String tableReminder = 'reminder';
final String columnId = 'id';
final String columnTitle = 'title';
final String columnDateTime = 'reminderDateTime';

class ReminderHelper {
  static Database _database;
  static ReminderHelper _reminderHelper;

  ReminderHelper.createInstance();

  factory ReminderHelper() {
    if (_reminderHelper == null) {
      _reminderHelper = ReminderHelper.createInstance();
    }
    return _reminderHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = dir + "reminder.db";

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(''' 
            create table $tableReminder (
            $columnId integer primary key,
            $columnTitle text not null,
            $columnDateTime text not null)
          ''');
      },
    );

    return database;
  }

  Future<int> insertReminder(ReminderInfo reminderInfo) async {
    var db = await this.database;
    var result = await db.insert(tableReminder, reminderInfo.toMap());
    // print('Inserted with id = $result');
    return result;
  }

  Future<List<ReminderInfo>> getReminders() async {
    List<ReminderInfo> _reminders = [];

    var db = await this.database;
    var result = await db.query(tableReminder, orderBy: '$columnDateTime ASC');
    result.forEach((element) {
      var reminderInfo = ReminderInfo.fromMap(element);
      _reminders.add(reminderInfo);
    });
    return _reminders;
  }

  Future<int> delete(int id) async {
    var db = await this.database;
    return await db
        .delete(tableReminder, where: '$columnId = ?', whereArgs: [id]);
  }
}
