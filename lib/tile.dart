import 'package:flutter/material.dart';
import 'package:vibrate/vibrate.dart';

class TileInfo {
  TileInfo(this.ix);

  int ix;
  int mineCount = 0;
  TileMode mode = TileMode.initial;
}

enum TileMode {
  initial,
  initialMine,
  probed,
  flagged,
  flaggedMine,
  probedMine,
}

class Tile extends StatefulWidget {
  Tile({Key key, this.info, this.gameOver, this.onProbe}) : super(key: key);

  final TileInfo info;
  final bool gameOver;
  final void Function(int) onProbe;

  void probe() {
    onProbe(info.ix);
  }

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    var g = widget.gameOver;

    switch (widget.info.mode) {
      empty:
      case TileMode.initial:
        return buildTile('');
      case TileMode.initialMine:
        if (!g) {
          continue empty;
        }
        return buildTile('💣');
      case TileMode.probed:
        return buildTile('${widget.info.mineCount}');
      case TileMode.flagged:
        if (!g) {
          continue flag;
        }
        return buildTile('✖');
      flag:
      case TileMode.flaggedMine:
        return buildTile('🚩');
      case TileMode.probedMine:
        return buildTile('💥');
    }
  }

  Color getBackground() {
    var g = widget.gameOver;
    switch (widget.info.mode) {
      case TileMode.initial:
        return Colors.grey[500];
      case TileMode.initialMine:
        return Colors.grey[500];
      case TileMode.flagged:
        return Colors.grey[500];
      case TileMode.flaggedMine:
        return Colors.grey[500];
      case TileMode.probed:
        return Colors.grey[400];
      case TileMode.probedMine:
        return Colors.red;
    }
  }

  Widget buildTile(String text) {
    return GestureDetector(
      onTap: widget.probe,
      onLongPress: setFlag,
      child: Container(
        child: Text(text, textAlign: TextAlign.center),
        decoration: BoxDecoration(
          color: getBackground(),
          borderRadius: BorderRadius.circular(3),
        ),
        width: 40,
        height: 40,
        padding: EdgeInsets.all(12.5),
        margin: EdgeInsets.all(2.5),
      ),
    );
  }

  void setFlag() {
    bool vibrate = true;
    switch (widget.info.mode) {
      case TileMode.initial:
      case TileMode.initialMine:
        setState(() => widget.info.mode = TileMode.flagged);
        break;
      case TileMode.flagged:
      case TileMode.flaggedMine:
        setState(() => widget.info.mode = TileMode.initial);
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
}
