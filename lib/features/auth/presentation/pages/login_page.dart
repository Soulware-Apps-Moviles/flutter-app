import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/features/auth/presentation/blocs/login_bloc.dart';
import 'package:tcompro_customer/features/auth/presentation/blocs/login_event.dart';
import 'package:tcompro_customer/features/auth/presentation/blocs/login_state.dart';
import 'package:tcompro_customer/features/auth/presentation/widgets/email_input.dart';
import 'package:tcompro_customer/features/auth/presentation/widgets/login_button.dart';
import 'package:tcompro_customer/features/auth/presentation/widgets/login_header.dart';
import 'package:tcompro_customer/features/auth/presentation/widgets/password_input.dart';
import 'package:tcompro_customer/features/auth/presentation/widgets/register_footer.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<LoginBloc>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          switch (state.status) {
            case LoginStatus.failure:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message ?? 'Error de autenticación')),
              );
              break;
            case LoginStatus.success:
              // Navigate or something
              break;
            default:
              break;
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  // Header (Logo & Texts)
                  const LoginHeader(),
                  
                  const SizedBox(height: 32),

                  // Email Input
                  EmailInput(
                    onChanged: (value) => bloc.add(EmailChanged(email: value)),
                  ),
                  
                  const SizedBox(height: 16),

                  PasswordInput(
                    isVisible: context.watch<LoginBloc>().state.isPasswordVisible,
                    onChanged: (value) => bloc.add(PasswordChanged(password: value)),
                    onToggleVisibility: () => bloc.add(TogglePasswordVisibility()),
                  ),

                  const SizedBox(height: 24),

                  // Login Button
                  LoginButton(
                    status: context.watch<LoginBloc>().state.status,
                    onPressed: () => bloc.add(Login()),
                  ),

                  const SizedBox(height: 24),

                  // Footer
                  RegisterFooter(
                    onTapRegister: () {
                      debugPrint("Navigate to Register");
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}