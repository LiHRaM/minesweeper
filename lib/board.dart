import 'package:flutter/material.dart';
import 'package:vibrate/vibrate.dart';
import 'dart:math';
import 'tile.dart';
import 'package:fireworks/fireworks.dart';

@visibleForTesting
class Tiles {
  Tiles(this.info, this._rows, this._cols);
  final List<TileInfo> info;
  final int _rows, _cols;

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
        ix -= _cols;
        break;
      case BoardDirection.down:
        ix += _cols;
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
  Board({Key key, this.rows, this.cols, this.mines}) : super(key: key);
  final int rows, cols, mines;

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  Tiles tiles;
  int probedCount = 0;
  bool gameOver = false;

  @override
  void initState() {
    _resetBoard();
    super.initState();
  }

  List<TileInfo> _generateTiles() {
    return List.generate(widget.rows * widget.cols, (int index) {
      return TileInfo(index);
    });
  }

  void _setMines() {
    var rng = new Random();
    for (int i = 0; i < widget.mines; i++) {
      int ix = rng.nextInt(widget.rows * widget.cols);

      if (tiles.info[ix].mode == TileMode.initial) {
        tiles.info[ix].mode = TileMode.initialMine;
        tiles.onNeighbors(ix, _tryUpdate);
      } else {
        i--;
      }
    }
  }

  void _genTiles() {
    tiles = Tiles(_generateTiles(), widget.rows, widget.cols);
    probedCount = 0;
  }

  void _resetBoard() {
    _genTiles();
    _setMines();
    gameOver = false;
  }

  bool gameWon() => tiles.info.length - probedCount == widget.mines;

  /// Check whether a tile contains a mine. Game is over if a tile with a mine is probed.
  void probe(int ix) {
    if (gameOver) return;

    var tile = tiles.info[ix];
    if (tile.mode == TileMode.initial || tile.mode == TileMode.initialMine) {
      if (tile.mode == TileMode.initialMine) {
        setState(() {
          tile.mode = TileMode.probedMine;
          gameOver = true;
        });
        Vibrate.vibrate();
      } else {
        setState(() {
          tile.mode = TileMode.probed;
          probedCount++;
          if (gameWon()) {
            gameOver = true;
          }
          if (tile.mineCount == 0) {
            tiles.onNeighbors(ix, probe);
          }
        });
      }
    }
  }

  /// Places a flag upon a tile, marking a mine.
  void flag(int ix) {
    if (gameOver) return;

    var vibrate = true;
    var tile = tiles.info[ix];
    switch (tile.mode) {
      case TileMode.initial:
        setState(() => tile.mode = TileMode.flagged);
        break;
      case TileMode.initialMine:
        setState(() {
          tile.mode = TileMode.flaggedMine;
        });
        break;
      case TileMode.flagged:
        setState(() => tile.mode = TileMode.initial);
        break;
      case TileMode.flaggedMine:
        setState(() {
          tile.mode = TileMode.initialMine;
        });
        break;
      case TileMode.probed:
      case TileMode.probedMine:
        vibrate = false;
        break;
    }

    if (vibrate) {
      Vibrate.feedback(FeedbackType.heavy);
    }
  }

  void _tryUpdate(int ix) {
    if (ix < 0 || ix >= widget.rows * widget.cols) {
      return;
    }

    tiles.info[ix].mineCount++;
  }

  Widget buildFireworks() {
    if (gameOver && gameWon()) {
      return Fireworks(
        delay: 1,
        numberOfExplosions: 3,
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        child: Column(children: [
          Expanded(child: _getMineField()),
          _buildResetButton(),
        ]),
      ),
      buildFireworks(),
    ]);
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

  /// Transform the list into rows and build them in the minefield
  List<Widget> _buildRows() {
    List<Widget> rows = new List(widget.rows);
    for (int i = 0; i < widget.rows; i++) {
      var row = _getRow(i * widget.cols);
      rows[i] = _buildRow(row
          .map((TileInfo info) => Tile(
              info: info, gameOver: gameOver, onProbe: probe, onFlag: flag))
          .toList());
    }
    return rows;
  }

  /// Return a row, starting at rowStart and ending at (not including) rowStart + cols
  List<TileInfo> _getRow(int rowStart) {
    return tiles.info.sublist(rowStart, rowStart + widget.cols);
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
