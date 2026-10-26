import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  final Function(double kcal, double budget)? onComplete;
  const OnboardingScreen({super.key, this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  double kcal = 1800;
  double budget = 5000;
  bool agreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kuper — Онбординг')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            const Text(
              'Купер — руки, А мы — мозги',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Не думать о еде — но полностью её контролировать',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text('Дневная норма КБЖУ: ${kcal.toInt()} ккал'),
            Slider(
              value: kcal,
              min: 1200,
              max: 3000,
              divisions: 18,
              onChanged: (v) => setState(() => kcal = v),
            ),
            const SizedBox(height: 16),
            Text('Бюджет на неделю: ${budget.toInt()} ₽'),
            Slider(
              value: budget,
              min: 2000,
              max: 20000,
              divisions: 18,
              onChanged: (v) => setState(() => budget = v),
            ),
            const SizedBox(height: 24),
            CheckboxListTile(
              title: const Text('Согласие на обработку персональных данных (152-ФЗ)'),
              value: agreed,
              onChanged: (v) => setState(() => agreed = v ?? false),
            ),
            CheckboxListTile(
              title: const Text('Получить демоплан на первую неделю'),
              value: true,
              onChanged: (_) {},
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: agreed ? () => widget.onComplete?.call(kcal, budget) : null,
              child: const Text('Начать'),
            ),
          ],
        ),
      ),
    );
  }
}
