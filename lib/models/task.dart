import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  late int? id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String note;

  @HiveField(3)
  late bool isCompleted;

  @HiveField(4)
  late String date;

  @HiveField(5)
  late String startTime;

  @HiveField(6)
  late String endTime;

  @HiveField(7)
  late int color;

  @HiveField(8)
  late int remind;

  @HiveField(9)
  late String repeat;

  Task({
    this.id,
    required this.title,
    required this.note,
    required this.isCompleted,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.color,
    required this.remind,
    required this.repeat,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'] as int?,
        title: json['title'],
        note: json['note'],
        isCompleted: json['isCompleted'],
        date: json['date'],
        startTime: json['startTime'],
        endTime: json['endTime'],
        color: json['Color'],
        remind: json['remind'],
        repeat: json['repeat'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'note': note,
        'isCompleted': isCompleted,
        'date': date,
        'startTime': startTime,
        'endTime': endTime,
        'Color': color,
        'remind': remind,
        'repeat': repeat,
      };
}
