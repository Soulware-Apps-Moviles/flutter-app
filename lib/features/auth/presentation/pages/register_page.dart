import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/core/enums/app_routes.dart';
import 'package:tcompro_customer/features/auth/domain/auth_repository.dart';
import 'package:tcompro_customer/features/auth/presentation/blocs/register_bloc.dart';
import 'package:tcompro_customer/features/auth/presentation/blocs/register_event.dart';
import 'package:tcompro_customer/features/auth/presentation/blocs/register_state.dart';
import 'package:tcompro_customer/features/auth/presentation/widgets/country_code_picker_field.dart';
import 'package:tcompro_customer/features/auth/presentation/widgets/register_text_field.dart';
import 'package:tcompro_customer/core/data/cubits/profile_cubit.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(
        authRepository: context.read<AuthRepository>(),
      ),
      child: const _RegisterStepperView(),
    );
  }
}

class _RegisterStepperView extends StatelessWidget {
  const _RegisterStepperView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.status == RegisterStatus.invalid ||
            state.status == RegisterStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.message ?? "Error"),
                backgroundColor: Colors.redAccent,
              ),
            );
        }
        
        if (state.status == RegisterStatus.success) {
          if (state.registeredProfile != null) {
            context.read<ProfileCubit>().setProfile(state.registeredProfile!);
          }
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(state.message ?? "Bienvenido"), backgroundColor: Colors.green),
          );
          Navigator.of(context).pushReplacementNamed(AppRoutes.mainRoute);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              "Create Account",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
          body: Stepper(
            type: StepperType.vertical,
            currentStep: state.currentStep,
            elevation: 0,
            onStepTapped: (step) =>
                context.read<RegisterBloc>().add(RegisterStepTapped(step)),
            onStepContinue: () =>
                context.read<RegisterBloc>().add(const RegisterStepContinue()),
            onStepCancel: () {
              if (state.currentStep == 0) {
                Navigator.of(context).pop();
              } else {
                context.read<RegisterBloc>().add(const RegisterStepCancel());
              }
            },
            controlsBuilder: (context, details) {
              final isLastStep = state.currentStep == 2;
              final isLoading = state.status == RegisterStatus.loading;

              return Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isLoading ? null : details.onStepContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffc35215),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : Text(isLastStep ? "Confirm & Register" : "Continue"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (state.currentStep > 0)
                      Expanded(
                        child: TextButton(
                          onPressed: isLoading ? null : details.onStepCancel,
                          child: const Text(
                            "Back",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
            steps: [
              Step(
                title: const Text("Personal Info"),
                isActive: state.currentStep >= 0,
                state: state.currentStep > 0
                    ? StepState.complete
                    : StepState.indexed,
                content: Column(
                  children: [
                    const SizedBox(height: 4),
                    RegisterTextField(
                      icon: Icons.person,
                      label: "First Name",
                      onChanged: (value) => context
                          .read<RegisterBloc>()
                          .add(RegisterFirstNameChanged(value)),
                    ),
                    const SizedBox(height: 16),
                    RegisterTextField(
                      icon: Icons.person,
                      label: "Last Name",
                      onChanged: (value) => context
                          .read<RegisterBloc>()
                          .add(RegisterLastNameChanged(value)),
                    ),
                  ],
                ),
              ),
              Step(
                title: const Text("Contact Info"),
                isActive: state.currentStep >= 1,
                state: state.currentStep > 1
                    ? StepState.complete
                    : StepState.indexed,
                content: Column(
                  children: [
                    const SizedBox(height: 4),
                    RegisterTextField(
                      icon: Icons.email,
                      label: "Email",
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) => context
                          .read<RegisterBloc>()
                          .add(RegisterEmailChanged(value)),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CountryCodePickerField(currentPrefix: state.phonePrefix),    
                        Expanded(
                          child: RegisterTextField(
                            icon: Icons.phone,
                            label: "Phone",
                            keyboardType: TextInputType.phone,
                            onChanged: (value) => context
                                .read<RegisterBloc>()
                                .add(RegisterPhoneChanged(value)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Step(
                title: const Text("Security"),
                isActive: state.currentStep >= 2,
                content: Column(
                  children: [
                    const SizedBox(height: 4),
                    RegisterTextField(
                      icon: Icons.lock,
                      label: "Password",
                      obscureText: !state.isPasswordVisible,
                      onChanged: (value) => context
                          .read<RegisterBloc>()
                          .add(RegisterPasswordChanged(value)),
                    ),
                    const SizedBox(height: 16),
                    RegisterTextField(
                      icon: Icons.lock,
                      label: "Confirm Password",
                      obscureText: !state.isPasswordVisible,
                      onChanged: (value) => context
                          .read<RegisterBloc>()
                          .add(RegisterConfirmationPasswordChanged(value)),
                    ),
                    TextButton.icon(
                      onPressed: () => context
                          .read<RegisterBloc>()
                          .add(const RegisterTogglePasswordVisibility()),
                      icon: Icon(state.isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility),
                      label: Text(state.isPasswordVisible
                          ? "Hide Passwords"
                          : "Show Passwords"),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}