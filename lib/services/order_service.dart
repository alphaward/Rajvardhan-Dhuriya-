import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import '../models/order.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<WarehouseOrder>> watchOrdersByUser(String userEmail) {
    return _firestore
        .collection('orders')
        .where('createdBy', isEqualTo: userEmail)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => WarehouseOrder.fromFirestore(doc)).toList());
  }

  Stream<List<WarehouseOrder>> watchAllOrders() {
    return _firestore
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => WarehouseOrder.fromFirestore(doc)).toList());
  }

  Future<void> placeOrder({
    required String itemName,
    required int quantity,
    required String customerName,
    required String createdBy,
  }) async {
    await _firestore.collection('orders').add({
      'itemName': itemName,
      'quantity': quantity,
      'customerName': customerName,
      'status': 'Pending',
      'createdBy': createdBy,
      'createdAt': Timestamp.now(),
    });
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    await _firestore.collection('orders').doc(orderId).update({'status': newStatus});
  }

  Future<String> exportOrdersToExcel() async {
    final snapshot = await _firestore.collection('orders').orderBy('createdAt', descending: true).get();
    final excel = Excel.createExcel();
    final sheet = excel['Orders'];
    sheet.appendRow(['Order ID', 'Customer', 'Item', 'Quantity', 'Status', 'Created By', 'Created At']);

    for (final doc in snapshot.docs) {
      final order = WarehouseOrder.fromFirestore(doc);
      sheet.appendRow([
        order.id,
        order.customerName,
        order.itemName,
        order.quantity,
        order.status,
        order.createdBy,
        order.createdAt.toIso8601String(),
      ]);
    }

    final bytes = excel.encode();
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/warehouse_orders_export.xlsx');
    await file.writeAsBytes(bytes ?? []);
    return file.path;
  }
}
