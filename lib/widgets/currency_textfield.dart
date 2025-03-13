import 'package:currency_converter/domain/amount.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CurrencyTextfield extends StatelessWidget {
  final String? symbol;
  final String currency;
  final TextEditingController? controller;
  final Function(Amount) onAmountChanged;

  CurrencyTextfield({
    super.key,
    required this.symbol,
    this.controller,
    required this.currency,
    required this.onAmountChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: (value) {
        var fromValue = double.tryParse(value) ?? 0;
        onAmountChanged(Amount(amount: fromValue, currency: currency));
      },
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: "amount",
        suffixText: symbol ?? "-",
        suffixStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+(\.[0-9]*)?$')),
      ],
    );
  }
}
