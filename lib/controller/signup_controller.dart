import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../database/auth_repo.dart';
import '../views/login_view.dart';

class SignUpController extends GetxController{
  final AuthRepo _authRepo = AuthRepo();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmController = TextEditingController();


// Variable image
  var image = Rx<File?>(null);

  // ✅ Méthode pour choisir une image
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      image.value = File(picked.path);
    }
  }
  Future<void> register() async {
    try {
      final success = await _authRepo.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passController.text.trim(),
        imagePath: image.value?.path, // ✅ correctement nommé
      );

      print(image.value?.path);
      Get.to(LoginView());// tu peux afficher le chemin ici
    } catch (e) {
      print("❌ Exception register: $e");
    }
  }

}




