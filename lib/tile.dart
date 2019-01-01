import 'package:flutter/material.dart';
import 'package:vibrate/vibrate.dart';

class Tile extends StatefulWidget {
  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  TileMode tileMode = TileMode.Initial;
  bool isMine;
  int mines = 0;

  @override
  Widget build(BuildContext context) {
    switch (this.tileMode) {
      case TileMode.Initial:
        return buildTile('');
      case TileMode.Probed:
        return buildTile('$mines');
      case TileMode.Flagged:
        return buildTile('🚩');
    }
  }

  Color getBackground() {
    switch (this.tileMode) {
      case TileMode.Initial: case TileMode.Flagged:
        return Colors.grey[500];
      case TileMode.Probed:
        return Colors.grey[400];
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
      setState(() => this.tileMode = TileMode.Probed);
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
}
