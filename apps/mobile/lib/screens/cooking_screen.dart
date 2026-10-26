import 'package:flutter/material.dart';

class CookingScreen extends StatefulWidget {
  final Map<String, dynamic> recipe;
  const CookingScreen({super.key, required this.recipe});

  @override
  State<CookingScreen> createState() => _CookingScreenState();
}

class _CookingScreenState extends State<CookingScreen> {
  int currentStep = 0;
  int? timerSec;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.recipe['title'] ?? 'Готовка')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (timerSec != null) ...[
                    Text(' timers: ${timerSec} сек', style: const TextStyle(fontSize: 48)),
                    ElevatedButton(
                      onPressed: () => setState(() => timerSec = 0),
                      child: const Text('Стоп'),
                    ),
                  ] else
                    Text(widget.recipe['steps']?[currentStep]?['text'] ?? 'Готово!'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final stepTimer = widget.recipe['steps']?[currentStep]?['timerSec'] ?? 0;
                      if (stepTimer > 0) {
                        setState(() => timerSec = stepTimer);
                      } else {
                        setState(() => currentStep++);
                      }
                    },
                    child: const Text('Следующий шаг'),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: List.generate(
              widget.recipe['steps']?.length ?? 0,
              (i) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: i <= currentStep ? Colors.green : Colors.grey,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
