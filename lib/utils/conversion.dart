double? getConvertedCurrency(
    {required double? fromRate,
    required double? toRate,
    required double? amount}) {
  amount ??= 0;
  if (fromRate == toRate) {
    return amount;
  }
  if (fromRate != null && toRate != null && fromRate != 0) {
    var usdAmount = amount / fromRate;
    return usdAmount * toRate;
  }
  return null;
}

double roundCurrency(double? value) {
  return value != null ? double.parse(value.toStringAsFixed(2)) : 0.00;
}
