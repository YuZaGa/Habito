import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';

class EditTaskScreen extends StatefulWidget {
  final int taskId;

  EditTaskScreen(Task task, {required this.taskId});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late bool _completed;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() async {
    final taskBox = Hive.box<Task>('tasks');
    final task = taskBox.get(widget.taskId);

    if (task != null) {
      _titleController = TextEditingController(text: task.title);
      _descriptionController = TextEditingController(text: task.note);
      _completed = task.isCompleted;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final taskBox = Hive.box<Task>('tasks');
    final task = taskBox.get(widget.taskId);

    if (task != null) {
      task.title = _titleController.text;
      task.note = _descriptionController.text;
      task.isCompleted = _completed;

      task.save();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              CheckboxListTile(
                title: Text('Completed'),
                value: _completed,
                onChanged: (value) {
                  setState(() {
                    _completed = value!;
                  });
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveChanges,
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
