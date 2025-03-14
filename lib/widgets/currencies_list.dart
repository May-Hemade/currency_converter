import 'package:currency_converter/domain/amount.dart';
import 'package:currency_converter/domain/currency.dart';
import 'package:currency_converter/widgets/currency_list_item.dart';
import 'package:flutter/material.dart';

class CurrenciesList extends StatefulWidget {
  final List<CurrencyInfo> currencies;
  final double? fromRate;
  final Amount? amount;
  final Function(Amount) onCurrencyConversion;
  final Function(String) onDelete;

  CurrenciesList({
    super.key,
    required this.currencies,
    required this.amount,
    required this.fromRate,
    required this.onCurrencyConversion,
    required this.onDelete,
  });

  @override
  State<CurrenciesList> createState() => _CurrenciesListState();
}

class _CurrenciesListState extends State<CurrenciesList> {
  int? _currentEditingIndex;

  void _onAmountChanged(Amount amount, int index) {
    widget.onCurrencyConversion(amount);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: widget.currencies.map((currency) {
        int index = widget.currencies.indexOf(currency);
        return CurrencyListItem(
          currency: currency,
          amount: widget.amount,
          fromRate: widget.fromRate,
          isEditing: _currentEditingIndex == index,
          onAmountChanged: (amount) => _onAmountChanged(amount, index),
          onEdit: () {
            setState(() {
              _currentEditingIndex = index;
            });
          },
          onDelete: widget.onDelete,
        );
      }).toList(),
    );
  }
}
