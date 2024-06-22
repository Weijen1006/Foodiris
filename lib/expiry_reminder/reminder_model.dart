class ReminderInfo {
  ReminderInfo({
    this.id,
    this.title,
    this.reminderDate,
  });

  int id;
  String title;
  DateTime reminderDate;

  factory ReminderInfo.fromMap(Map<String, dynamic> json) => ReminderInfo(
        id: json["id"],
        title: json["title"],
        reminderDate: DateTime.parse(json["reminderDateTime"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "reminderDateTime": reminderDate.toIso8601String(),
      };
}
