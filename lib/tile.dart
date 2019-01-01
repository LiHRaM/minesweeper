import 'package:flutter/material.dart';
import 'package:vibrate/vibrate.dart';

class TileInfo {
  TileInfo(this.ix);

  int ix;
  int mineCount = 0;
  bool isMine = false;
  TileMode mode = TileMode.initial;
}

enum TileMode {
  initial,
  probed,
  flagged,
  exploded,
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
    if (widget.gameOver) {
      switch (widget.info.mode) {
        case TileMode.initial:
        case TileMode.probed:
          widget.info.mode = TileMode.probed;
          if (widget.info.isMine) {
            return buildTile('💣');
          }
          return buildTile('${widget.info.mineCount}');
        case TileMode.flagged:
          if (widget.info.isMine) {
            return buildTile('🚩');
          }
          return buildTile('✖');
        case TileMode.exploded:
          return buildTile('💥');
      }
    } else {
      switch (widget.info.mode) {
        case TileMode.initial:
          return buildTile('');
        case TileMode.probed:
          if (widget.info.isMine) {
            return buildTile('💣');
          }
          return buildTile('${widget.info.mineCount}');
        case TileMode.flagged:
          return buildTile('🚩');
        case TileMode.exploded:
          return buildTile('💥');
      }
    }
  }

  Color getBackground() {
    switch (widget.info.mode) {
      case TileMode.initial:
      case TileMode.flagged:
        return Colors.grey[500];
      case TileMode.probed:
        return Colors.grey[400];
      case TileMode.exploded:
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
        setState(() => widget.info.mode = TileMode.flagged);
        break;
      case TileMode.flagged:
        setState(() => widget.info.mode = TileMode.initial);
        break;
      case TileMode.probed:
      case TileMode.exploded:
        vibrate = false;
        break;
    }

    if (vibrate) {
      Vibrate.feedback(FeedbackType.heavy);
    }
  }
}
