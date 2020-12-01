import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

// Create a variable that changes
// Use that variable to build your UI (build method)
// Change that variable in setState

class _HomePageState extends State<HomePage> {
  String amount = '';
  String error;
  String result = '';
  String dropdownValueFrom = 'EUR / Euro';
  String dropdownValueTo = 'EUR / Euro';

  // ignore: always_specify_types
  List<String> currencyShort = ['EUR', 'RON', 'USD', 'GBP'];

  // ignore: always_specify_types
  List<String> currency = [
    'EUR / Euro',
    'RON / Romanian Leu',
    'USD / US Dollar',
    'GBP / Pound Sterling'
  ];

  // ignore: always_specify_types
  List<double> valueInEur = [1.0, 0.2054, 0.8434, 1.1205];

  int fromIndex = 0;
  int toIndex = 0;

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text('Amount')),
            TextField(
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(
                fontSize: 30.0,
                color: Colors.blueAccent,
              ),
              decoration: InputDecoration(
                errorText: error,
              ),
              onChanged: (String value) {
                setState(() {
                  if (isNumeric(value)) {
                    error = null;
                  } else {
                    error = 'Enter a valid number!';
                  }
                  amount = value;
                });
              },
            ),
            // ignore: always_specify_types
            DropdownButton(
              value: dropdownValueFrom,
              onChanged: (String value) {
                setState(() {
                  fromIndex = currency.indexOf(value);
                  print(fromIndex.toString());
                  dropdownValueFrom = value;
                });
              },
              items: currency.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const Text('To',
                style: TextStyle(
                  fontSize: 25,
                )),
            // ignore: always_specify_types
            DropdownButton(
              value: dropdownValueTo,
              onChanged: (String value) {
                setState(() {
                  toIndex = currency.indexOf(value);
                  print(toIndex.toString());
                  dropdownValueTo = value;
                });
              },
              items: currency.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            RaisedButton(
              color: Colors.blueAccent,
              child: const Text('Convert',
                  style: TextStyle(
                    color: Colors.white,
                  )),
              onPressed: () {
                if (amount == '' || amount == null) {
                  setState(() {
                    error = 'Enter a valid number!';
                  });
                } else {
                  if (error == null || error == '') {
                    final double fromValue = double.parse(amount);
                    final double toValue = fromValue *
                        valueInEur.elementAt(fromIndex) /
                        valueInEur.elementAt(toIndex);
                    setState(() {
                      if (toValue.toInt() ==
                          double.parse(toValue.toStringAsFixed(2))) {
                        result = fromValue.toStringAsFixed(2) +
                            ' ' +
                            currencyShort.elementAt(fromIndex) +
                            ' is ';
                        result += toValue.toInt().toString() +
                            ' ' +
                            currencyShort.elementAt(toIndex);
                      } else {
                        result = fromValue.toStringAsFixed(2) +
                            ' ' +
                            currencyShort.elementAt(fromIndex) +
                            ' is ';
                        result += toValue.toStringAsFixed(2) +
                            ' ' +
                            currencyShort.elementAt(toIndex);
                      }
                    });
                  }
                }
              },
            ),
            Text(result,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.blueAccent,
                )),
          ],
        ),
      ),
    );
  }
}
