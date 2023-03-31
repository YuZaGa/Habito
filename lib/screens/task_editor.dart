import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:test/screens/home.dart';
import 'package:test/screens/widgets/button.dart';
import 'package:test/screens/widgets/input_field.dart';
import '../db/db_helper.dart';
import '../models/task.dart';
import 'package:get/get.dart';

class EditTaskScreen extends StatefulWidget {
  final int taskId;

  EditTaskScreen(Task task, {required this.taskId});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _noteController;
  late bool _completed;
  late String _endTime;
  late String _startTime;
  late String _selectedDate;
  late int _selectedRemind;
  late String _selectedRepeat;
  late List<String> _completedDates = [];

  List<int> remindList = [5, 10, 15, 20, 30];
  List<String> repeatList = ["None", "Daily", "Weekly", "Monthly"];

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
      _noteController = TextEditingController(text: task.note);
      _selectedDate = task.date;
      _startTime = task.startTime;
      _endTime = task.endTime;
      _completed = task.isCompleted;
      _selectedRemind = task.remind;
      _selectedRepeat = task.repeat;
      _completedDates = task.completedDates;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final taskBox = Hive.box<Task>('tasks');
    final task = taskBox.get(widget.taskId);

    if (task != null) {
      task.title = _titleController.text;
      task.note = _noteController.text;
      task.isCompleted = _completed;
      task.date = _selectedDate;
      task.startTime = _startTime;
      task.endTime = _endTime;
      task.remind = _selectedRemind;
      task.repeat = _selectedRepeat;
      task.completedDates = _completedDates;

      task.save();
      Navigator.pop(context);
    }
  }

  _getDateFromUser(context) async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2030));

    if (_pickerDate != null) {
      setState(() {
        _selectedDate = DateFormat('dd/MM/yyyy').format(_pickerDate);
      });
    } else {}
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var _pickedTime = await _showTimePicker();
    String formattedTime = _pickedTime.format(context);
    if (_pickedTime == null) {
    } else if (isStartTime == true) {
      setState(() {
        _startTime = formattedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = formattedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
            hour: int.parse(_startTime.split(":")[0]),
            minute: int.parse(_startTime.split(":")[1].split(" ")[0])));
  }

  _appBar() {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Get.toNamed('/'),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _appBar(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Edit Habit",
                    style: HeadingStyle,
                  ),
                  Checkbox(
                      value: _completed,
                      activeColor: Colors.black,
                      onChanged: (value) {
                        setState(() {
                          if (_completed == false) {
                            _completed = value!;
                            //Task.updateStreakCount(_completedDates);
                            _completedDates.add(DateFormat('yyyy-MM-dd')
                                .format(DateTime.now())
                                .toString());
                          } else if (_completed == true) {
                            _completed = value!;
                            _completedDates.removeWhere(
                                (date) => date == DateTime.now().toString());
                          }
                        });
                      })
                ],
              ),
              MyInputField(
                title: "Title",
                hint: "Enter Your Title",
                controller: _titleController,
              ),
              MyInputField(
                title: "Note",
                hint: "Enter Your Note",
                controller: _noteController,
              ),
              MyInputField(
                  title: "Date",
                  hint: _selectedDate,
                  widget: IconButton(
                      onPressed: () => _getDateFromUser(context),
                      icon: Icon(Icons.calendar_today_outlined))),
              Row(
                children: [
                  Expanded(
                    child: MyInputField(
                      title: "Start Time",
                      hint: _startTime,
                      widget: IconButton(
                          onPressed: () => _getTimeFromUser(isStartTime: true),
                          icon: Icon(Icons.access_time_rounded)),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: MyInputField(
                      title: "End Time",
                      hint: _endTime,
                      widget: IconButton(
                          onPressed: () => _getTimeFromUser(isStartTime: false),
                          icon: Icon(Icons.access_time_rounded)),
                    ),
                  )
                ],
              ),
              MyInputField(
                title: "Remind",
                hint: "$_selectedRemind minutes early",
                widget: DropdownButton(
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  items: remindList.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                      child: Text(value.toString()),
                      value: value.toString(),
                    );
                  }).toList(),
                  underline: Container(
                    height: 0,
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedRemind = int.parse(value!);
                    });
                  },
                ),
              ),
              MyInputField(
                title: "Repeat",
                hint: _selectedRepeat,
                widget: DropdownButton(
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  items:
                      repeatList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      child: Text(value.toString()),
                      value: value.toString(),
                    );
                  }).toList(),
                  underline: Container(
                    height: 0,
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedRepeat = value!;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyButton(label: "Save Changes", onTap: () => _saveChanges()),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
            ],
          )),
        ),
      ),
    );
  }

  validateDate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _saveChanges();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar("Required", "Please fill all the fields",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color.fromARGB(255, 246, 222, 221),
          icon: Icon(Icons.warning_amber_rounded));
    }
  }
}
