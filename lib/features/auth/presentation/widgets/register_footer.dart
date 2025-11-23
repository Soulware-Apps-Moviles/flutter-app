import 'package:flutter/material.dart';

class RegisterFooter extends StatelessWidget {
  final VoidCallback onTapRegister;

  const RegisterFooter({super.key, required this.onTapRegister});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account? ", style: TextStyle(color: Colors.grey[600])),
        GestureDetector(
          onTap: onTapRegister,
          child: const Text(
            'Register',
            style: TextStyle(color: Color(0xFFE56B26), fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}