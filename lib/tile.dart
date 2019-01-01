import 'package:flutter/material.dart';
import 'package:vibrate/vibrate.dart';

class TileInfo {
  TileInfo(this.ix);

  int ix;
  int mineCount = 0;
  bool isMine = false;
  TileMode mode = TileMode.Initial;
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
        case TileMode.Initial:
        case TileMode.Probed:
          widget.info.mode = TileMode.Probed;
          if (widget.info.isMine) {
            return buildTile('💣');
          }
          return buildTile('${widget.info.mineCount}');
        case TileMode.Flagged:
          if (widget.info.isMine) {
            return buildTile('🚩');
          }
          return buildTile('✖');
        case TileMode.Exploded:
          return buildTile('💥');
      }
    } else {
      switch (widget.info.mode) {
        case TileMode.Initial:
          return buildTile('');
        case TileMode.Probed:
          if (widget.info.isMine) {
            return buildTile('💣');
          }
          return buildTile('${widget.info.mineCount}');
        case TileMode.Flagged:
          return buildTile('🚩');
        case TileMode.Exploded:
          return buildTile('💥');
      }
    }
  }

  Color getBackground() {
    switch (widget.info.mode) {
      case TileMode.Initial:
      case TileMode.Flagged:
        return Colors.grey[500];
      case TileMode.Probed:
        return Colors.grey[400];
      case TileMode.Exploded:
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
      case TileMode.Initial:
        setState(() => widget.info.mode = TileMode.Flagged);
        break;
      case TileMode.Flagged:
        setState(() => widget.info.mode = TileMode.Initial);
        break;
      case TileMode.Probed:
      case TileMode.Exploded:
        vibrate = false;
        break;
    }

    if (vibrate) {
      Vibrate.feedback(FeedbackType.heavy);
    }
  }
}

enum TileMode {
  Initial,
  Probed,
  Flagged,
  Exploded,
}
