import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BtnAddAction extends StatelessWidget {
  final VoidCallback onPressed; // 👈 callback

  const BtnAddAction({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: Colors.purple.shade700,
      onPressed: onPressed, // 👈 on appelle la fonction passée ici
      icon: const Icon(Icons.add, color: Colors.white),
      label: Text(
        "Add Task",
        style: GoogleFonts.abel(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
