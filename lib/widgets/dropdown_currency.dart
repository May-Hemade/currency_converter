import 'package:flutter/material.dart';

class DropdownCurrency extends StatefulWidget {
  const DropdownCurrency(
      {super.key, required this.names, required this.onSelected});

  final List<String> names;
  final Function(String?)? onSelected;

  @override
  State<DropdownCurrency> createState() => _DropdownCurrency();
}

class _DropdownCurrency extends State<DropdownCurrency> {
  String? selectedCurrency;
  @override
  void initState() {
    super.initState();
    selectedCurrency = widget.names.isNotEmpty ? widget.names[0] : null;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
        initialSelection: selectedCurrency,
        label: const Text("Currency"),
        dropdownMenuEntries: widget.names
            .map((name) => DropdownMenuEntry(value: name, label: name))
            .toList(),
        onSelected: widget.onSelected);
  }
}
