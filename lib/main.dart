import 'package:flutter/material.dart';

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
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      // body: MineField(rows: 3, columns: 3, mines: 21),
    );
  }
}

class MineField extends StatefulWidget {
  MineField({Key key, this.rows, this.columns, this.mines}) : super(key: key);
  final int rows;
  final int columns;
  final int mines;

  @override
  _MineFieldState createState() => _MineFieldState();
}

class _MineFieldState extends State<MineField> {
  _MineFieldState() {
    mineField = new List.filled(widget.rows * widget.columns, 0);
  }
  List<int> mineField;

  int _getElement(int x, int y) {
    if (_isInBounds(x, y)) throw ArgumentError('Out of bounds!');

    int rowTranslated = y * widget.rows;

    return rowTranslated + x;
  }

  bool _isInBounds(int x, int y) {
    return x >= 0 && x < widget.columns
        && y >= 0 && y < widget.rows;
  }

  Widget _getMineField() {
    return Column(
      children: this.mineField.map((int index) => Text('0')).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: _getMineField(),
    );
  }
}
