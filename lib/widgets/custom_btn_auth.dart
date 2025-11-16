import 'package:flutter/material.dart';
import 'custom_text.dart';

class CustomAuthBtn extends StatelessWidget {
  CustomAuthBtn({Key? key, required this.txt, this.ontap}) ;
  final String txt;

  final Function()? ontap;
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap:ontap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
            color: Colors.purple,
            borderRadius: BorderRadius.circular(10)
        ),
        width: 320,
        child: Center(
          child: CustomText(
            text: txt,
            color:  Colors.white,
            size: 15,
            weight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
