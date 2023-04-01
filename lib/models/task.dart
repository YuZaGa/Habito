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

  @HiveField(10)
  late List<String> completedDates = [];

  @HiveField(11)
  late int streakCount = 0;

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
    this.streakCount = 0,
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
        streakCount: json['streakCount'] ?? 0,
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
        'streakCount': streakCount,
      };

  void nameUpdated() {
    Box<Task> sourceBox = Hive.box<Task>('user_data');
    Box<Task> destinationBox = Hive.box<Task>('tasks');

    for (var i = 0; i < sourceBox.length; i++) {
      Task task = sourceBox.getAt(i)!;
      destinationBox.add(task);
    }
  }

  void updateStreakCount(List<CompletedDate> completedDates) {
    // Get today's date
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Sort the completed dates in ascending order
    completedDates.sort((a, b) => a.date.compareTo(b.date));

    // Find the index of the last completed date that is before today
    int lastIndex = -1;
    for (int i = completedDates.length - 1; i >= 0; i--) {
      final completedDate = DateTime.parse(completedDates[i].date);
      if (completedDate.isBefore(today)) {
        lastIndex = i;
        break;
      }
    }

    // Update the streak count based on the last completed date
    if (lastIndex == -1) {
      // No completed dates before today, so streak is broken
      streakCount = 0;
    } else {
      // Calculate the number of consecutive days since the last completed date
      final lastCompletedDate = DateTime.parse(completedDates[lastIndex].date);
      final diff = today.difference(lastCompletedDate);
      final daysSinceLastCompleted = diff.inDays - 1;

      // Update the streak count based on the number of consecutive days
      if (daysSinceLastCompleted == 0) {
        // Last completed date is today, so streak continues
        streakCount++;
      } else if (daysSinceLastCompleted == 1) {
        // Last completed date was yesterday, so streak continues
        streakCount++;
      } else {
        // Last completed date was more than one day ago, so streak is broken
        streakCount = 0;
      }
    }
  }
}

@HiveType(typeId: 2)
class CompletedDate extends HiveObject {
  @HiveField(0)
  late int taskId;

  @HiveField(1)
  late String date;
}
