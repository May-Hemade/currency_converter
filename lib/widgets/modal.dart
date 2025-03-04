import 'package:currency_converter/domain/currency.dart';

import 'package:flutter/material.dart';

class Modal extends StatefulWidget {
  const Modal({
    super.key,
    required this.entries,
    required this.onSelected,
  });

  final List<MapEntry<String, CurrencyInfo>> entries;
  final Function(String?) onSelected;

  @override
  State<Modal> createState() => _ModalState();
}

class _ModalState extends State<Modal> {
  String? selectedCurrency;

  @override
  void initState() {
    super.initState();
    selectedCurrency = widget.entries.isNotEmpty ? widget.entries[0].key : null;
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return ListView.builder(
                itemCount: widget.entries.length,
                itemBuilder: (context, index) {
                  final currency = widget.entries[index];
                  return ListTile(
                    title: Text(currency.key),
                    onTap: () {
                      widget.onSelected(currency.key);
                      Navigator.pop(context);
                    },
                  );
                },
              );
            });
      },
      child: const Icon(Icons.add),
    );
  }
}
