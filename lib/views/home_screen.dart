import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_getx/widgets/header_widget.dart';
import 'package:todo_getx/widgets/progess_bar.dart';
import 'package:todo_getx/widgets/select_day_todo.dart';
import '../controller/todos_controller.dart';
import '../model/todos_model.dart';
import '../widgets/floating_action_add.dart';
import '../widgets/show_btn_sheet.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final TodosController todoController = Get.put(TodosController(), permanent: true);

  final Rx<DateTime> _selectedDay = DateTime.now().obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ===== HEADER =====
            HeaderView(),

            // ===== PROGRESS BAR =====
            ProgressBar(),

            const SizedBox(height: 10),

            // ===== CALENDAR =====
            Obx(() => TableCalendar(
              focusedDay: _selectedDay.value,
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              calendarFormat: CalendarFormat.week,
              startingDayOfWeek: StartingDayOfWeek.monday,
              selectedDayPredicate: (day) =>
                  isSameDay(day, _selectedDay.value),
              onDaySelected: (selectedDay, focusedDay) {
                _selectedDay.value = selectedDay;
              },
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            )),

            const SizedBox(height: 10),

            // ===== LISTE DES TODOS DU JOUR =====
            SelectDayTodo(
              selectedDay: _selectedDay,
              showBottomSheet: (context, {TodosModel? todo}) =>
                  _showAddEditTodoBottomSheet(
                    context: context,
                    todo: todo,
                  ),
            ),
          ],
        ),
      ),

      // ===== BOUTON FLOTTANT =====
      floatingActionButton: BtnAddAction(
        onPressed: () => _showAddEditTodoBottomSheet(
          context: context,
        ),
      ),
    );
  }

  // === ADD / EDIT BOTTOM SHEET ===
  void _showAddEditTodoBottomSheet({
    required BuildContext context,
    TodosModel? todo,
  }) {
    final titleController = TextEditingController(text: todo?.todoTitle ?? '');
    final msgController = TextEditingController(text: todo?.todoMsg ?? '');

    final Rx<DateTime> selectedDate = (todo?.date != null)
        ? DateTime.parse(todo!.date!).obs
        : DateTime.now().obs;

    final Rx<TimeOfDay?> startTime = (() {
      try {
        if (todo?.startTime != null && todo!.startTime!.contains(':')) {
          final parts = todo.startTime!.split(':');
          return TimeOfDay(
            hour: int.parse(parts[0]),
            minute: int.parse(parts[1]),
          ).obs;
        }
      } catch (_) {}
      return TimeOfDay.now().obs;
    })();

    final Rx<TimeOfDay?> endTime = (() {
      try {
        if (todo?.endTime != null && todo!.endTime!.contains(':')) {
          final parts = todo.endTime!.split(':');
          return TimeOfDay(
            hour: int.parse(parts[0]),
            minute: int.parse(parts[1]),
          ).obs;
        }
      } catch (_) {}
      return TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 1).obs;
    })();

    final RxString selectedCategory = (todo?.category ?? "General").obs;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 25,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  Center(
                    child: Text(
                      todo == null ? "📝 Add New Task" : "✏️ Edit Task",
                      style: GoogleFonts.abel(
                        color: Colors.purple.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // === TITLE ===
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: "Title",
                      prefixIcon: const Icon(Icons.title, color: Colors.purple),
                      filled: true,
                      fillColor: Colors.purple.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // === DESCRIPTION ===
                  TextField(
                    controller: msgController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Description",
                      prefixIcon: const Icon(Icons.description,
                          color: Colors.purple),
                      filled: true,
                      fillColor: Colors.purple.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // === DATE PICKER ===
                  Obx(() => GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate.value,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) selectedDate.value = picked;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              color: Colors.purple),
                          const SizedBox(width: 10),
                          Text(
                            DateFormat('EEE, dd MMM yyyy')
                                .format(selectedDate.value),
                            style: GoogleFonts.abel(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  )),

                  const SizedBox(height: 15),

                  // === TIME PICKERS ===
                  Row(
                    children: [
                      Expanded(
                        child: Obx(() => GestureDetector(
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime:
                              startTime.value ?? TimeOfDay.now(),
                            );
                            if (picked != null) startTime.value = picked;
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade50,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(Icons.access_time,
                                    color: Colors.purple),
                                Text(
                                  startTime.value != null
                                      ? startTime.value!.format(context)
                                      : "--:--",
                                  style: GoogleFonts.abel(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        )),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Obx(() => GestureDetector(
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: endTime.value ?? TimeOfDay.now(),
                            );
                            if (picked != null) endTime.value = picked;
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade50,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(Icons.timelapse,
                                    color: Colors.purple),
                                Text(
                                  endTime.value != null
                                      ? endTime.value!.format(context)
                                      : "--:--",
                                  style: GoogleFonts.abel(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        )),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // === SAVE BUTTON ===
                  ElevatedButton.icon(
                    onPressed: () async {
                      final dateStr =
                      DateFormat('yyyy-MM-dd').format(selectedDate.value);

                      final sTime = startTime.value?.format(context) ?? "";
                      final eTime = endTime.value?.format(context) ?? "";

                      if (todo == null) {
                        await todoController.addTodo(TodosModel(
                          todoTitle: titleController.text.trim(),
                          todoMsg: msgController.text.trim(),
                          category: selectedCategory.value,
                          date: dateStr,
                          startTime: sTime,
                          endTime: eTime,
                        ));
                      } else {
                        await todoController.updateTodo(TodosModel(
                          id: todo.id,
                          todoTitle: titleController.text.trim(),
                          todoMsg: msgController.text.trim(),
                          category: selectedCategory.value,
                          date: dateStr,
                          startTime: sTime,
                          endTime: eTime,
                          isDone: todo.isDone,
                          userId: todo.userId,
                        ));
                      }

                      Get.back();
                    },
                    icon: const Icon(Icons.check, color: Colors.white),
                    label: Text(
                      todo == null ? "Save Task" : "Update Task",
                      style: GoogleFonts.abel(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple.shade700,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
