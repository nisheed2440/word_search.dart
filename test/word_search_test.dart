import 'package:test/test.dart';

import '../lib/word-search.dart';

void main() {
  test('should create error on empty word list', () {
    final WordSearch wordSearch = WordSearch();
    final WSNewPuzzle newPuzzle = wordSearch.newPuzzle([], WSSettings());
    expect(newPuzzle.errors, equals(['Zero words provided']));
    expect(newPuzzle.puzzle, equals(null));
  });
  test('should create new puzzle', () {
    final WordSearch wordSearch = WordSearch();
    final WSNewPuzzle newPuzzle = wordSearch.newPuzzle(
        ['hello', 'world'],
        WSSettings(
          width: 5,
          height: 5,
        ));
    expect(newPuzzle.errors, equals([]));
    expect(newPuzzle.puzzle, isNot(equals(null)));
  });
  test('should create error while trying to fit words in smaller grid', () {
    final WordSearch wordSearch = WordSearch();
    final WSNewPuzzle newPuzzle = wordSearch.newPuzzle(
      ['hello', 'world', 'random', 'number', 'alexander'],
      WSSettings(
        width: 3,
        height: 3,
        maxGridGrowth: 2,
        orientations: List.from(
          [
            WSOrientation.horizontal,
            WSOrientation.vertical,
          ],
        ),
      ),
    );
    expect(
      newPuzzle.errors,
      equals(['No valid 5x5 grid found and not allowed to grow more']),
    );
    expect(newPuzzle.puzzle, equals(null));
  });
}
