import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Оплата и доставка')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Card(child: ListTile(title: Text('Адрес доставки'), subtitle: Text('Выберите адрес из профиля'))),
            const SizedBox(height: 8),
            const Card(child: ListTile(title: Text('Время доставки (слот)'), subtitle: Text('Выберите слот'))),
            const SizedBox(height: 8),
            const Card(child: ListTile(title: Text('Способ оплаты'), subtitle: Text('Оплата картой (152-ФЗ: карты не хранятся)'))),
            const SizedBox(height: 16),
            const Text('ПРЕДУПРЕЖДЕНИЕ: Данный сервис не является медицинским. При беременности, диабете или расстройствах пищевого поведения обратитесь к врачу.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/reconciliation'),
              child: const Text('Оформить заказ'),
            ),
          ],
        ),
      ),
    );
  }
}
