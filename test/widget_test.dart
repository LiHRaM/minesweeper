import 'package:flutter_test/flutter_test.dart';
import 'package:minesweeper/board.dart';
import 'package:flutter/material.dart';
import 'package:minesweeper/tile.dart';

void main() {
  StatefulBuilder builderStub(Board board) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return MaterialApp(
          home: Material(
            child: board,
          ),
        );
      },
    );
  }

  testWidgets('2x2 has 2 rows', (WidgetTester tester) async {
    await tester.pumpWidget(builderStub(
      Board(rows: 2, cols: 2, mines: 1),
    ));

    // 2 rows
    expect(find.byType(Row), findsNWidgets(2));
  });

  testWidgets('3x2 has 3 rows', (WidgetTester tester) async {
    await tester.pumpWidget(builderStub(
      Board(rows: 3, cols: 2, mines: 1),
    ));

    // 2 rows
    expect(find.byType(Row), findsNWidgets(3));
  });

  testWidgets('2x3 has 2 rows', (WidgetTester tester) async {
    await tester.pumpWidget(builderStub(
      Board(rows: 2, cols: 3, mines: 1),
    ));

    // 2 rows
    expect(find.byType(Row), findsNWidgets(2));
  });

    testWidgets('2x2 has 2 rows', (WidgetTester tester) async {
    await tester.pumpWidget(builderStub(
      Board(rows: 2, cols: 2, mines: 1),
    ));

    // 2 rows
    expect(find.byType(Tile), findsNWidgets(4));
  });

  testWidgets('3x2 has 6 tiles', (WidgetTester tester) async {
    await tester.pumpWidget(builderStub(
      Board(rows: 3, cols: 2, mines: 1),
    ));

    // 2 rows
    expect(find.byType(Tile), findsNWidgets(6));
  });

  testWidgets('2x3 has 6 tiles', (WidgetTester tester) async {
    await tester.pumpWidget(builderStub(
      Board(rows: 2, cols: 3, mines: 1),
    ));

    // 2 rows
    expect(find.byType(Tile), findsNWidgets(6));
  });
}
