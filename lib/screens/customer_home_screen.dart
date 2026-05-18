import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/auth_service.dart';
import '../services/order_service.dart';
import '../widgets/order_card.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  final _nameController = TextEditingController();
  final _customerIdController = TextEditingController();
  final _quantityController = TextEditingController();
  final _service = OrderService();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  final List<String> _products = ['Widget Pro', 'Gadget Max', 'Box Standard', 'Custom Item'];
  String? _selectedProduct;

  User? get _user => FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    final user = _user;
    _nameController.text = user?.displayName ?? user?.email?.split('@').first ?? '';
    _customerIdController.text = user?.uid ?? user?.email ?? '';
    _selectedProduct = _products.first;
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final itemName = _selectedProduct ?? '';
    final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;

    setState(() => _isSubmitting = true);
    try {
      await _service.placeOrder(
        itemName: itemName,
        quantity: quantity,
        customerName: _nameController.text.trim(),
        createdBy: _user?.uid ?? _customerIdController.text.trim(),
      );

      _quantityController.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order placed successfully.')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to place order.')));
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Order'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().signOut();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Customer Details', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Customer name'),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter customer name' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _customerIdController,
                        readOnly: true,
                        decoration: const InputDecoration(labelText: 'Customer ID (read-only)'),
                      ),
                      const SizedBox(height: 16),
                      Text('Order', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedProduct,
                        items: _products.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                        onChanged: (v) => setState(() => _selectedProduct = v),
                        decoration: const InputDecoration(labelText: 'Product'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Quantity'),
                        validator: (v) {
                          final q = int.tryParse(v ?? '0') ?? 0;
                          if (q <= 0) return 'Enter a valid quantity';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _placeOrder,
                          child: _isSubmitting ? const CircularProgressIndicator(color: Colors.white) : const Text('Submit Order'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Previous Orders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<List<WarehouseOrder>>(
                stream: _service.watchOrdersByUser(_user?.uid ?? ''),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final orders = snapshot.data ?? [];
                  if (orders.isEmpty) {
                    return const Center(child: Text('No orders yet.'));
                  }
                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) => OrderCard(order: orders[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
