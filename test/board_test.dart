import 'package:flutter_test/flutter_test.dart';

import 'package:minesweeper/board.dart';
import 'package:minesweeper/tile.dart';

void main() {
  group("Tiles class", () {
    // This group tests the correctness of the onNeighbors function.
    // Specifically, that it behaves correctly in corner cases.
    List<TileInfo> infoStub(int length) {
      return List.generate(length, (int ix) => TileInfo(ix));
    }

    List<int> e(Tiles tiles) {
      return tiles.info.map((var info) => info.mineCount).toList();
    }

    group("getIx tests", () {
      var tiles = Tiles(infoStub(9), 3, 3);
      test("Top left corner up", () {
        var ix = tiles.getIx(0, BoardDirection.up);
        expect(ix, -1);
      });
      test("Top left corner left", () {
        var ix = tiles.getIx(0, BoardDirection.left);
        expect(ix, -1);
      });

      test("Top right corner up", () {
        var ix = tiles.getIx(2, BoardDirection.up);
        expect(ix, -1);
      });
      test("Top right corner right", () {
        var ix = tiles.getIx(2, BoardDirection.right);
        expect(ix, -1);
      });
    });

    group("onNeighbors tests", () {
      test('Top left corner', () {
        var tiles = Tiles(infoStub(9), 3, 3);

        tiles.onNeighbors(0, (int ix) => tiles.info[ix].mineCount = 1);

        expect(e(tiles), [0, 1, 0, 1, 1, 0, 0, 0, 0]);
      });

      test('Top right corner', () {
        var tiles = Tiles(infoStub(9), 3, 3);

        tiles.onNeighbors(2, (int ix) => tiles.info[ix].mineCount = 1);

        expect(e(tiles), [0, 1, 0, 0, 1, 1, 0, 0, 0]);
      });

      test('Bottom left corner', () {
        var tiles = Tiles(infoStub(9), 3, 3);
        tiles.onNeighbors(6, (int ix) => tiles.info[ix].mineCount = 1);

        expect(e(tiles), [0, 0, 0, 1, 1, 0, 0, 1, 0]);
      });

      test('Bottom right corner', () {
        var tiles = Tiles(infoStub(9), 3, 3);
        tiles.onNeighbors(8, (int ix) => tiles.info[ix].mineCount = 1);

        expect(e(tiles), [0, 0, 0, 0, 1, 1, 0, 1, 0]);
      });
    });

    group("asymmetrical getIx tests", () {
      var tiles = Tiles(infoStub(6), 2, 3);
      // Shape:
      // 0 0 0
      // 0 0 0 

      test("Top left corner up", () {
        var ix = tiles.getIx(0, BoardDirection.up);
        expect(ix, -1);
      });
      test("Top left corner left", () {
        var ix = tiles.getIx(0, BoardDirection.left);
        expect(ix, -1);
      });

      test("Top right corner up", () {
        var ix = tiles.getIx(2, BoardDirection.up);
        expect(ix, -1);
      });
      test("Top right corner right", () {
        var ix = tiles.getIx(2, BoardDirection.right);
        expect(ix, -1);
      });

      test("Bottom left corner down", () {
        var ix = tiles.getIx(3, BoardDirection.down);
        expect(ix, -1);
      });
      test("Bottom left corner left", () {
        var ix = tiles.getIx(3, BoardDirection.left);
        expect(ix, -1);
      });

      test("Bottom right corner down", () {
        var ix = tiles.getIx(5, BoardDirection.down);
        expect(ix, -1);
      });
      test("Top right corner right", () {
        var ix = tiles.getIx(5, BoardDirection.right);
        expect(ix, -1);
      });
    });
  });
}
