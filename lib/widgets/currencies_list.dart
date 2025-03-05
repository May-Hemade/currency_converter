import 'package:currency_converter/domain/currency.dart';
import 'package:currency_converter/widgets/currency_list_item.dart';
import 'package:flutter/material.dart';

class CurrenciesList extends StatelessWidget {
  final List<CurrencyInfo> currencies;
  final double? fromRate;
  final double? amount;
  CurrenciesList(
      {super.key,
      required this.currencies,
      required this.amount,
      required this.fromRate});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: currencies.map((currency) {
        return CurrencyListItem(
            currency: currency, amount: amount, fromRate: fromRate);
      }).toList(),
    );
  }
}
