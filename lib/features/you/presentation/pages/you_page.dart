import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/features/auth/domain/auth_repository.dart';
import 'package:tcompro_customer/features/home/presentation/bloc/home_bloc.dart';
import 'package:tcompro_customer/features/you/presentation/bloc/you_bloc.dart';
import 'package:tcompro_customer/features/you/presentation/bloc/you_state.dart';
import 'package:tcompro_customer/features/you/presentation/bloc/your_event.dart';
import 'package:tcompro_customer/features/you/presentation/pages/favorites_page.dart';
import 'package:tcompro_customer/features/you/presentation/widgets/dashboard_button.dart';
import 'package:tcompro_customer/features/you/presentation/widgets/profile_header.dart';
import 'package:tcompro_customer/features/you/presentation/widgets/sign_out_button.dart';

class YouPage extends StatelessWidget {
  const YouPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => YouBloc(
        authRepository: context.read<AuthRepository>(),
      ),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: BlocListener<YouBloc, YouState>(
        listener: (context, state) {
          if (state.status == YouStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!), backgroundColor: Colors.red),
            );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const ProfileHeader(),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: DashboardButton(
                          label: "Favorites",
                          icon: Icons.favorite_border_rounded,
                          onTap: () {
                            Navigator.push(
                              context,
                              FavoritesPage.route(
                                customerId: context.read<HomeBloc>().state.customerId!
                              )
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: DashboardButton(
                          label: "Orders",
                          icon: Icons.receipt_long_rounded,
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (_) => const OrdersPage()),
                            // );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                BlocBuilder<YouBloc, YouState>(
                  builder: (context, state) {
                    return SignOutButton(
                      isLoading: state.status == YouStatus.loading,
                      onTap: () {
                        context.read<YouBloc>().add(LogoutRequested());
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}