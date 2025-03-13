import 'package:currency_converter/domain/amount.dart';
import 'package:currency_converter/domain/currency.dart';
import 'package:currency_converter/service/currency_service.dart';
import 'package:currency_converter/widgets/currencies_list.dart';
import 'package:currency_converter/widgets/currency_dropdown_menu.dart';
import 'package:currency_converter/widgets/currency_textfield.dart';
import 'package:currency_converter/widgets/modal.dart';
import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

void main() async {
  print('Device locale: ${Intl.systemLocale}');
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: MyHomePage(title: 'Currency Converter', changeTheme: changeTheme),
    );
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.changeTheme});

  final String title;

  final Function(ThemeMode) changeTheme;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

bool isDarkMode = false;

class _MyHomePageState extends State<MyHomePage> {
  Map<String, CurrencyInfo> detailedCurrencies = {};
  final currenciesService = CurrencyService();

  Set<String> selectedCurrencies = {};
  Amount amount = Amount(amount: 0, currency: "USD");

  @override
  void initState() {
    super.initState();

    fetchCurrencies();
  }

  void fetchCurrencies() async {
    var rates = await currenciesService.getCurrencyRate();
    var currencies = await ConvertJsonToMap.readCurrenciesFromJson();
    for (var entry in currencies.entries) {
      entry.value.rate = rates[entry.key];
    }
    setState(() {
      detailedCurrencies = currencies;
    });
  }

  void addCurrencyToList(String currencyKey) {
    setState(() {
      selectedCurrencies.add(currencyKey);
    });
    print(selectedCurrencies);
  }

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
      widget.changeTheme(isDarkMode ? ThemeMode.dark : ThemeMode.light);
    });
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.inversePrimary,
        elevation: 10,
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
                onPressed: toggleTheme,
                icon: Icon(isDarkMode
                    ? Icons.wb_sunny_rounded
                    : Icons.nightlight_round)),
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          bool isMobile = screenWidth < 600;

          return Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 800),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 2,
                          child: CurrencyDropdownMenu(
                            showCountryName: isMobile,
                            selectedCurrency: amount.currency,
                            entries: detailedCurrencies.entries.toList(),
                            onSelected: (key) {
                              setState(() {
                                amount = Amount(
                                    amount: amount.amount,
                                    currency: key ?? "USD");
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 20),
                        Flexible(
                            flex: 1,
                            child: CurrencyTextfield(
                                symbol:
                                    detailedCurrencies[amount.currency]?.symbol,
                                currency: amount.currency,
                                onAmountChanged: (value) {
                                  setState(() {
                                    amount = value;
                                  });
                                }))
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Expanded(
                      child: selectedCurrencies.isNotEmpty
                          ? CurrenciesList(
                              onCurrencyConversion: (value) {
                                setState(() {
                                  amount = value;
                                });
                              },
                              onDelete: (value) {
                                setState(() {
                                  selectedCurrencies.remove(value);
                                });
                              },
                              amount: amount,
                              fromRate:
                                  detailedCurrencies[amount.currency]?.rate,
                              currencies: selectedCurrencies
                                  .map((key) => detailedCurrencies[key])
                                  .whereType<CurrencyInfo>()
                                  .toList(),
                            )
                          : Center(
                              child: Text(
                              'Please select a currency to convert.',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.inverseSurface,
                                letterSpacing: 0.5,
                              ),
                            )),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: Modal(
        entries: detailedCurrencies.entries.toList(),
        onSelected: ((key) => addCurrencyToList(key!)),
      ),
    );
  }
}
