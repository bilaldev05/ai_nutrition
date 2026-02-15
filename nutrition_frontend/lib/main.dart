import 'package:flutter/material.dart';
import 'screens/home_screen.dart';


void main() {
runApp(const NutritionAIApp());
}


class NutritionAIApp extends StatelessWidget {
const NutritionAIApp({super.key});


@override
Widget build(BuildContext context) {
return MaterialApp(
debugShowCheckedModeBanner: false,
title: 'Nutrition AI',
theme: ThemeData(
primarySwatch: Colors.green,
scaffoldBackgroundColor: Colors.white,
),
home: const HomeScreen(),
);
}
}