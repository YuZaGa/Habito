import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:test/screens/add_taskbar.dart';
import 'package:test/screens/widgets/button.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/task.dart';

DateTime _selectedDate = DateTime.now();

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _appBar(),
          Divider(
            indent: 20,
            endIndent: 20,
            thickness: 3,
          ),
          _addTaskbar(),
          _addDateBar(),
          _showTask(),
        ],
      ),
    );
  }
}

_appBar() {
  return Container(
    padding: const EdgeInsets.only(top: 10, left: 20, right: 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${getGreeting()},',
                style: GoogleFonts.lato(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey),
              ),
              SizedBox(height: 2),
              Text(
                'Yumn Gauhar',
                style: GoogleFonts.lato(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            //Get.to(AddTaskPage());
          },
        ),
      ],
    ),
  );
}

String getGreeting() {
  var now = DateTime.now();
  var hour = now.hour;

  if (hour >= 5 && hour < 12) {
    return 'morning';
  } else if (hour >= 12 && hour < 17) {
    return 'afternoon';
  } else if (hour >= 17 && hour < 21) {
    return 'evening';
  } else {
    return 'hey';
  }
}

_addTaskbar() {
  return Container(
    margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              DateFormat.yMMMMd().format(DateTime.now()),
              style: subHeadingStyle,
            ),
            Text("Today", style: HeadingStyle)
          ]),
        ),
        MyButton(
          label: "+ Add Task",
          onTap: () => Get.toNamed('/add-task'),
        )
      ],
    ),
  );
}

_addDateBar() {
  return Container(
    margin: const EdgeInsets.only(top: 15, left: 15),
    child: DatePicker(
      DateTime.now(),
      height: 100,
      width: 80,
      initialSelectedDate: DateTime.now(),
      selectionColor: Color(0xFFFBEBCC),
      selectedTextColor: Colors.black,
      dateTextStyle: TextStyle(
          fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
      onDateChange: (date) {
        _selectedDate = date;
      },
    ),
  );
}

_showTask() {
  return Expanded(
    child: ValueListenableBuilder(
      valueListenable: Hive.box<Task>('tasks').listenable(),
      builder: (context, Box<Task> box, _) {
        List<Task> tasks = box.values.toList();
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            Task task = tasks[index];
            return Container(
              height: 150,
              decoration: BoxDecoration(
                color: Color(0xFFDDEDEC),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFFBEBCC),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              margin: const EdgeInsets.only(
                  top: 15, left: 18, right: 18, bottom: 0),
              padding: const EdgeInsets.only(right: 10),
              child: Slidable(
                endActionPane: ActionPane(
                  motion: const StretchMotion(),
                  children: [
                    // settings option
                    SlidableAction(
                      onPressed: null,
                      backgroundColor: Colors.grey.shade800,
                      icon: Icons.edit,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    SizedBox(width: 5),

                    // delete option
                    SlidableAction(
                      onPressed: (BuildContext context) {
                        box.delete(task.key);
                      },
                      backgroundColor: Colors.red.shade400,
                      icon: Icons.delete,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.note),
                ),
              ),
            );
          },
        );
      },
    ),
  );
}

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey));
}

TextStyle get HeadingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
  ));
}
