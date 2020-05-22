import '../lib/word-search.dart';

/**
 * The main file to test out the word search library
 */
void main() {
  print('Word Search Library!');
  final List<String> wl = ['hello', 'world', 'foo', 'bar', 'baz', 'dart'];
  final WSSettings ws = WSSettings(
    width: 10,
    height: 10,
    orientations: List.from([
      WSOrientation.horizontal,
      WSOrientation.vertical,
      WSOrientation.diagonal,
    ]),
  );
  final WordSearch wordSearch = WordSearch();
  final WSNewPuzzle newPuzzle = wordSearch.newPuzzle(wl, ws);

  /// The Puzzle output
  print('Puzzle 2D List');
  print(newPuzzle.toString());

  /// Solve puzzle for given word list
  final WSSolved solved = wordSearch.solvePuzzle(newPuzzle.puzzle, ['dart', 'word']);
  /// All found words by solving the puzzle
  print('Found Words!');
  solved.found.forEach((element) {
    print('word: ${element.word}, orientation: ${element.orientation}');
    print('x:${element.x}, y:${element.y}');
  });

  /// All words that could not be found
  print('Not found Words!');
  solved.notFound.forEach((element) {
    print('word: ${element}');
  });
}
