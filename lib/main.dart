import 'package:currency_converter/domain/currency.dart';
import 'package:currency_converter/service/currency_service.dart';
import 'package:currency_converter/widgets/dropdown_currency.dart';
import 'package:currency_converter/widgets/modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const MyHomePage(title: 'Currency Converter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, double> currencies = {};
  Map<String, CurrencyInfo> detailedCurrencies = {};
  final currenciesService = CurrencyService();

  String? currencyName;
  String? currencyName2;

  Set<String> selectedCurrencies = {};

  double? amount;

  Future<void> getCurrency() async {
    var result = await currenciesService.getCurrency();
    setState(() {
      currencies = result;
    });
  }

  Future<void> getJSON() async {
    var result = await ConvertJsonToMap.readJson();
    setState(() {
      detailedCurrencies = result;
    });
  }

  @override
  void initState() {
    super.initState();

    getJSON();
    fetchCurrencies();
  }

  void fetchCurrencies() async {
    await getCurrency();
  }

  double? getConvertedCurrency(
      {required String? fromCurrency,
      required String? toCurrency,
      required double? amount}) {
    var toRate = currencies[toCurrency];
    var fromRate = currencies[fromCurrency];

    amount ??= 0;
    if (fromRate != null && toRate != null) {
      var usdAmount = amount / fromRate;
      return usdAmount * toRate;
    }
    return null;
  }

  void addCurrencyToList(String currencyKey) {
    setState(() {
      selectedCurrencies.add(currencyKey);
    });
    print(selectedCurrencies);
  }

  void getAllCurrenciesConverted() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: SizedBox(
                    width: 350,
                    child: DropdownCurrency(
                        entries: detailedCurrencies.entries.toList(),
                        onSelected: (key) {
                          setState(() {
                            currencyName = key;
                          });
                        }),
                  ),
                ),
                Flexible(
                  child: SizedBox(
                    width: 200,
                    child: TextField(
                      onChanged: (value) {
                        var fromValue = double.tryParse(value);
                        setState(() {
                          amount = fromValue;
                        });
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "amount",
                          suffixText: currencyName != null &&
                                  detailedCurrencies.containsKey(currencyName)
                              ? detailedCurrencies[currencyName]!.symbol
                              : "-",
                          suffixStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300)),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (var key in selectedCurrencies)
                        if (currencies.containsKey(key))
                          Row(
                            children: [
                              Text(detailedCurrencies[key]?.currencyName ??
                                  ""
                                      "Currency not found"),
                              Text(getConvertedCurrency(
                                      fromCurrency: currencyName,
                                      toCurrency: key,
                                      amount: amount)
                                  .toString())
                            ],
                          ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: Modal(
        entries: detailedCurrencies.entries.toList(),
        onSelected: ((key) => addCurrencyToList(key!)),
      ),
    );
  }
}
