# word_search

![Coverage](https://raw.githubusercontent.com/nisheed2440/word_search.dart/master/coverage_badge.svg?version=0.1.1)

![Word Search](https://raw.githubusercontent.com/nisheed2440/word_search.dart/master/word-search.png?version=0.1.1)

A word search puzzle generator built with dart

### Example Usage

```dart
import 'package:word_search/word_search.dart';

/**
 * The main file to test out the word search library
 */
void main() {
  print('Word Search Library!');

  // Create a list of words to be jumbled into a puzzle
  final List<String> wl = ['hello', 'world', 'foo', 'bar', 'baz', 'dart'];

  // Create the puzzle settings object
  final WSSettings ws = WSSettings(
    width: 10,
    height: 10,
    orientations: List.from([
      WSOrientation.horizontal,
      WSOrientation.vertical,
      WSOrientation.diagonal,
    ]),
  );

  // Create new instance of the WordSearch class
  final WordSearch wordSearch = WordSearch();

  // Create a new puzzle
  final WSNewPuzzle newPuzzle = wordSearch.newPuzzle(wl, ws);

  /// Check if there are errors generated while creating the puzzle
  if (newPuzzle.errors.isEmpty) {
    // The puzzle output
    print('Puzzle 2D List');
    print(newPuzzle.toString());

    // Solve puzzle for given word list
    final WSSolved solved =
        wordSearch.solvePuzzle(newPuzzle.puzzle, ['dart', 'word']);
    // All found words by solving the puzzle
    print('Found Words!');
    solved.found.forEach((element) {
      print('word: ${element.word}, orientation: ${element.orientation}');
      print('x:${element.x}, y:${element.y}');
    });

    // All words that could not be found
    print('Not found Words!');
    solved.notFound.forEach((element) {
      print('word: ${element}');
    });
  } else {
    // Notify the user of the errors
    newPuzzle.errors.forEach((error) {
      print(error);
    });
  }
}
```

### Example Output
![Word Search output](https://raw.githubusercontent.com/nisheed2440/word_search.dart/master/word-search.gif?version=0.1.1)

### Testing
This library uses [`test_coverage`](https://pub.dev/packages/test_coverage) testing library.

To run tests

```bash
pub run test_coverage
```

To view coverage report

```bash
genhtml -o coverage coverage/lcov.info
```

**Note:** If you do not have `genhtml` on your command line you can use `brew install lcov` on mac.
