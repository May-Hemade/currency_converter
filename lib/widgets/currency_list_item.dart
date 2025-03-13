import 'package:country_flags/country_flags.dart';
import 'package:currency_converter/domain/amount.dart';
import 'package:currency_converter/domain/currency.dart';
import 'package:currency_converter/utils/conversion.dart';
import 'package:currency_converter/widgets/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrencyListItem extends StatefulWidget {
  final CurrencyInfo currency;
  final double? fromRate;
  final Amount? amount;
  final Function(Amount) onAmountChanged;
  final bool isEditing;
  final VoidCallback onEdit;
  final Function(String) onDelete;

  CurrencyListItem(
      {super.key,
      required this.currency,
      required this.fromRate,
      required this.amount,
      required this.onAmountChanged,
      required this.isEditing,
      required this.onEdit,
      required this.onDelete});

  @override
  State<CurrencyListItem> createState() => _CurrencyListItemState();
}

class _CurrencyListItemState extends State<CurrencyListItem> {
  late TextEditingController _controller;

  double currentValue = 0;

  double convertedAmount = 0;
  bool isOverLayVisibile = false;

  String formatCurrency(double? amount) {
    NumberFormat currencyFormatter = NumberFormat.currency(
        locale: Intl.systemLocale, symbol: widget.currency.symbol);
    return currencyFormatter.format(amount ?? 0);
  }

  void calculateAmout() {
    setState(() {
      convertedAmount = roundCurrency(getConvertedCurrency(
          fromRate: widget.fromRate,
          toRate: widget.currency.rate,
          amount: widget.amount?.amount));
      if (widget.currency.currency != widget.amount?.currency) {
        _controller.text = convertedAmount.toString();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: convertedAmount.toString());
    calculateAmout();
  }

  @override
  void didUpdateWidget(CurrencyListItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.amount != oldWidget.amount) {
      calculateAmout();
    }
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    return Stack(children: [
      ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: CountryFlag.fromCountryCode(
              widget.currency.flag,
              height: 22,
              width: 22,
            ),
          ),
          title: GestureDetector(
            onTap: () {
              setState(() {
                isOverLayVisibile = !isOverLayVisibile;
              });
            },
            child: Text(
              widget.currency.countryName,
              style: TextStyle(fontSize: 14),
            ),
          ),
          trailing: GestureDetector(
            onTap: () {
              setState(() {
                widget.onEdit();
              });
            },
            child: widget.isEditing
                ? SizedBox(
                    width: 100,
                    child: CurrencyTextfield(
                        controller: _controller,
                        symbol: widget.currency.symbol,
                        currency: widget.currency.currency,
                        onAmountChanged: (value) {
                          widget.onAmountChanged(Amount(
                              amount: value.amount,
                              currency: widget.currency.currency));
                        }))
                : Text(
                    formatCurrency(convertedAmount),
                    style: TextStyle(fontSize: 14),
                  ),
          )),
      if (isOverLayVisibile)
        Positioned.fill(
            child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
              decoration: BoxDecoration(
                color: colorScheme.error.withAlpha(100),
                border: Border.all(
                  width: 0.1,
                  color: colorScheme.error.withAlpha(100),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                      onTap: () => widget.onDelete(widget.currency.currency),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: colorScheme.error,
                          radius: 15,
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      )))),
        ))
    ]);
  }
}
