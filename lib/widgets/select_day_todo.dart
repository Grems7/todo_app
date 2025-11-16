import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../controller/todos_controller.dart';
import '../model/todos_model.dart';

class SelectDayTodo extends StatelessWidget {
  final Rx<DateTime> selectedDay;            // 👈 Date envoyée depuis HomeScreen
  final Function(BuildContext context, {TodosModel? todo}) showBottomSheet;

  SelectDayTodo({
    Key? key,
    required this.selectedDay,
    required this.showBottomSheet,
  }) : super(key: key);

  final TodosController todoController = Get.find<TodosController>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() {
        // Filtrage des todos du jour sélectionné
        final todos = todoController.todoList.where((t) {
          return t.date == DateFormat('yyyy-MM-dd').format(selectedDay.value);
        }).toList();

        if (todos.isEmpty) {
          return Center(
            child: Text(
              "No tasks for this day ✨",
              style: GoogleFonts.abel(fontSize: 18, color: Colors.grey.shade600),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final t = todos[index];

            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),

                // Toggle done / not done
                leading: IconButton(
                  icon: Icon(
                    t.isDone! ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: t.isDone! ? Colors.purple.shade700 : Colors.grey.shade400,
                    size: 28,
                  ),
                  onPressed: () => todoController.toggleTodoStatus(t),
                ),

                title: Text(
                  t.todoTitle ?? "",
                  style: GoogleFonts.abel(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    decoration: t.isDone! ? TextDecoration.lineThrough : null,
                  ),
                ),

                subtitle: Text(
                  "${t.todoMsg}\n${t.startTime ?? ''} - ${t.endTime ?? ''}",
                  style: GoogleFonts.abel(color: Colors.grey.shade700, height: 1.3),
                ),

                trailing: Column(
                  children: [
                    _categoryLabel(t.category),
                    Gap(10),
                    GestureDetector(
                      onTap:()=> todoController.deleteTodo(t.id),
                        child: Icon(CupertinoIcons.delete,color: Colors.red,size: 18,))
                  ],
                ),

                // Ouvrir le bottomsheet d'édition
                onTap: () => showBottomSheet(context, todo: t),
              ),
            );
          },
        );
      }),
    );
  }

  // Widget pour afficher la catégorie avec couleur
  Widget _categoryLabel(String? category) {
    final color = _getCategoryColor(category);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        category ?? "General",
        style: GoogleFonts.abel(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Couleurs des catégories
  Color _getCategoryColor(String? category) {
    switch (category) {
      case "Work":
        return Colors.orange;
      case "Personal":
        return Colors.blue;
      case "Health":
        return Colors.green;
      case "Study":
        return Colors.purple;
      case "Shopping":
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }
}
