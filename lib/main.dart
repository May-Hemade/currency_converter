import 'dart:ffi';

import 'package:currency_converter/service/currency_service.dart';
import 'package:currency_converter/widgets/dropdown_currency.dart';
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
  final currenciesService = CurrencyService();
  TextEditingController currencyController = TextEditingController();
  TextEditingController currencyController2 = TextEditingController();
  String? currencyName;
  String? currencyName2;

  double? value1;
  double? value2;

  Future<void> getCurrency() async {
    var result = await currenciesService.getCurrency();
    setState(() {
      currencies = result;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCurrencies();
  }

  void fetchCurrencies() async {
    await getCurrency();
  }

  void getConvertedCurrency() {
    var convertedRate = currencies[currencyName2];
    var rate = currencies[currencyName];
    value1 ??= 0;
    if (rate != null && convertedRate != null) {
      var toUSD = value1! / rate;
      var toNewCurrency = toUSD * convertedRate;
      currencyController2.text = toNewCurrency.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                DropdownCurrency(
                    names: currencies.keys.toList(),
                    onSelected: (name) {
                      setState(() {
                        currencyName = name;
                      });
                    }),
                DropdownCurrency(
                  names: currencies.keys.toList(),
                  onSelected: (name) {
                    setState(() {
                      currencyName2 = name;
                    });
                  },
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 1, vertical: 5),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    value1 = double.tryParse(value);
                    getConvertedCurrency();
                  });
                },
                controller: currencyController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a search term',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 1, vertical: 5),
              child: TextField(
                controller: currencyController2,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a search term',
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getConvertedCurrency();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
