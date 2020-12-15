import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // ignore: always_specify_types
  List<List<int>> table = List<List<int>>.generate(3, (int i) => [0, 0, 0], growable: false);
  List<List<Color>> tableColor =
      // ignore: always_specify_types
      List<List<Color>>.generate(3, (int i) => [Colors.black, Colors.black, Colors.black], growable: false);
  Color playerOneColor = Colors.red;
  Color playerTwoColor = Colors.green;
  // ignore: always_specify_types
  List<Color> playerColor = [Colors.red, Colors.green];

  int currentPlayer = 1;
  bool _isVisible = false;
  bool _enabledTap = true;

  @override
  void initState() {
    super.initState();
  }

  bool isOnDiagonal(int X, int Y) {
    // ignore: always_put_control_body_on_new_line
    if ((X == 0 && Y == 1) || (X == 1 && Y == 0) || (X == 1 && Y == 2) || (X == 2 && Y == 1)) return false;
    return true;
  }

  int checkDiagonal(int X, int Y, int player) {
    if (table[0][0] == player && table[1][1] == player && table[2][2] == player) {
      return 1; //main diag
    }
    if (table[0][2] == player && table[1][1] == player && table[2][0] == player) {
      return 2; //secondary diag
    }
    return -1; //no diag
  }

  bool checkColumn(int Y, int player) {
    for (int i = 0; i < 3; i++) {
      // ignore: always_put_control_body_on_new_line
      if (table[i][Y] != table[0][Y]) return false;
    }
    return true;
  }

  bool checkRow(int X, int player) {
    for (int i = 0; i < 3; i++) {
      // ignore: always_put_control_body_on_new_line
      if (table[X][i] != player) return false;
    }
    return true;
  }

  bool isFull() {
    for (final List<int> x in table) {
      if (x.contains(0)) {
        return false;
      }
    }
    return true;
  }

  void _onTap(int index) {
    final int col = index % 3;
    final int row = index ~/ 3;
    if (table[row][col] == 0) {
      Color nextColor;
      if (currentPlayer == 1) {
        table[row][col] = currentPlayer;
        currentPlayer = 2;
      } else {
        table[row][col] = currentPlayer;
        currentPlayer = 1;
      }
      setState(() {
        nextColor = playerColor[currentPlayer - 1];
        tableColor[row][col] = nextColor;
      });
    }
    conditionChecker(row, col);
  }

  void drawWinner(List<List<int>> coords) {
    _isVisible = true;
    _enabledTap = false;
    final List<int> coord0 = coords[0];
    final List<int> coord1 = coords[1];
    final List<int> coord2 = coords[2];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if ((coord0[0] != i || coord0[1] != j) &&
            (coord1[0] != i || coord1[1] != j) &&
            (coord2[0] != i || coord2[1] != j)) {
          tableColor[i][j] = Colors.black;
        }
      }
    }
    setState(() {});
  }

  void conditionChecker(int lastX, int lastY) {
    final int lastPlayer = table[lastX][lastY];
    if (isOnDiagonal(lastX, lastY)) {
      final int diag = checkDiagonal(lastX, lastY, lastPlayer);
      if (diag != -1) {
        if (diag == 1) {
          // ignore: always_specify_types
          drawWinner([
            // ignore: always_specify_types
            [0, 0],
            // ignore: always_specify_types
            [1, 1],
            // ignore: always_specify_types
            [2, 2]
          ]);
          return;
        } else {
          // ignore: always_specify_types
          drawWinner([
            // ignore: always_specify_types
            [0, 2],
            // ignore: always_specify_types
            [1, 1],
            // ignore: always_specify_types
            [2, 0]
          ]);
          return;
        }
      }
    }
    if (checkColumn(lastY, lastPlayer)) {
      // ignore: always_specify_types
      drawWinner([
        // ignore: always_specify_types
        [0, lastY],
        // ignore: always_specify_types
        [1, lastY],
        // ignore: always_specify_types
        [2, lastY]
      ]);
    } else if (checkRow(lastX, lastPlayer)) {
      // ignore: always_specify_types
      drawWinner([
        // ignore: always_specify_types
        [lastX, 0],
        // ignore: always_specify_types
        [lastX, 1],
        // ignore: always_specify_types
        [lastX, 2]
      ]);
    } else if (isFull()) {
      setState(() {
        _isVisible = true;
        _enabledTap = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          GridView.builder(
            shrinkWrap: true,
            itemCount: 9,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
            ),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  onTap: () {
                    if (_enabledTap == true) {
                      _onTap(index);
                    }
                  },
                  child: AnimatedContainer(
                      color: tableColor[index ~/ 3][index % 3], duration: const Duration(milliseconds: 500)));
            },
          ),
          Visibility(
            visible: _isVisible,
            child: RaisedButton(
              color: Colors.blueGrey,
              child: const Text('Reset',
                  style: TextStyle(
                    color: Colors.white,
                  )),
              onPressed: () {
                setState(() {
                  _isVisible = false;
                  _enabledTap = true;
                  // ignore: always_specify_types
                  table = List<List<int>>.generate(3, (int i) => [0, 0, 0], growable: false);
                  // ignore: always_specify_types
                  tableColor = List<List<Color>>.generate(3, (int i) => [Colors.black, Colors.black, Colors.black],
                      growable: false);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
