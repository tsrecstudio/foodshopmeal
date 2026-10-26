import 'package:flutter/material.dart';

class DishScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;
  const DishScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe['title'] ?? 'Блюдо')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(recipe['title'] ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Время: ${recipe['time_min'] ?? 0} мин'),
                    Text('Порции: ${recipe['servings'] ?? 2}'),
                    const SizedBox(height: 8),
                    if (recipe['nutrition'] != null) ...[
                      Text('КБЖУ на порцию:'),
                      Text('Ккал: ${recipe['nutrition']['perServing']['kcal'] ?? 0}'),
                      Text('Б: ${recipe['nutrition']['perServing']['protein'] ?? 0} г'),
                      Text('Ж: ${recipe['nutrition']['perServing']['fat'] ?? 0} г'),
                      Text('У: ${recipe['nutrition']['perServing']['carb'] ?? 0} г'),
                    ],
                    const SizedBox(height: 8),
                    Text('Ингредиенты:'),
                    for (var ing in recipe['ingredients'] ?? [])
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text('${ing['ingredientName']} — ${ing['gramsRaw']} г'),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Шаги:'),
            for (var step in recipe['steps'] ?? [])
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Icon(Icons.timer, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(child: Text(step['text'] ?? '')),
                    if ((step['timerSec'] ?? 0) > 0)
                      Text('${step['timerSec']} сек', style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/basket'),
              child: const Text('Следующее блюдо →'),
            ),
          ],
        ),
      ),
    );
  }
}
