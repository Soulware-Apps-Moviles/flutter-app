import 'package:flutter/material.dart';
import 'package:tcompro_customer/features/auth/presentation/blocs/login_state.dart';

class LoginButton extends StatelessWidget {
  final LoginStatus status;
  final VoidCallback onPressed;

  const LoginButton({super.key, required this.status, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isLoading = status == LoginStatus.loading;
    
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE56B26),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}