import 'package:flutter/material.dart';
import 'package:vibrate/vibrate.dart';

class TileInfo {
  int mineCount = 0;
  bool isMine = false;
}

class Tile extends StatefulWidget {
  Tile({Key key, this.info, this.gameOver, this.onGameOver}) : super(key: key);

  final TileInfo info;
  final bool gameOver;
  final ValueChanged<bool> onGameOver;

  @override
  _TileState createState() => _TileState(info, gameOver);
}

class _TileState extends State<Tile> {
  _TileState(this.info, this.gameOver);
  TileInfo info;
  TileMode tileMode = TileMode.Initial;
  final bool gameOver;

  @override
  Widget build(BuildContext context) {
    if (widget.gameOver) {
      switch (tileMode) {
        case TileMode.Initial:
        case TileMode.Probed:
          tileMode = TileMode.Probed;
          if (info.isMine) {
            return buildTile('💣');
          }
          return buildTile('${info.mineCount}');
        case TileMode.Flagged:
          if (info.isMine) {
            return buildTile('🚩');
          }
          return buildTile('✖');
        case TileMode.Exploded:
          return buildTile('💥');
      }
    } else {
      switch (this.tileMode) {
        case TileMode.Initial:
          return buildTile('');
        case TileMode.Probed:
          if (info.isMine) {
            return buildTile('💣');
          }
          return buildTile('${info.mineCount}');
        case TileMode.Flagged:
          return buildTile('🚩');
        case TileMode.Exploded:
          return buildTile('💥');
      }
    }
  }

  Color getBackground() {
    switch (this.tileMode) {
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
      onTap: probe,
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

  void probe() {
    if (this.tileMode == TileMode.Initial) {
      setState(() {
        if (info.isMine) {
          this.tileMode = TileMode.Exploded;
          widget.onGameOver(true);
        } else {
          this.tileMode = TileMode.Probed;
        }
      });
    }
  }

  void setFlag() {
    bool vibrate = true;
    switch (this.tileMode) {
      case TileMode.Initial:
        setState(() => this.tileMode = TileMode.Flagged);
        break;
      case TileMode.Flagged:
        setState(() => this.tileMode = TileMode.Initial);
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
