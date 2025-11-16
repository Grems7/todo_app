
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';
import '../controller/todos_controller.dart';
import '../model/todos_model.dart';

void showAddEditTodoBottomSheet(BuildContext context, TodosController todoController, {TodosModel? todo}) {
  final titleController = TextEditingController(text: todo?.todoTitle ?? '');
  final msgController = TextEditingController(text: todo?.todoMsg ?? '');
  final RxString selectedCategory = (todo?.category ?? "General").obs;

  final Rx<DateTime> selectedDate = (todo?.date != null)
      ? DateTime.parse(todo!.date!).obs
      : DateTime.now().obs;

  final Rx<TimeOfDay?> startTime = (() {
    try {
      if (todo?.startTime != null && todo!.startTime!.contains(':')) {
        final parts = todo.startTime!.split(':');
        return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1])).obs;
      }
    } catch (_) {}
    return TimeOfDay.now().obs;
  })();

  final Rx<TimeOfDay?> endTime = (() {
    try {
      if (todo?.endTime != null && todo!.endTime!.contains(':')) {
        final parts = todo.endTime!.split(':');
        return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1])).obs;
      }
    } catch (_) {}
    return TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 1).obs;
  })();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (_) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 25,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
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
            const Gap(20),
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
            const Gap(10),
            TextField(
              controller: msgController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Description",
                prefixIcon: const Icon(Icons.description, color: Colors.purple),
                filled: true,
                fillColor: Colors.purple.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const Gap(20),
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
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.purple),
                    const SizedBox(width: 10),
                    Text(
                      DateFormat('EEE, dd MMM yyyy').format(selectedDate.value),
                      style: GoogleFonts.abel(fontSize: 16),
                    ),
                  ],
                ),
              ),
            )),
            const Gap(15),
            // ... (les time pickers et bouton Save comme avant)
          ],
        ),
      ),
    ),
  );
}
