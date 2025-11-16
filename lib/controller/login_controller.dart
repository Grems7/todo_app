import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_getx/controller/todos_controller.dart';
import 'package:todo_getx/database/auth_repo.dart';
import 'package:todo_getx/network/api_error.dart';
import 'package:todo_getx/views/home_screen.dart';

class LoginController extends GetxController {
  final AuthRepo _authRepo = AuthRepo();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var isLoading = false.obs;

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final success = await _authRepo.login(
        emailController.text.trim(),
        passController.text.trim(),
      );

      isLoading.value = false;

      if (success != null) {
        // ✅ Connexion réussie → redirection
        final todosController = Get.put(TodosController(), permanent: true);
        await todosController.fetchTodosForUser();
        // recharge les todos
        Get.offAll(() => HomeScreen()); // navigue vers la HomeScreen
      } else {
        Get.snackbar(
          "Erreur",
          "Identifiants invalides ou erreur serveur.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.2),
        );
      }
    } catch (e) {
      isLoading.value = false;

      String message = "Erreur inattendue lors de la connexion.";
      if (e is ApiError) message = e.message;

      Get.snackbar(
        "Erreur",
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.2),
      );
    }
  }
}
