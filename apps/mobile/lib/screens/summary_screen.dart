import 'package:flutter/material.dart';

class SummaryScreen extends StatelessWidget {
  final Map<String, dynamic> summary;
  const SummaryScreen({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Итоги недели')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('КБЖУ по факту:'),
                    Text('Ккал: ${summary['kcal'] ?? 0}'),
                    Text('Б: ${summary['protein'] ?? 0} г'),
                    Text('Ж: ${summary['fat'] ?? 0} г'),
                    Text('У: ${summary['carb'] ?? 0} г'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                title: const Text('Остаток от закупок'),
                subtitle: Text('${summary['leftover_pct'] ?? 0}% — целевое < 15%'),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                title: const Text('Расхождение план/факт'),
                subtitle: Text('${summary['deviation_pct'] ?? 0}% — целевое < 7%'),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Сформировать следующий план'),
            ),
          ],
        ),
      ),
    );
  }
}
