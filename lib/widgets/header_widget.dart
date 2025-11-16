
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/user_controller.dart';

class HeaderView extends StatelessWidget {
   HeaderView({Key? key}) : super(key: key);
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Nom utilisateur
          Obx(() {
            final name = userController.userName.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome 👋",
                    style: GoogleFonts.abel(color: Colors.black87, fontSize: 18)),
                Text(
                  name.isEmpty ? "Loading..." : name,
                  style: GoogleFonts.abel(
                      color: Colors.black87,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
              ],
            );
          }),
          // Avatar utilisateur
          Obx(() {
            final imageUrl = userController.userImage.value;
            return CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                imageUrl.startsWith('http')
                    ? imageUrl
                    : 'http://localhost:8000$imageUrl',
              ),
            );
          }),
        ],
      ),
    );
  }
}
