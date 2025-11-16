import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({Key? key,
    required this.text,
    this.color,
    this.weight,
    this.size}) : super(key: key);
  final String text;
  final Color? color;
  final FontWeight? weight;
  final double? size;
  @override
  Widget build(BuildContext context) {
    return Text(text,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: size,
          color: color,
          fontWeight: weight
      ),);
  }
}
