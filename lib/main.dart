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

class HomeScreenState extends State<HomeScreen> {
  Board myBoard = Board(rows: 7, columns: 7, mines: 6);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: myBoard,
    );
  }
}

class GameOverNotification extends Notification {}
