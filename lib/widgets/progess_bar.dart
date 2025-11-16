
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/todos_controller.dart';

class ProgressBar extends StatelessWidget {
   ProgressBar({Key? key}) : super(key: key);
  final TodosController todoController = Get.put(TodosController(), permanent: true);
   final Rx<DateTime> _selectedDay = DateTime.now().obs;
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final progress = todoController.getDailyProgress(_selectedDay.value);
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.purple.shade100,
              color: Colors.purple.shade700,
            ),
            const SizedBox(height: 8),
            Text("${(progress * 100).toStringAsFixed(0)}% completed",
                style: GoogleFonts.abel(
                    fontSize: 16, color: Colors.grey.shade700)),
          ],
        ),
      );
    });
  }
}
