import 'package:flutter/material.dart';

class PantryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  const PantryScreen({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Лавка')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            child: ListTile(
              title: Text(item['ingredient_name'] ?? ''),
              subtitle: Text('${item['grams']} г · до ${item['expires_at'] ?? '—'}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
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
