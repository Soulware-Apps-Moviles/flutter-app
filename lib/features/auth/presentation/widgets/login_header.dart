import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/icon/app_icon.png',
          height: 100,
          errorBuilder: (_, _, _) => const Icon(Icons.pets, size: 80, color: Color(0xFFE56B26)),
        ),
        const SizedBox(height: 24),
        const Text(
          'Welcome Back',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        const Text(
          'Login to your account',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }
}