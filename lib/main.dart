import 'package:currency_converter/domain/currency.dart';
import 'package:currency_converter/service/currency_service.dart';
import 'package:currency_converter/widgets/currencies_list.dart';
import 'package:currency_converter/widgets/dropdown_currency.dart';
import 'package:currency_converter/widgets/modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String? currencyName;

  Set<String> selectedCurrencies = {};
  double? amount;

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
      currencyName = "USD";
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: SizedBox(
                  width: 350,
                  child: DropdownCurrency(
                      selectedCurrency: currencyName,
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
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "amount",
                        suffixText: currencyName != null &&
                                detailedCurrencies.containsKey(currencyName)
                            ? detailedCurrencies[currencyName]!.symbol
                            : "-",
                        suffixStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w300)),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: CurrenciesList(
                amount: amount,
                fromRate: detailedCurrencies[currencyName]?.rate,
                currencies: selectedCurrencies
                    .map((key) => detailedCurrencies[key])
                    .whereType<CurrencyInfo>()
                    .toList()),
          )
        ],
      ),
      floatingActionButton: Modal(
        entries: detailedCurrencies.entries.toList(),
        onSelected: ((key) => addCurrencyToList(key!)),
      ),
    );
  }
}
