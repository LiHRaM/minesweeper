import 'package:flutter/material.dart';
import 'package:vibrate/vibrate.dart';
import 'dart:math';
import 'tile.dart';

class Board extends StatefulWidget {
  Board({Key key, this.rows, this.columns, this.mines}) : super(key: key);
  final int rows;
  final int columns;
  final int mines;

  @override
  _BoardState createState() => _BoardState(rows, columns, mines);
}

class _BoardState extends State<Board> {
  _BoardState(this.rows, this.columns, this.mines) {
    tiles = new List.generate(rows * columns, (int index) => TileInfo());
    var rng = new Random();
    for (int i = 0; i < mines; i++) {
      int ix = rng.nextInt(rows * columns);

      if (tiles[ix].isMine == false) {
        this.tiles[ix].isMine = true;
        updateNeighbors(ix);
      } else {
        i--;
      }
    }
  }
  List<TileInfo> tiles;
  bool gameOver = false;
  int rows;
  int columns;
  int mines;

  void updateNeighbors(int ix) {
    tryUpdate(getIx(ix, BoardDirection.Up));
    tryUpdate(getIx(ix, BoardDirection.Down));
    tryUpdate(getIx(ix, BoardDirection.Left));
    tryUpdate(getIx(ix, BoardDirection.Right));

    tryUpdate(getIx(getIx(ix, BoardDirection.Up), BoardDirection.Left));
    tryUpdate(getIx(getIx(ix, BoardDirection.Up), BoardDirection.Right));
    tryUpdate(getIx(getIx(ix, BoardDirection.Down), BoardDirection.Left));
    tryUpdate(getIx(getIx(ix, BoardDirection.Down), BoardDirection.Right));
  }

  void tryUpdate(int ix) {
    if (ix < 0 || ix >= rows * columns) {
      return;
    }

    tiles[ix].mineCount++;
  }

  int getIx(int ix, BoardDirection dir) {
    switch (dir) {
      case BoardDirection.Up:
        return ix - columns;
      case BoardDirection.Down:
        return ix + columns;
      case BoardDirection.Left:
        if (ix % rows == 0) {
          return -1;
        }
        return ix - 1;
      case BoardDirection.Right:
        if (ix % rows == columns - 1) {
          return -1;
        }
        return ix + 1;
    }
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
      var list = this.tiles.sublist(rowStart, rowStart + this.columns);
      rows[i] = buildRow(list
          .map((TileInfo info) => Tile(
              info: info,
              gameOver: gameOver,
              onGameOver: _handleGameOverChanged))
          .toList());
    }
    return rows;
  }

  void _handleGameOverChanged(bool gameOver) {
    setState(() {
      this.gameOver = true;
    });

    Vibrate.vibrate();
  }

  Widget buildRow(List<Tile> tiles) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: tiles,
    );
  }
}

enum BoardDirection {
  Up,
  Down,
  Left,
  Right,
}
