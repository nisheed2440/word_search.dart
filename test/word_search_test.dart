import 'dart:math';

import 'package:test/test.dart';

import '../lib/word_search.dart';

void main() {
  test('should create error on empty word list', () {
    final WordSearch wordSearch = WordSearch();
    final WSNewPuzzle newPuzzle = wordSearch.newPuzzle(
      [],
      WSSettings(),
    );
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
      ),
    );
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
  test('should fill empty spaces with custom fill function', () {
    final randomLetters = [];
    randomLetters.addAll('!@#\$%^&*()-+/'.split(''));
    final WordSearch wordSearch = WordSearch();
    final WSNewPuzzle newPuzzle = wordSearch.newPuzzle(
      ['hello', 'world'],
      WSSettings(
        width: 10,
        height: 10,
        fillBlanks: () {
          return randomLetters[Random().nextInt(randomLetters.length)];
        },
      ),
    );
    expect(newPuzzle.puzzle, isNot(equals(null)));
    print(newPuzzle.toString());
  });
  test('should fill empty spaces with custom fill string', () {
    final WordSearch wordSearch = WordSearch();
    final WSNewPuzzle newPuzzle = wordSearch.newPuzzle(
      ['hello', 'world'],
      WSSettings(
        width: 5,
        height: 5,
        fillBlanks: '123456789!@#\$%^&*()-+=_{}|/?><',
      ),
    );
    expect(newPuzzle.warnings.length, isNot(equals(0)));
    expect(newPuzzle.puzzle, isNot(equals(null)));
    print(newPuzzle.toString());
  });

  test('should return error if all custom fill lettters are used up', () {
    final WordSearch wordSearch = WordSearch();
    final WSNewPuzzle newPuzzle = wordSearch.newPuzzle(
      ['hello', 'world'],
      WSSettings(
        width: 5,
        height: 5,
        fillBlanks: 'abc',
        allowExtraBlanks: false,
      ),
    );
    expect(newPuzzle.errors.length, isNot(equals(0)));
    expect(newPuzzle.puzzle, equals(null));
  });

  test('should solve created puzzle', () {
    final WordSearch wordSearch = WordSearch();
    final WSNewPuzzle newPuzzle = wordSearch.newPuzzle(
      ['hello', 'world'],
      WSSettings(),
    );
    WSSolved solved = wordSearch.solvePuzzle(newPuzzle.puzzle, ['hello', 'world', 'test']);
    expect(solved.found.length, equals(2));
    expect(solved.notFound.length, equals(1));
  });
}
