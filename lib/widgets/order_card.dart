import 'package:flutter/material.dart';
import '../models/order.dart';

class OrderCard extends StatelessWidget {
  final WarehouseOrder order;
  final VoidCallback? onStatusTap;

  const OrderCard({super.key, required this.order, this.onStatusTap});

  @override
  Widget build(BuildContext context) {
    final statusColor = order.status == 'Dispatched' ? Colors.green : Colors.orange;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(order.itemName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: onStatusTap,
                  child: Chip(
                    backgroundColor: statusColor.withOpacity(0.2),
                    label: Text(order.status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Customer: ${order.customerName}'),
            Text('Quantity: ${order.quantity}'),
            Text('Created by: ${order.createdBy}'),
            const SizedBox(height: 8),
            Text('Placed: ${order.createdAt.toLocal()}'),
          ],
        ),
      ),
    );
  }
}
