import 'package:flutter/material.dart';

class DiaryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> entries;
  const DiaryScreen({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Дневник питания')),
      body: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final e = entries[index];
          return Card(
            child: ListTile(
              title: Text(e['date'] ?? ''),
              subtitle: Text('${e['meal']} — ${e['kcal']} ккал'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {},
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
