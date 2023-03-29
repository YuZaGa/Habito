import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:test/screens/add_taskbar.dart';
import 'package:test/screens/widgets/button.dart';
import 'package:get/get.dart';

DateTime _selectedDate = DateTime.now();

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskbar(),
          _addDateBar(),
        ],
      ),
    );
  }
}

_appBar() {
  return AppBar(
    elevation: 0,
    title: Text('Dashboard'.toUpperCase()),
    backgroundColor: Colors.white,
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
      selectionColor: Color(0xFF4e5ae8),
      selectedTextColor: Colors.white,
      dateTextStyle: TextStyle(
          fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey),
      onDateChange: (date) {
        _selectedDate = date;
      },
    ),
  );
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
