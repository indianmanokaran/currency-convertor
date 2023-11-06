import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  String selectedCurrency = "Select Currency";
  String selectedCurrency1 = "Select Currency";
  double finalResult = 0;
  String convertTo = "USD";
  String convertTo1 = "Your";
  final TextEditingController _getValueAsDollar = TextEditingController();
  int _groupValue=0;

  // Get JSON data
  Map<String, double> currencyMap = {};
  List<String> currencies = [];
  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://api.exchangerate-api.com/v4/latest/$selectedCurrency'));

    final response1 = await http.get(Uri.parse('https://api.exchangerate-api.com/v4/latest/euro'));

    if (response1.statusCode == 200) {
      Map<String, dynamic> data1 = json.decode(response1.body);
      Map<String, dynamic> rates1 = data1['rates'];
      rates1.forEach((currency, rate) {
        currencies.add(currency);
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> a1 = json.decode(response.body);
        if (a1['rates'].containsKey(selectedCurrency1)) {
          num exchangeRate = a1['rates'][selectedCurrency1];
          final double amountInDollars = double.tryParse(_getValueAsDollar.text) ?? 0.0;

          convertTo1 = (amountInDollars * exchangeRate).toString();
            convertTo = selectedCurrency1;
            _showResult(convertTo1);

        } else {
          print('$selectedCurrency1 not found in rates map');
        }
      } else {
        print('Failed to load data');
      }
    } else {
      print('Failed to load data for euro');
    }
  }



  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data when the widget initializes
  }

  void _showResult(String result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Conversion Result'),
          content: Text(result),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  double calculateMoney(String dollar, double multiplier) {
    if (dollar.isNotEmpty) {
      return double.parse(dollar) * multiplier;
    } else {
      throw Exception("Invalid input");
    }
  }

  void _handleGroupValue(int? value) {
    setState(() {
      if (value != null) {
        _groupValue = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Currency Converter",
          style: TextStyle(fontSize: 25.0),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: ListView(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 20.0)),
            Center(
              child: Image.network("https://www.google.com/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png", width: 150.0, height: 100.0),
            ),
            TextField(
              controller: _getValueAsDollar, // Attach the TextEditingController
              decoration: InputDecoration(
                labelText: 'Amount ',
                hintText: 'Enter amount',
              ),
            ),

            Container(
              margin: const EdgeInsets.only(right: 12.0, left: 12.0, top: 10.0),
              child: DropdownButton<String>(
                value: selectedCurrency,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCurrency = newValue ?? "Select Currency";
                    // Call your function here when the user selects a currency
                  });
                },
                items: [
                  DropdownMenuItem<String>(
                    value: "Select Currency",
                    child: Text("Select Currency"),
                  ),
                  ...currencies.map((String currency) {
                    return DropdownMenuItem<String>(
                      value: currency,
                      child: Text(currency),
                    );
                  }).toList(),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 12.0, left: 12.0, top: 10.0),
              child: DropdownButton<String>(
                value: selectedCurrency1,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCurrency1 = newValue ?? "Select Currency";
                    // Call your function here when the user selects a currency
                  });
                },
                items: [
                  DropdownMenuItem<String>(
                    value: "Select Currency",
                    child: Text("Select Currency"),
                  ),
                  ...currencies.map((String currency) {
                    return DropdownMenuItem<String>(
                      value: currency,
                      child: Text(currency),
                    );
                  }).toList(),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: 20.0, left: 70.0, right: 95.0),
              child: ElevatedButton(
                onPressed: fetchData,
                child: Text(
                  "Convert",
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.yellowAccent,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                ),
              ),
            ),


            // Column(
            //   children: <Widget>[
            //     ElevatedButton(
            //       onPressed: fetchData,
            //       child: Text('Fetch Data'),
            //     ),
            //     SizedBox(height: 20.0),
            //     Text("Selected Currency: $selectedCurrency"),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
