import 'package:flutter/material.dart';
import 'tile.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final String title = "Minesweeper";
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

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: MineField(rows: 3, columns: 3, mines: 21),
    );
  }
}

class MineField extends StatefulWidget {
  MineField({Key key, this.rows, this.columns, this.mines}) : super(key: key);
  final int rows;
  final int columns;
  final int mines;

  @override
  MineFieldState createState() => MineFieldState(rows, columns, mines);
}

class MineFieldState extends State<MineField> {
  MineFieldState(this.rows, this.columns, this.mines) {
    mineField = new List.filled(rows * columns, 0);

    mineField[0] = 1; // top left
    mineField[2] = 2; // top right
    mineField[6] = 3; // bottom left
    mineField[8] = 4; // bottom right
    // Generate mines.
  }
  List<int> mineField;
  int rows;
  int columns;
  int mines;

  int _getElement(int x, int y) {
    if (_isInBounds(x, y)) throw ArgumentError('Out of bounds!');

    int rowTranslated = y * widget.rows;

    return rowTranslated + x;
  }

  bool _isInBounds(int x, int y) {
    return x >= 0 && x < this.columns && y >= 0 && y < this.rows;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: getMineField(),
    );
  }

  Widget getMineField() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: getRows(),
    );
  }

  List<Widget> getRows() {
    List<Widget> rows = new List(this.rows);
    for (int i = 0; i < this.rows; i++) {
      int rowStart = i * this.rows;
      var children = this
          .mineField
          .sublist(rowStart, rowStart + 3)
          .map((int index) => Tile())
          .toList();

      rows[i] = Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      );
    }
    return rows;
  }
}
