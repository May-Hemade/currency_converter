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
  return 0.0;
}

double roundCurrency(double? value) {
  if (value != null) {
    return (value * 100).round() / 100;
  }
  return 0.00;
}
