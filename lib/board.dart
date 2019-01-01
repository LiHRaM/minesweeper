import 'package:flutter/material.dart';
import 'dart:math';
import 'tile.dart';

class Board extends StatefulWidget {
  Board({Key key, this.rows, this.columns, this.mines}) : super(key: key);
  final int rows;
  final int columns;
  final int mines;

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  List<TileInfo> tiles;
  bool gameOver = false;

  @override
  void initState() {
    _resetBoard();
    super.initState();
  }

  void _resetBoard() {
    setState(() => gameOver = false);
    tiles = new List.generate(
        widget.rows * widget.columns, (int index) => TileInfo(index));
    var rng = new Random();
    for (int i = 0; i < widget.mines; i++) {
      int ix = rng.nextInt(widget.rows * widget.columns);

      if (tiles[ix].isMine == false) {
        this.tiles[ix].isMine = true;
        _onNeighbors(ix, _tryUpdate);
      } else {
        i--;
      }
    }
  }

  void probe(int ix) {
    var tile = tiles[ix];
    if (tile.mode == TileMode.Initial) {
      setState(() {
        if (tile.isMine) {
          tile.mode = TileMode.Exploded;
          gameOver = true;
        } else {
          tile.mode = TileMode.Probed;
          if (tile.mineCount == 0) {
            _onNeighbors(ix, probe);
          }
        }
      });
    }
  }

  void _onNeighbors(int ix, void Function(int) callback) {
    callback(getIx(ix, BoardDirection.Up));
    callback(getIx(ix, BoardDirection.Down));
    callback(getIx(ix, BoardDirection.Left));
    callback(getIx(ix, BoardDirection.Right));

    callback(getIx(getIx(ix, BoardDirection.Up), BoardDirection.Left));
    callback(getIx(getIx(ix, BoardDirection.Up), BoardDirection.Right));
    callback(getIx(getIx(ix, BoardDirection.Down), BoardDirection.Left));
    callback(getIx(getIx(ix, BoardDirection.Down), BoardDirection.Right));
  }

  void _tryUpdate(int ix) {
    if (ix < 0 || ix >= widget.rows * widget.columns) {
      return;
    }

    tiles[ix].mineCount++;
  }

  int getIx(int ix, BoardDirection dir) {
    switch (dir) {
      case BoardDirection.Up:
        return ix - widget.columns;
      case BoardDirection.Down:
        return ix + widget.columns;
      case BoardDirection.Left:
        if (ix % widget.rows == 0) {
          return -1;
        }
        return ix - 1;
      case BoardDirection.Right:
        if (ix % widget.rows == widget.columns - 1) {
          return -1;
        }
        return ix + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Expanded(child: _getMineField()),
        _buildResetButton(),
      ]),
    );
  }

  Widget _buildResetButton() {
    return IconButton(
      icon: Icon(Icons.autorenew),
      onPressed: () {
        setState(() => _resetBoard());
      },
    );
  }

  Widget _getMineField() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buildRows(),
    );
  }

  List<Widget> _buildRows() {
    List<Widget> rows = new List(widget.rows);
    for (int i = 0; i < widget.rows; i++) {
      int rowStart = i * widget.rows;
      var list = this.tiles.sublist(rowStart, rowStart + widget.columns);
      rows[i] = _buildRow(list
          .map((TileInfo info) => Tile(
              info: info,
              gameOver: gameOver,
              onProbe: probe))
          .toList());
    }
    return rows;
  }

  Widget _buildRow(List<Tile> tiles) {
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
