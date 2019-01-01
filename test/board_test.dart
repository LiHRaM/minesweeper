import 'package:flutter_test/flutter_test.dart';

import 'package:minesweeper/board.dart';
import 'package:minesweeper/tile.dart';

void main() {
  group("Testing tiles class", () {
    // This group tests the correctness of the onNeighbors function.
    // Specifically, that it behaves correctly in corner cases.

    /**
     * 0 0 0 
     * 0 0 0 
     * 0 0 0 
     * => 
     * 0 1 0
     * 1 1 0
     * 0 0 0 
     * 
     * Is an example of the first method, which tests that only three of the neighbors have been transformed.
     */


    List<TileInfo> infoStub(int length) {
      return List.generate(length, (int ix) => TileInfo(ix));
    }

    test('Top right corner', () {
      var tiles = Tiles(infoStub(9), 3, 3);

      tiles.onNeighbors(0, (int ix) => tiles.info[ix].mineCount = 1);

      expect(tiles.info[1].mineCount, 1);
      expect(tiles.info[3].mineCount, 1);
      expect(tiles.info[4].mineCount, 1);
    });

    test('Top left corner', () {
      var tiles = Tiles(infoStub(9), 3, 3);
      tiles.onNeighbors(2, (int ix) => tiles.info[ix].mineCount = 1);

      expect(tiles.info[1].mineCount, 1);
      expect(tiles.info[4].mineCount, 1);
      expect(tiles.info[5].mineCount, 1);
    });

    test('Bottom right corner', () {
      var tiles = Tiles(infoStub(9), 3, 3);
      tiles.onNeighbors(6, (int ix) => tiles.info[ix].mineCount = 1);

      expect(tiles.info[3].mineCount, 1);
      expect(tiles.info[4].mineCount, 1);
      expect(tiles.info[7].mineCount, 1);
    });

    test('Bottom left corner', () {
      var tiles = Tiles(infoStub(9), 3, 3);
      tiles.onNeighbors(8, (int ix) => tiles.info[ix].mineCount = 1);

      expect(tiles.info[4].mineCount, 1);
      expect(tiles.info[5].mineCount, 1);
      expect(tiles.info[7].mineCount, 1);
    });
  });
}
