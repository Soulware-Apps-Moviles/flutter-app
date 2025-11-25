import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/core/enums/country_prefixes.dart';
import 'package:tcompro_customer/features/auth/presentation/blocs/register_bloc.dart';
import 'package:tcompro_customer/features/auth/presentation/blocs/register_event.dart';
import 'package:tcompro_customer/features/auth/presentation/widgets/country_code_picker_modal.dart';

class CountryCodePickerField extends StatelessWidget {
  final String currentPrefix;

  const CountryCodePickerField({
    super.key,
    required this.currentPrefix,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showCountryPicker(
          context,
          (selectedPrefix) {
            context.read<RegisterBloc>().add(
                  RegisterPhonePrefixChanged(selectedPrefix),
                );
          },
        );
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black54),
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${_getFlag(currentPrefix)} $currentPrefix",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const Icon(Icons.arrow_drop_down, size: 20, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}

String _getFlag(String code) {
  final country = countryPrefixes.firstWhere(
    (element) => element['code'] == code,
    orElse: () => {'flag': '🌍', 'code': ''},
  );
  return country['flag'] ?? '🌍';
}

void _showCountryPicker(BuildContext context, Function(String) onSelect) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, controller) => CountryCodePickerModal(
        onSelect: onSelect,
        scrollController: controller,
      ),
    ),
  );
}