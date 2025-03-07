import 'package:country_flags/country_flags.dart';
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
    var colorScheme = Theme.of(context).colorScheme;
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
            backgroundColor: colorScheme.inversePrimary,
            context: context,
            builder: (BuildContext context) {
              return ListView.builder(
                itemCount: widget.entries.length,
                itemBuilder: (context, index) {
                  final currency = widget.entries[index];
                  return Container(
                    padding: EdgeInsets.only(
                      left: 10,
                      top: index == 0 ? 10 : 0,
                    ),
                    child: ListTile(
                      leading: CountryFlag.fromCountryCode(
                        currency.value.flag,
                        height: 16,
                        width: 20,
                      ),
                      title: Text("${currency.value.currencyName} "),
                      trailing: Text("(${currency.key})"),
                      onTap: () {
                        widget.onSelected(currency.key);
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              );
            });
      },
      child: const Icon(Icons.add),
    );
  }
}
