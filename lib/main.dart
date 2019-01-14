import 'package:flutter/material.dart';
import 'board.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final String title = 'Minesweeper';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: HomeScreen(title: title),
    );
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  HomeScreenState createState() => HomeScreenState();
}

enum MinesweeperScreens {
  board,
  options,
}

class HomeScreenState extends State<HomeScreen> {
  static int rows = 7, cols = 7, mines = 10;
  MinesweeperScreens screen = MinesweeperScreens.board;
  Board myBoard = Board(rows: rows, cols: cols, mines: mines);

  void resetBoard() {
    myBoard = Board(rows: rows, cols: cols, mines: mines);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    switch (screen) {
      case MinesweeperScreens.board:
        return buildScaffold(myBoard);
      case MinesweeperScreens.options:
        return buildScaffold(Container(
          padding: EdgeInsets.all(40),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Text("Rows: "),
                  Text(rows.toString()),
                  Expanded(
                    child: Slider(
                      max: (deviceSize.height ~/ 55).toDouble(),
                      min: 3,
                      value: rows.toDouble(),
                      onChanged: (val) {
                        setState(() {
                          rows = val.toInt();
                          resetBoard();
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  const Text("Columns: "),
                  Text(cols.toString()),
                  Expanded(
                    child: Slider(
                      max: (deviceSize.width ~/ 50).toDouble(),
                      min: 3,
                      value: cols.toDouble(),
                      onChanged: (val) {
                        setState(() {
                          cols = val.toInt();
                          resetBoard();
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  const Text("Mines: "),
                  Text(mines.toString()),
                  Expanded(
                    child: Slider(
                      max: 20,
                      min: 1,
                      value: mines.toDouble(),
                      onChanged: (val) {
                        setState(() {
                          mines = val.toInt();
                          resetBoard();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
      default:
        throw "MinesweeperScreens cannot be null!";
    }
  }

  @visibleForTesting
  Scaffold buildScaffold(Widget body) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.games),
            onPressed: () {
              setState(() {
                screen = MinesweeperScreens.board;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              setState(() {
                screen = MinesweeperScreens.options;
              });
            },
          ),
        ],
      ),
      body: body,
    );
  }
}
