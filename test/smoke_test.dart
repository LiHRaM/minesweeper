import 'package:flutter_test/flutter_test.dart';
import 'package:minesweeper/board.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Build 2x2', (WidgetTester tester) async {
    await tester.pumpWidget(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return MaterialApp(
            home: Material(
              child: Board(rows: 2, cols: 2, mines: 1),
            ),
          );
        },
      ),
    );
  });

  testWidgets('Build 3x2', (WidgetTester tester) async {
    await tester.pumpWidget(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return MaterialApp(
            home: Material(
              child: Board(rows: 3, cols: 2, mines: 1),
            ),
          );
        },
      ),
    );
  });

  testWidgets('Build 2x3', (WidgetTester tester) async {
    await tester.pumpWidget(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return MaterialApp(
            home: Material(
              child: Board(rows: 2, cols: 3, mines: 1),
            ),
          );
        },
      ),
    );
  });
}