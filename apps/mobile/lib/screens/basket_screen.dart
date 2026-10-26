import 'package:flutter/material.dart';

class BasketScreen extends StatelessWidget {
  final List<Map<String, dynamic>> basket;
  const BasketScreen({super.key, required this.basket});

  @override
  Widget build(BuildContext context) {
    final total = basket.fold(0.0, (sum, item) => sum + (item['price'] ?? 0));
    return Scaffold(
      appBar: AppBar(title: const Text('Корзина')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: basket.length,
              itemBuilder: (context, index) {
                final item = basket[index];
                return Card(
                  child: ListTile(
                    title: Text(item['name'] ?? ''),
                    subtitle: Text('${item['packs_qty']} шт · ${item['used_grams']} г'),
                    trailing: Column(
                      children: [
                        Text('${item['price']} ₽', style: const TextStyle(fontWeight: FontWeight.bold)),
                        if (item['leftover_grams'] != null && (item['leftover_grams'] as double) > 0)
                          Text('Остаток: ${item['leftover_grams']} г', style: const TextStyle(color: Colors.orange)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: Text('Итого: ${total.toInt()} ₽')),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/checkout'),
                  child: const Text('Перейти к оплате'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
