//IM-2021-092

import 'package:flutter/material.dart';
import 'calculator_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Returns the UI
    return MaterialApp(
      //provides the basic visual structure and functionality
      title: 'new_calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home:
          const CalculatorScreen(), //Main screen that contains the calculator logic
    );
  }
}
