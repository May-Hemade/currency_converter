import 'package:flutter/material.dart';
import 'package:currency_converter/domain/currency.dart';
import 'package:country_flags/country_flags.dart';

class DropdownCurrency extends StatefulWidget {
  final List<MapEntry<String, CurrencyInfo>> entries;
  final Function(String?) onSelected;
  final String? selectedCurrency;

  const DropdownCurrency(
      {super.key,
      required this.entries,
      required this.onSelected,
      required this.selectedCurrency});

  @override
  State<DropdownCurrency> createState() => _DropdownCurrencyState();
}

class _DropdownCurrencyState extends State<DropdownCurrency> {
  @override
  void initState() {
    super.initState();
    // widget.selectedCurrency = widget.entries.isNotEmpty ? widget.entries[0].key : null;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.selectedCurrency,
      isExpanded: true,
      hint: Text(
        "Select Currency",
        style: TextStyle(fontSize: 14),
      ),
      items: widget.entries.map((entry) {
        return DropdownMenuItem<String>(
          value: entry.key,
          child: Row(
            children: [
              CountryFlag.fromCountryCode(
                entry.value.flag,
                height: 16,
                width: 24,
              ),
              const SizedBox(width: 6),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: entry.value.currencyName,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: " (${entry.key})",
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (newValue) {
        widget.onSelected(newValue);
      },
      dropdownColor: Colors.white,
    );
  }
}
