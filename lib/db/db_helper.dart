import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../models/task.dart';

class HiveHelper {
  static Future<Box<Task>> _getBox() async {
    final appDocumentDir =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TaskAdapter());
    }

    return await Hive.openBox<Task>('tasks');
  }

  static Future<int> insert(Task task) async {
    final box = await _getBox();
    return await box.add(task);
  }

  static Future<List<Task>> getAllTasks() async {
    final box = await _getBox();
    return box.values.toList();
  }
}
