import 'package:flutter/material.dart';

void main() {
  runApp(const FoodShopMealApp());
}

/// Stage M0 application shell.
/// Full UX screens (0. Onboarding -> 9. Weekly Summary) are implemented in Stage M7.
class FoodShopMealApp extends StatelessWidget {
  const FoodShopMealApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodShopMeal',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF1F7A4C),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('FoodShopMeal — Stage M0 Skeleton (L1 Ready)'),
        ),
      ),
    );
  }
}
