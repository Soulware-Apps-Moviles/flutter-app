import 'package:flutter/material.dart';
import 'package:tcompro_customer/core/enums/country_prefixes.dart';

class CountryCodePickerModal extends StatefulWidget {
  final Function(String) onSelect;
  final ScrollController? scrollController;

  const CountryCodePickerModal({
    super.key,
    required this.onSelect,
    this.scrollController,
  });

  @override
  State<CountryCodePickerModal> createState() => _CountryCodePickerModalState();
}

class _CountryCodePickerModalState extends State<CountryCodePickerModal> {
  List<Map<String, String>> _filteredCountries = [];

  @override
  void initState() {
    super.initState();
    _filteredCountries = countryPrefixes;
  }

  void _filterCountries(String query) {
    setState(() {
      _filteredCountries = countryPrefixes.where((country) {
        final name = country['name']?.toLowerCase() ?? '';
        final code = country['code'] ?? '';
        final searchLower = query.toLowerCase();
        return name.contains(searchLower) || code.contains(searchLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: "Search country or code...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            onChanged: _filterCountries,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              controller: widget.scrollController,
              itemCount: _filteredCountries.length,
              itemBuilder: (context, index) {
                final country = _filteredCountries[index];
                return ListTile(
                  leading: Text(country['flag'] ?? '', style: const TextStyle(fontSize: 24)),
                  title: Text(country['name'] ?? ''),
                  trailing: Text(country['code'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () {
                    widget.onSelect(country['code']!);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}