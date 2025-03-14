import 'package:flutter/material.dart';
import 'package:currency_converter/domain/currency.dart';
import 'package:country_flags/country_flags.dart';

class CurrencyDropdownMenu extends StatefulWidget {
  final List<MapEntry<String, CurrencyInfo>> entries;
  final Function(String?) onSelected;
  final String? selectedCurrency;
  final bool showCountryName;

  const CurrencyDropdownMenu(
      {super.key,
      required this.entries,
      required this.onSelected,
      required this.selectedCurrency,
      required this.showCountryName});

  @override
  State<CurrencyDropdownMenu> createState() => _CurrencyDropdownMenuState();
}

class _CurrencyDropdownMenuState extends State<CurrencyDropdownMenu> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String initialSelection = widget.entries.isNotEmpty
        ? widget.selectedCurrency ?? widget.entries.first.key
        : '';

    final List<DropdownMenuItem<String>> dropdownMenuItems = widget.entries
        .map((entry) => DropdownMenuItem<String>(
              value: entry.key,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CountryFlag.fromCountryCode(
                      entry.value.flag,
                      height: 16,
                      width: 20,
                    ),
                    const SizedBox(width: 6),
                    if (!widget.showCountryName)
                      Text(
                        "${entry.value.currencyName} (${entry.key})",
                        style: const TextStyle(fontSize: 14),
                      )
                    else
                      Text(
                        " ${entry.key}",
                        style: const TextStyle(fontSize: 12),
                      ),
                  ],
                ),
              ),
            ))
        .toList();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButton<String>(
        underline: SizedBox(),
        value: initialSelection.isNotEmpty ? initialSelection : null,
        borderRadius: BorderRadius.circular(4),
        isExpanded: true,
        onChanged: (String? newValue) {
          widget.onSelected(newValue);
        },
        items: dropdownMenuItems,
      ),
    );
  }
}
