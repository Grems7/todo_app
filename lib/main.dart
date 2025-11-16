import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_getx/views/login_view.dart';

import 'constant/color_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
      fontFamily: 'Poppins',
      scaffoldBackgroundColor: ColorApp().bgColor,
      colorScheme: ColorScheme.fromSeed(seedColor: ColorApp().primaryColor),
    )
    ,
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      home:  LoginView()
    );
  }
}
