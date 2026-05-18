import 'package:cloud_firestore/cloud_firestore.dart';

class WarehouseOrder {
  final String id;
  final String customerName;
  final String itemName;
  final int quantity;
  final String status;
  final String createdBy;
  final DateTime createdAt;

  WarehouseOrder({
    required this.id,
    required this.customerName,
    required this.itemName,
    required this.quantity,
    required this.status,
    required this.createdBy,
    required this.createdAt,
  });

  factory WarehouseOrder.fromFirestore(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return WarehouseOrder(
      id: snapshot.id,
      customerName: data['customerName'] as String? ?? '',
      itemName: data['itemName'] as String? ?? '',
      quantity: data['quantity'] as int? ?? 0,
      status: data['status'] as String? ?? 'Pending',
      createdBy: data['createdBy'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'customerName': customerName,
      'itemName': itemName,
      'quantity': quantity,
      'status': status,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
