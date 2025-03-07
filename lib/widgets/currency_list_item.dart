import 'package:country_flags/country_flags.dart';
import 'package:currency_converter/domain/currency.dart';
import 'package:currency_converter/utils/conversion.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrencyListItem extends StatelessWidget {
  final CurrencyInfo currency;
  final double? fromRate;
  final double? amount;

  CurrencyListItem(
      {super.key,
      required this.currency,
      required this.fromRate,
      required this.amount});

  String formatCurrency(double? amount) {
    NumberFormat currencyFormatter = NumberFormat.currency(
        locale: Intl.systemLocale, symbol: currency.symbol);
    return currencyFormatter.format(amount ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: CountryFlag.fromCountryCode(
          currency.flag,
          height: 22,
          width: 22,
        ),
      ),
      title: Text(
        currency.countryName,
        style: TextStyle(fontSize: 14),
      ),
      trailing: Text(
        formatCurrency(roundCurrency(getConvertedCurrency(
            fromRate: fromRate, toRate: currency.rate, amount: amount))),
        style: TextStyle(fontSize: 14),
      ),
    );
  }
}
