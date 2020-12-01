import 'dart:core';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:math';

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
  Random random = new Random();
  String typedNumber = '';
  int guessedNumberInt = 0;
  int randomNumber;
  String error = null;
  String dialogText = '';

  bool isInt(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  bool isSquare(int number) {
    double val = sqrt(number);
    return val % 1 == 0;
  }

  bool isTriangular(int number) {
    double val = (sqrt(8 * number + 1) - 1) / 2;
    return val % 1 == 0;
  }

  void makeText(int number) {
    dialogText = number.toString() + ' is ';
    if (isSquare(number)) {
      if (isTriangular(number)) {
        dialogText += 'both a triangular and a square number';
      } else {
        dialogText += 'square number';
      }
    } else if (isTriangular(number)) {
      dialogText += 'triangular number';
    } else {
      dialogText += 'neither square or triangular';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number shapes'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const Text(
              'Please input a number to see if it is square or triangular.',
              style: TextStyle(
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            TextField(
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontSize: 30.0,
                  color: Colors.grey,
                ),
                decoration: InputDecoration(
                  errorText: error,
                ),
                onChanged: (String value) {
                  setState(() {
                    if (value == '') {
                      error = 'Field can not be empty!';
                    } else if (isInt(value)) {
                      error = null;
                    } else {
                      error = 'Not a valid number!';
                    }
                    typedNumber = value;
                  });
                }),
            RaisedButton(
              color: Colors.blueGrey,
              child: const Text('Check',
                  style: TextStyle(
                    color: Colors.white,
                  )),
              onPressed: () {
                if (typedNumber == '') {
                  setState(() {
                    error = 'Field can not be empty!';
                  });
                } else if (error == null) {
                  setState(() {
                    makeText(int.parse(typedNumber));
                    shapeDialog(context);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void shapeDialog(BuildContext context) {
    var alertDialog = AlertDialog(
      title: Text(
        dialogText,
        textAlign: TextAlign.center,
      ),
      content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            })
      ]),
    );
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }
}
