import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/core/data/cubits/profile_cubit.dart';
import 'package:tcompro_customer/shared/domain/profile.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.select<ProfileCubit, Profile?>((cubit) => cubit.state);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0E6),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFDD6529), width: 2),
            ),
            child: const Icon(
              Icons.person,
              size: 40,
              color: Color(0xFFDD6529),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            profile != null ? "${profile.firstName} ${profile.lastName}" : "Guest User",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            profile?.email ?? "Sign in to see your info",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
