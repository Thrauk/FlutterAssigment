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
  String guessedNumber = '';
  int guessedNumberInt = 0;
  int randomNumber;
  String error = null;
  String gameText = '';

  void initState() {
    super.initState();
    randomNumber = random.nextInt(100) + 1;
  }

  bool isInt(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  String makeText(int number) {
    String ret = 'You tried ' + number.toString() + '\n';
    if (number == randomNumber) {
      ret += 'You guessed right.';
    } else if (number < randomNumber) {
      ret += 'Try higher.';
    } else {
      ret += 'Try lower.';
    }
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guess my number'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const Text(
              'I\'m thinking of a number between 1 and 100',
              style: TextStyle(
                fontSize: 24,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'It\'s your turn to guess my number!',
              style: TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              gameText,
              style: const TextStyle(
                fontSize: 40,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Card(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  // ignore: prefer_const_constructors
                  Text(
                    'Try a number!',
                    // ignore: prefer_const_constructors
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  // ignore: prefer_const_constructors
                  SizedBox(height: 10),
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
                          guessedNumber = value;
                        });
                      }),
                  const SizedBox(height: 10),
                  RaisedButton(
                    color: Colors.blueGrey,
                    child: const Text('Guess',
                        style: TextStyle(
                          color: Colors.white,
                        )),
                    onPressed: () {
                      if (guessedNumber == '') {
                        setState(() {
                          error = 'Field can not be empty!';
                        });
                      } else if (error == null) {
                        setState(() {
                          gameText = makeText(int.parse(guessedNumber));
                          if (int.parse(guessedNumber) == randomNumber) {
                            guessDialog(context);
                            randomNumber = random.nextInt(100) + 1;
                          }
                        });
                      }
                    },
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  void guessDialog(BuildContext context) {
    var alertDialog = AlertDialog(
      title: Text(
        'You guessed right!',
        textAlign: TextAlign.center,
      ),
      content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Text(
          'Try again?',
          textAlign: TextAlign.center,
        ),
        FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            })
      ]),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }
}
