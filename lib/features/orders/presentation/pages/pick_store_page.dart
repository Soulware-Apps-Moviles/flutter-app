import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/features/orders/domain/store.dart';
import 'package:tcompro_customer/features/orders/presentation/bloc/pick_store_bloc.dart';
import 'package:tcompro_customer/features/orders/presentation/bloc/pick_store_event.dart';
import 'package:tcompro_customer/features/orders/presentation/bloc/pick_store_state.dart';

class PickStorePage extends StatelessWidget {
  const PickStorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PickStoreBloc()..add(LoadStoresEvent()),
      child: const _PickStoreView(),
    );
  }
}

class _PickStoreView extends StatelessWidget {
  const _PickStoreView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select a Store"),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: BlocBuilder<PickStoreBloc, PickStoreState>(
        builder: (context, state) {
          if (state.status == PickStoreStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFDD6529)),
            );
          }

          if (state.status == PickStoreStatus.error) {
            return Center(child: Text(state.errorMessage ?? "Unknown error"));
          }

          if (state.stores.isEmpty) {
            return const Center(child: Text("No stores available"));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.stores.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final store = state.stores[index];
                    final isSelected = state.selectedStore?.id == store.id;

                    return _StoreCard(
                      store: store,
                      isSelected: isSelected,
                      onTap: () {
                        context.read<PickStoreBloc>().add(SelectStoreEvent(store: store));
                      },
                    );
                  },
                ),
              ),
              _BottomSelectionBar(
                isEnabled: state.selectedStore != null,
                onConfirm: () {
                   // Navigate to Payment or next step
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StoreCard extends StatelessWidget {
  final Store store;
  final bool isSelected;
  final VoidCallback onTap;

  const _StoreCard({
    required this.store,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFDD6529) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.storefront, color: Color(0xFFDD6529)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      store.address,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: Color(0xFFDD6529)),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomSelectionBar extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onConfirm;

  const _BottomSelectionBar({
    required this.isEnabled,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isEnabled ? onConfirm : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFDD6529),
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey.shade300,
            disabledForegroundColor: Colors.grey.shade500,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "Confirm Store",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}