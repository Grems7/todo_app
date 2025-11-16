
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class  TableCalender extends StatelessWidget {
  TableCalender({Key? key}) : super(key: key);
  final Rx<DateTime> _selectedDay = DateTime.now().obs;
  @override
  Widget build(BuildContext context) {
    return Obx(() => TableCalendar(
      focusedDay: _selectedDay.value,
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      calendarFormat: CalendarFormat.month,
      startingDayOfWeek: StartingDayOfWeek.monday,
      selectedDayPredicate: (day) => isSameDay(day, _selectedDay.value),
      onDaySelected: (selected, _) => _selectedDay.value = selected,
      headerVisible: false,
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
            color: Colors.purple.shade100, shape: BoxShape.circle),
        selectedDecoration: BoxDecoration(
            color: Colors.purple.shade700, shape: BoxShape.circle),
      ),
    ));
  }
}
