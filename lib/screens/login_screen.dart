import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isNewUser = false;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    final auth = AuthService();

    try {
      if (_isNewUser) {
        await auth.signUp(_emailController.text.trim(), _passwordController.text.trim());
        _showMessage('Account created. You are now logged in.');
      } else {
        await auth.signIn(_emailController.text.trim(), _passwordController.text.trim());
      }
    } catch (e) {
      _showMessage('Authentication failed. Please check your credentials.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Warehouse Login')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : Text(_isNewUser ? 'Create Account' : 'Login'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => setState(() => _isNewUser = !_isNewUser),
              child: Text(_isNewUser ? 'Already have an account? Login' : 'New user? Create an account'),
            ),
          ],
        ),
      ),
    );
  }
}
