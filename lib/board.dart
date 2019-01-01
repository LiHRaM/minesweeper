import 'package:flutter/material.dart';
import 'package:vibrate/vibrate.dart';
import 'dart:math';
import 'tile.dart';

@visibleForTesting
class Tiles {
  Tiles(this.info, this._rows, this._columns);
  final List<TileInfo> info;
  final int _rows;
  final int _columns;

  /// Performs the provided function on all valid neighbors.
  @visibleForTesting
  void onNeighbors(int ix, void Function(int) callback) {
    List<int> neighbors = List();

    neighbors.addAll([
      getIx(ix, BoardDirection.up),
      getIx(ix, BoardDirection.down),
      getIx(ix, BoardDirection.left),
      getIx(ix, BoardDirection.right),
      getIx(getIx(ix, BoardDirection.up), BoardDirection.left),
      getIx(getIx(ix, BoardDirection.up), BoardDirection.right),
      getIx(getIx(ix, BoardDirection.down), BoardDirection.left),
      getIx(getIx(ix, BoardDirection.down), BoardDirection.right),
    ]);

    neighbors.forEach((int val) {
      if (val >= 0 && val < info.length) callback(val);
    });
  }

  /// Gets the index of a tile in a specific direction.
  /// Returns -1 if it is out of bounds.
  @visibleForTesting
  int getIx(int ix, BoardDirection dir) {
    switch (dir) {
      case BoardDirection.up:
        ix -= _columns;
        break;
      case BoardDirection.down:
        ix += _columns;
        break;
      case BoardDirection.left:
        if (ix % _rows == 0) {
          ix = -1;
        }
        ix--;
        break;
      case BoardDirection.right:
        if (ix % _rows == _rows - 1) {
          ix = -1;
        } else {
          ix++;
        }
    }
    if (ix >= info.length || ix < 0)
      return -1;
    else
      return ix;
  }
}

class Board extends StatefulWidget {
  Board({Key key, this.rows, this.columns, this.mines}) : super(key: key);
  final int rows;
  final int columns;
  final int mines;

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  Tiles tiles;
  bool gameOver = false;
  bool won = false;

  @override
  void initState() {
    _resetBoard();
    super.initState();
  }

  List<TileInfo> _generateTiles() {
    return List.generate(widget.rows * widget.columns, (int index) {
      return TileInfo(index);
    });
  }

  void _setMines() {
    var rng = new Random();
    for (int i = 0; i < widget.mines; i++) {
      int ix = rng.nextInt(widget.rows * widget.columns);

      if (tiles.info[ix].mode == TileMode.initial) {
        tiles.info[ix].mode = TileMode.initialMine;
        tiles.onNeighbors(ix, _tryUpdate);
      } else {
        i--;
      }
    }
  }

  void _resetBoard() {
    setState(() => gameOver = false);
    tiles = Tiles(_generateTiles(), widget.rows, widget.columns);
    _setMines();
  }

  void _probe(int ix) {
    if (gameOver) return;

    var tile = tiles.info[ix];
    if (tile.mode == TileMode.initial || tile.mode == TileMode.initialMine) {
      setState(() {
        if (tile.mode == TileMode.initialMine) {
          tile.mode = TileMode.probedMine;
          gameOver = true;
          Vibrate.vibrate();
        } else {
          tile.mode = TileMode.probed;
          if (tile.mineCount == 0) {
            tiles.onNeighbors(ix, _probe);
          }
        }
      });
    }
  }

  void _tryUpdate(int ix) {
    if (ix < 0 || ix >= widget.rows * widget.columns) {
      return;
    }

    tiles.info[ix].mineCount++;
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
      rows[i] = _buildRow(_getRow(i * widget.rows)
          .map((TileInfo info) =>
              Tile(info: info, gameOver: gameOver, onProbe: _probe))
          .toList());
    }
    return rows;
  }

  List<TileInfo> _getRow(int rowStart) {
    return tiles.info.sublist(rowStart, rowStart + widget.columns);
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
  up,
  down,
  left,
  right,
}
