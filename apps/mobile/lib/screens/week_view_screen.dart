import 'package:flutter/material.dart';

class WeekViewScreen extends StatelessWidget {
  final List<Map<String, dynamic>> weekDays;
  const WeekViewScreen({super.key, required this.weekDays});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Неделя')),
      body: ListView.builder(
        itemCount: weekDays.length,
        itemBuilder: (context, index) {
          final day = weekDays[index];
          return Card(
            child: ListTile(
              title: Text(day['day'] ?? 'День $index'),
              subtitle: Text(day['plan'] ?? 'План не сформирован'),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () => Navigator.pushNamed(context, '/dish'),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Неделя'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Корзина'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Оплата'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Готовка'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: 'Дневник'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Лавка'),
          BottomNavigationBarItem(icon: Icon(Icons.insights), label: 'Итоги'),
        ],
        currentIndex: 0,
      ),
    );
  }
}
