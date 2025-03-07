import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CurrencyTextfield extends StatelessWidget {
  final String? symbol;
  final Function(double) onAmountChanged;

  CurrencyTextfield({
    super.key,
    required this.symbol,
    required this.onAmountChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        var fromValue = double.tryParse(value);
        onAmountChanged(fromValue ?? 0);
      },
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: "amount",
        suffixText: symbol ?? "-",
        suffixStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+(\.[0-9]{0,2})?$')),
      ],
    );
  }
}
