import 'package:currency_converter/domain/amount.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CurrencyTextfield extends StatefulWidget {
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
  State<CurrencyTextfield> createState() => _CurrencyTextfieldState();
}

class _CurrencyTextfieldState extends State<CurrencyTextfield> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onChanged: (value) {
        var fromValue = double.tryParse(value) ?? 0;
        widget.onAmountChanged(
            Amount(amount: fromValue, currency: widget.currency));
      },
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        hintText: "amount",
        suffixText: widget.symbol ?? "-",
        suffixStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+(\.[0-9]*)?$')),
      ],
    );
  }
}
