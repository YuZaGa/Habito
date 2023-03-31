import 'package:get/get.dart';
import 'package:test/db/db_helper.dart';

import '../models/task.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }

  Future<int> addTask({Task? task}) async {
    return await HiveHelper.insert(task!);
  }

  Future<List<Task>> getTasks() async {
    return await HiveHelper.getAllTasks();
  }
}
